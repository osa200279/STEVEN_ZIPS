package kr.or.ddit.domain.apt.mgmtOffice.meter.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.mapper.IMeterHstryMapper;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterUploadHstryVO;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.UtilityProviderVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 검침 이력 Service 구현체
 * - 검침 이력 목록 조회
 * - CSV 원본 파일 Google Drive 업로드
 * - ATTACH_FILE 파일 메타정보 저장
 * - METER_UPLOAD_HSTRY 업로드 이력 저장
 * - METER_HSTRY 검침 이력 등록
 */
@Service
@RequiredArgsConstructor
public class MeterHstryServiceImpl implements IMeterHstryService {

    /** 검침 이력 Mapper */
    private final IMeterHstryMapper meterHstryMapper;

    /** Google Drive 파일 업로드 서비스 */
    private final GoogleDriveService googleDriveService;

    /** 공통 첨부파일 Mapper */
    private final IAttachFileMapper attachFileMapper;

    /** CSV 파일 분류값 */
    private static final String FILE_CAT_METER_CSV = "METER_CSV";

    /** 업로드 성공 상태값 */
    private static final String UPLOAD_DONE = "DONE";

    /** 업로드 실패 상태값 */
    private static final String UPLOAD_FAIL = "FAIL";

    /**
     * 검침 이력 목록 조회
     */
    @Override
    public List<MeterHstryVO> selectMeterHstryList(Map<String, Object> paramMap) {
        // 관리사무소 번호로 단지번호 조회
        String mgmtOfcNo = String.valueOf(paramMap.get("mgmtOfcNo"));
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        // 조회 조건에 단지번호 추가
        paramMap.put("aptCmplexNo", aptCmplexNo);

        // 검침 이력 목록 조회
        return meterHstryMapper.selectMeterHstryList(paramMap);
    }

    /**
     * 공급/검침 설정 목록 조회
     */
    @Override
    public List<UtilityProviderVO> selectUtilityProviderList(String mgmtOfcNo) {
        // 관리사무소 번호로 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        // 화면 선택용 공급/검침 설정 목록 조회
        return meterHstryMapper.selectUtilityProviderList(aptCmplexNo);
    }

    /**
     * 검침결과 공통코드 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectMeterRsltCodeList() {
        // 검침결과 공통코드 목록 조회
        return meterHstryMapper.selectMeterRsltCodeList();
    }

    /**
     * 검침 CSV 업로드 처리
     * - 부분 성공은 처리하지 않음
     * - CSV 전체 검증 후 이상 없을 때만 Google Drive 업로드 및 METER_HSTRY 등록을 진행함
     * - CSV 원본 파일은 Google Drive 업로드 후 ATTACH_FILE에 저장함
     * - 로그인 사용자 번호는 METER_UPLOAD_HSTRY.UPLOAD_USER_NO에 저장함
     */
    @Override
    @Transactional
    public int uploadMeterCsv(
            String mgmtOfcNo,
            String utilityProviderNo,
            MultipartFile csvFile,
            String uploadUserNo
    ) throws Exception {
        // 기본 입력값 검증
        validateUploadInput(utilityProviderNo, csvFile);

        // 관리사무소 번호 기준 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        if (!StringUtils.hasText(aptCmplexNo)) {
            throw new IllegalArgumentException("관리사무소에 연결된 단지 정보를 찾을 수 없습니다.");
        }

        // 공급/검침 설정 조회 조건 구성
        Map<String, Object> providerParam = new HashMap<>();
        providerParam.put("aptCmplexNo", aptCmplexNo);
        providerParam.put("utilityProviderNo", utilityProviderNo);

        // 공급/검침 설정 조회
        UtilityProviderVO provider = meterHstryMapper.selectUtilityProviderDetail(providerParam);
        if (provider == null) {
            throw new IllegalArgumentException("선택한 공급/검침 설정을 찾을 수 없습니다.");
        }

        // 업로드 이력번호 생성
        String uploadNo = createUploadNo();

        /*
         * 1. CSV 파싱 먼저 수행
         * - 파일을 Google Drive에 올리기 전에 CSV 내용이 비어 있는지 확인함
         * - 여기서 실패하면 Google Drive에는 아무 파일도 올라가지 않음
         */
        List<Map<String, String>> csvRows = parseCsv(csvFile);
        if (csvRows.isEmpty()) {
            throw new IllegalArgumentException("CSV 데이터 행이 없습니다.");
        }

        /*
         * 2. CSV 전체 행 검증 및 VO 변환 먼저 수행
         * - facility_no, ho_no, meter_rslt_cd 등의 오류를 파일 업로드 전에 잡기 위한 순서
         * - 여기서 실패하면 Google Drive에는 아무 파일도 올라가지 않음
         */
        List<MeterHstryVO> meterRows = convertAndValidateRows(csvRows, provider, aptCmplexNo);

        /*
         * 3. 검증이 모두 끝난 뒤에만 CSV 원본 파일 업로드
         * - Google Drive 업로드는 DB 트랜잭션처럼 자동 롤백되지 않으므로 최대한 뒤에서 실행함
         */
        Long fileGroupNo = saveCsvAttachFile(csvFile, aptCmplexNo, uploadNo);

        try {
            // 검증 완료된 검침 이력 등록
            for (MeterHstryVO meterHstryVO : meterRows) {
                meterHstryMapper.insertMeterHstry(meterHstryVO);
            }

            // 업로드 성공 이력 등록
            insertUploadHistory(uploadNo, provider, fileGroupNo, meterRows.size(), UPLOAD_DONE, null, uploadUserNo);

            // 등록 건수 반환
            return meterRows.size();

        } catch (Exception e) {
            /*
             * DB 저장 중 실패 이력 등록
             * - 이 시점은 이미 Google Drive 업로드가 끝난 뒤라 파일은 남을 수 있음
             * - 그래도 CSV 검증 오류는 위에서 먼저 막기 때문에 불필요한 Drive 파일은 줄어듦
             */
            insertUploadHistory(uploadNo, provider, fileGroupNo, 0, UPLOAD_FAIL, e.getMessage(), uploadUserNo);

            // Controller에서 메시지 처리할 수 있도록 예외 재전달
            throw e;
        }
    }

    /**
     * 업로드 기본 입력값 검증
     */
    private void validateUploadInput(String utilityProviderNo, MultipartFile csvFile) {
        // 공급/검침 설정 선택 여부 확인
        if (!StringUtils.hasText(utilityProviderNo)) {
            throw new IllegalArgumentException("공급/검침 업체를 선택해주세요.");
        }

        // 파일 선택 여부 확인
        if (csvFile == null || csvFile.isEmpty()) {
            throw new IllegalArgumentException("업로드할 CSV 파일을 선택해주세요.");
        }

        // 확장자 확인
        String originalFilename = csvFile.getOriginalFilename();
        if (!StringUtils.hasText(originalFilename) || !originalFilename.toLowerCase().endsWith(".csv")) {
            throw new IllegalArgumentException("CSV 파일만 업로드할 수 있습니다.");
        }
    }

    /**
     * CSV 원본 파일 Google Drive 업로드 및 ATTACH_FILE 등록
     * - 기존 프로젝트의 GoogleDriveService.uploadFile() 흐름 사용
     * - ATTACH_FILE.GOOGLE_ID는 Google Drive 업로드 결과값으로 저장
     * - 반환값은 METER_UPLOAD_HSTRY.FILE_GROUP_NO에 연결할 파일그룹번호
     */
    private Long saveCsvAttachFile(MultipartFile csvFile, String aptCmplexNo, String uploadNo) throws Exception {
        // 원본 파일명 확인
        String originalFilename = csvFile.getOriginalFilename();

        // 원본 파일명이 비어 있을 때 기본 파일명 사용
        if (!StringUtils.hasText(originalFilename)) {
            originalFilename = "meter_upload.csv";
        }

        // 저장 파일명 생성
        String uuid = UUID.randomUUID().toString().replace("-", "");
        String savedFileName = uuid + "_" + originalFilename;

        // Google Drive 폴더 경로 생성
        LocalDate today = LocalDate.now();
        String folderPath = "apt/meter/"
                + aptCmplexNo + "/"
                + today.getYear() + "/"
                + String.format("%02d", today.getMonthValue()) + "/"
                + uploadNo;

        // 첨부파일 카테고리
        String cat = FILE_CAT_METER_CSV;

        // Google Drive 업로드 실행
        String googleId = googleDriveService.uploadFile(csvFile, folderPath, savedFileName);

        // 공통 첨부파일 그룹번호 채번
        long fileGroupNo = attachFileMapper.getSeqFileGroupNo();

        // 공통 AttachFileVO 생성
        AttachFileVO attachFile = AttachFileVO.fileSettings(
                csvFile,
                fileGroupNo,
                cat,
                savedFileName,
                googleId,
                folderPath,
                1
        );

        // ATTACH_FILE 저장
        attachFileMapper.insertAttachFile(attachFile);

        // 업로드 이력과 연결할 파일그룹번호 반환
        return fileGroupNo;
    }

    /**
     * CSV 파일 파싱
     * - 첫 줄은 헤더로 사용함
     * - 큰따옴표로 감싼 쉼표는 하나의 값으로 처리함
     */
    private List<Map<String, String>> parseCsv(MultipartFile csvFile) throws IOException {
        List<Map<String, String>> resultList = new ArrayList<>();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(csvFile.getInputStream(), StandardCharsets.UTF_8))) {
            String headerLine = reader.readLine();

            // 헤더가 없으면 빈 목록 반환
            if (!StringUtils.hasText(headerLine)) {
                return resultList;
            }

            // BOM 제거 및 헤더 분리
            headerLine = headerLine.replace("\uFEFF", "");
            List<String> headers = splitCsvLine(headerLine);

            String line;
            int lineNo = 1;

            while ((line = reader.readLine()) != null) {
                lineNo++;

                // 빈 줄은 무시
                if (!StringUtils.hasText(line)) {
                    continue;
                }

                // 행 데이터를 헤더 기준 Map으로 변환
                List<String> values = splitCsvLine(line);
                Map<String, String> rowMap = new HashMap<>();
                rowMap.put("_lineNo", String.valueOf(lineNo));

                for (int i = 0; i < headers.size(); i++) {
                    String key = headers.get(i).trim();
                    String value = i < values.size() ? values.get(i).trim() : "";
                    rowMap.put(key, value);
                }

                resultList.add(rowMap);
            }
        }

        return resultList;
    }

    /**
     * CSV 한 줄 분리
     * - 간단한 CSV 따옴표 처리를 포함함
     */
    private List<String> splitCsvLine(String line) {
        List<String> values = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;

        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);

            // 따옴표 상태 전환
            if (ch == '"') {
                inQuotes = !inQuotes;
                continue;
            }

            // 따옴표 밖 쉼표는 컬럼 구분자
            if (ch == ',' && !inQuotes) {
                values.add(current.toString());
                current.setLength(0);
                continue;
            }

            // 일반 문자 추가
            current.append(ch);
        }

        // 마지막 컬럼 추가
        values.add(current.toString());

        return values;
    }

    /**
     * CSV 행 검증 및 검침 이력 VO 변환
     */
    private List<MeterHstryVO> convertAndValidateRows(List<Map<String, String>> csvRows, UtilityProviderVO provider, String aptCmplexNo) {
        List<MeterHstryVO> meterRows = new ArrayList<>();

        for (Map<String, String> row : csvRows) {
            String lineNo = row.get("_lineNo");

            // 필수 컬럼 값 추출
            String csvIdntfKey = row.get("csv_idntf_key");
            String extCustNo = row.get("ext_cust_no");
            String facilityNo = row.get("facility_no");
            String hoNo = row.get("ho_no");
            String meterDt = row.get("meter_dt");
            String preVal = row.get("pre_val");
            String currVal = row.get("curr_val");
            String meterCn = row.get("meter_cn");
            String meterRsltCd = row.get("meter_rslt_cd");

            // 공급/검침 설정 식별값 검증
            if (!provider.getCsvIdntfKey().equals(csvIdntfKey) || !provider.getExtCustNo().equals(extCustNo)) {
                throw new IllegalArgumentException(lineNo + "행: CSV 식별키 또는 외부 고객번호가 선택한 공급/검침 설정과 일치하지 않습니다.");
            }

            // 필수값 검증
            validateRequired(lineNo, "facility_no", facilityNo);
            validateRequired(lineNo, "ho_no", hoNo);
            validateRequired(lineNo, "meter_dt", meterDt);
            validateRequired(lineNo, "pre_val", preVal);
            validateRequired(lineNo, "curr_val", currVal);
            validateRequired(lineNo, "meter_cn", meterCn);
            validateRequired(lineNo, "meter_rslt_cd", meterRsltCd);

            // 시설 존재 여부 검증
            Map<String, Object> facilityParam = new HashMap<>();
            facilityParam.put("aptCmplexNo", aptCmplexNo);
            facilityParam.put("facilityNo", facilityNo);

            if (meterHstryMapper.selectFacilityCnt(facilityParam) == 0) {
                throw new IllegalArgumentException(lineNo + "행: 존재하지 않는 시설번호입니다. facility_no=" + facilityNo);
            }

            // 검침결과코드 유효성 검증
            if (meterHstryMapper.selectMeterRsltCodeCnt(meterRsltCd) == 0) {
                throw new IllegalArgumentException(lineNo + "행: 존재하지 않는 검침결과코드입니다. meter_rslt_cd=" + meterRsltCd);
            }

            // 검침 이력 VO 구성
            MeterHstryVO vo = new MeterHstryVO();
            vo.setFacilityNo(facilityNo);
            vo.setHoNo(hoNo);
            vo.setMeterDt(java.sql.Date.valueOf(LocalDate.parse(meterDt)));
            vo.setPreVal(new BigDecimal(preVal));
            vo.setCurrVal(new BigDecimal(currVal));
            vo.setMeterCn(meterCn);
            vo.setMeterRsltCd(meterRsltCd);
            vo.setUtilityProviderNo(provider.getUtilityProviderNo());

            meterRows.add(vo);
        }

        return meterRows;
    }

    /**
     * 필수값 검증
     */
    private void validateRequired(String lineNo, String columnName, String value) {
        if (!StringUtils.hasText(value)) {
            throw new IllegalArgumentException(lineNo + "행: " + columnName + " 값이 비어 있습니다.");
        }
    }

    /**
     * 업로드 이력 등록
     */
    private void insertUploadHistory(
            String uploadNo,
            UtilityProviderVO provider,
            Long fileGroupNo,
            int totalCnt,
            String statusCd,
            String errCn,
            String uploadUserNo
    ) {
        MeterUploadHstryVO uploadVO = new MeterUploadHstryVO();

        // 업로드 이력 기본값 세팅
        uploadVO.setMeterUploadHstryNo(uploadNo);
        uploadVO.setUtilityProviderNo(provider.getUtilityProviderNo());
        uploadVO.setAptCmplexNo(provider.getAptCmplexNo());
        uploadVO.setFileGroupNo(fileGroupNo);
        uploadVO.setUploadUserNo(uploadUserNo);
        uploadVO.setTotalCnt(totalCnt);
        uploadVO.setUploadSttsCd(statusCd);
        uploadVO.setErrCn(errCn);
        uploadVO.setRmrkCn("CSV 검침 이력 업로드");

        // 업로드 이력 등록
        meterHstryMapper.insertMeterUploadHstry(uploadVO);
    }

    /**
     * 업로드 이력번호 생성
     * - 시퀀스를 만들지 않는 방향이므로 시간 기반 문자열을 사용함
     */
    private String createUploadNo() {
        return "MUH" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyMMddHHmmss"));
    }
}

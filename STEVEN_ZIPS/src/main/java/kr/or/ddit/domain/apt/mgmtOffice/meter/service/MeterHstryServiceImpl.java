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
     * 검침유형 공통코드 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectMeterTyCodeList() {
        // 검침유형 공통코드 목록 조회
        return meterHstryMapper.selectMeterTyCodeList();
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
            String meterScope,
            String utilityProviderNo,
            MultipartFile csvFile,
            String uploadUserNo
    ) throws Exception {
        // 기본 입력값 검증
        validateUploadInput(utilityProviderNo, csvFile);
        validateMeterScope(meterScope);

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
        List<MeterHstryVO> meterRows = convertAndValidateRows(csvRows, provider, aptCmplexNo, meterScope);

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
     * 검침 구분값 검증
     */
    private void validateMeterScope(String meterScope) {
        // 화면에서 넘기는 검침 구분값이 없으면 서버에서 단지/시설 검침을 판단할 수 없으므로 막음
        if (!StringUtils.hasText(meterScope)) {
            throw new IllegalArgumentException("검침 구분값이 없습니다.");
        }

        // 현재 화면 기준으로 허용하는 검침 구분값만 통과시킴
        if (!"COMPLEX".equals(meterScope) && !"FACILITY".equals(meterScope)) {
            throw new IllegalArgumentException("올바르지 않은 검침 구분값입니다.");
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
    private List<MeterHstryVO> convertAndValidateRows(List<Map<String, String>> csvRows, UtilityProviderVO provider, String aptCmplexNo, String meterScope) {
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
            validateProviderKeys(lineNo, provider, csvIdntfKey, extCustNo);

            // 검침 구분별 필수값 검증
            if ("COMPLEX".equals(meterScope)) {
                // 단지별 검침은 시설자산 선택 대상이 아니므로 facility_no가 비어 있으면 공급/검침 설정번호를 내부값으로 저장함
                if (!StringUtils.hasText(facilityNo)) {
                    facilityNo = provider.getUtilityProviderNo();
                }
                // 단지별 검침은 동/호 기준 이력이므로 ho_no가 반드시 있어야 함
                validateRequired(lineNo, "ho_no", hoNo);
                hoNo = normalizeHoNo(aptCmplexNo, hoNo);
            } else {
                // 시설 검침은 시설자산 기준 이력이므로 facility_no를 반드시 검증하고 ho_no를 저장하지 않음
                validateRequired(lineNo, "facility_no", facilityNo);
                hoNo = null;

                Map<String, Object> facilityParam = new HashMap<>();
                facilityParam.put("aptCmplexNo", aptCmplexNo);
                facilityParam.put("facilityNo", facilityNo);

                if (meterHstryMapper.selectFacilityCnt(facilityParam) == 0) {
                    throw new IllegalArgumentException(lineNo + "행: 존재하지 않는 시설번호입니다. facility_no=" + facilityNo);
                }
            }
            validateRequired(lineNo, "meter_dt", meterDt);
            validateRequired(lineNo, "pre_val", preVal);
            validateRequired(lineNo, "curr_val", currVal);
            validateRequired(lineNo, "meter_cn", meterCn);
            validateRequired(lineNo, "meter_rslt_cd", meterRsltCd);

            // 검침결과코드 유효성 검증
            if (meterHstryMapper.selectMeterRsltCodeCnt(meterRsltCd) == 0) {
                throw new IllegalArgumentException(lineNo + "행: 존재하지 않는 검침결과코드입니다. meter_rslt_cd=" + meterRsltCd);
            }

            // 검침 이력 VO 구성
            MeterHstryVO vo = new MeterHstryVO();
            vo.setFacilityNo(facilityNo);
            vo.setHoNo(StringUtils.hasText(hoNo) ? hoNo : null);
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
     * 공급/검침 설정 식별값 검증
     * - csv_idntf_key는 공급/검침 설정값이 있을 때만 비교함
     * - ext_cust_no는 외부 업체가 관리하는 고객번호 성격이므로 설정값이 있을 때만 비교함
     */
    private void validateProviderKeys(String lineNo, UtilityProviderVO provider, String csvIdntfKey, String extCustNo) {
        // CSV 식별키가 설정되어 있으면 CSV 값과 비교함
        if (StringUtils.hasText(provider.getCsvIdntfKey()) && !provider.getCsvIdntfKey().equals(csvIdntfKey)) {
            throw new IllegalArgumentException(lineNo + "행: CSV 식별키가 선택한 공급/검침 설정과 일치하지 않습니다.");
        }

        // 외부 고객번호가 설정되어 있으면 CSV 값과 비교함
        if (StringUtils.hasText(provider.getExtCustNo()) && !provider.getExtCustNo().equals(extCustNo)) {
            throw new IllegalArgumentException(lineNo + "행: 외부 고객번호가 선택한 공급/검침 설정과 일치하지 않습니다.");
        }
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
     * 단지별 검침 세대번호 정규화
     * - 화면 입력값이 4_1502, 4동 1502호, A12127003_4_1502 중 어떤 형태여도 DB 저장 형태로 맞춤
     */
    private String normalizeHoNo(String aptCmplexNo, String hoNo) {
        if (!StringUtils.hasText(hoNo)) {
            return hoNo;
        }

        String value = hoNo.trim().replace("동", "_").replace("호", "").replace(" ", "");
        value = value.replaceAll("_+", "_");

        if (value.startsWith(aptCmplexNo + "_")) {
            return value;
        }

        if (value.contains("_")) {
            return aptCmplexNo + "_" + value;
        }

        return aptCmplexNo + "_" + value;
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

    /**
     * 검침 이력 수동 등록
     */
    @Override
    @Transactional
    public int insertMeterHstry(String mgmtOfcNo, String meterScope, MeterHstryVO meterHstryVO) {
        // 검침 구분값 검증
        validateMeterScope(meterScope);

        // 관리사무소 번호 기준 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        if (!StringUtils.hasText(aptCmplexNo)) {
            throw new IllegalArgumentException("관리사무소에 연결된 단지 정보를 찾을 수 없습니다.");
        }

        // 공급/검침 설정 선택 여부 확인
        if (!StringUtils.hasText(meterHstryVO.getUtilityProviderNo())) {
            throw new IllegalArgumentException("공급/검침 계약을 선택해주세요.");
        }

        // 선택한 공급/검침 설정이 현재 단지에 속하는지 확인
        Map<String, Object> providerParam = new HashMap<>();
        providerParam.put("aptCmplexNo", aptCmplexNo);
        providerParam.put("utilityProviderNo", meterHstryVO.getUtilityProviderNo());
        UtilityProviderVO provider = meterHstryMapper.selectUtilityProviderDetail(providerParam);
        if (provider == null) {
            throw new IllegalArgumentException("선택한 공급/검침 설정을 찾을 수 없습니다.");
        }

        // 단지별 검침은 세대 동/호 기준, 시설 검침은 시설자산 기준으로 완전히 분리함
        if ("COMPLEX".equals(meterScope)) {
            if (!StringUtils.hasText(meterHstryVO.getHoNo())) {
                throw new IllegalArgumentException("단지별 검침은 동/호 번호가 필요합니다.");
            }
            // 화면에서는 4동/1502호처럼 입력하고, DB에는 APT단지번호_동_호 형태로 저장함
            meterHstryVO.setHoNo(normalizeHoNo(aptCmplexNo, meterHstryVO.getHoNo()));

            // METER_HSTRY.FACILITY_NO는 NOT NULL이라 단지검침용 내부값을 저장하되 화면에는 시설정보로 노출하지 않음
            if (!StringUtils.hasText(meterHstryVO.getFacilityNo())) {
                meterHstryVO.setFacilityNo(provider.getUtilityProviderNo());
            }
        } else {
            if (!StringUtils.hasText(meterHstryVO.getFacilityNo())) {
                throw new IllegalArgumentException("시설 검침은 시설번호를 선택해주세요.");
            }
            Map<String, Object> facilityParam = new HashMap<>();
            facilityParam.put("aptCmplexNo", aptCmplexNo);
            facilityParam.put("facilityNo", meterHstryVO.getFacilityNo());
            if (meterHstryMapper.selectFacilityCnt(facilityParam) == 0) {
                throw new IllegalArgumentException("존재하지 않는 시설번호입니다. facility_no=" + meterHstryVO.getFacilityNo());
            }
            meterHstryVO.setHoNo(null);
        }

        // 검침결과코드 유효성 확인
        if (!StringUtils.hasText(meterHstryVO.getMeterRsltCd()) || meterHstryMapper.selectMeterRsltCodeCnt(meterHstryVO.getMeterRsltCd()) == 0) {
            throw new IllegalArgumentException("올바른 검침결과를 선택해주세요.");
        }

        // 검증 완료 후 단건 등록
        return meterHstryMapper.insertMeterHstry(meterHstryVO);
    }

    /**
     * 시설 검침 등록용 시설 단건 조회
     */
    @Override
    public MeterHstryVO selectFacilityInfo(String mgmtOfcNo, String facilityNo) {
        // 시설번호 입력 여부 확인
        if (!StringUtils.hasText(facilityNo)) {
            throw new IllegalArgumentException("시설번호를 입력해주세요.");
        }

        // 관리사무소 번호 기준 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        if (!StringUtils.hasText(aptCmplexNo)) {
            throw new IllegalArgumentException("관리사무소에 연결된 단지 정보를 찾을 수 없습니다.");
        }

        // 현재 단지에 속한 시설만 조회
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("aptCmplexNo", aptCmplexNo);
        paramMap.put("facilityNo", facilityNo.trim());
        MeterHstryVO facility = meterHstryMapper.selectFacilityInfo(paramMap);

        // 시설이 없으면 화면에서 안내할 수 있도록 예외 처리
        if (facility == null) {
            throw new IllegalArgumentException("현재 단지에서 시설번호를 찾을 수 없습니다. facility_no=" + facilityNo);
        }
        return facility;
    }

    /**
     * 단지 검침 등록용 동 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectDongNoList(String mgmtOfcNo) {
        // 관리사무소 번호 기준 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        // 기존 검침 이력의 HO_NO에서 동 정보를 추출해 화면 select에 사용함
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("aptCmplexNo", aptCmplexNo);
        return meterHstryMapper.selectDongNoList(paramMap);
    }

    /**
     * 단지 검침 등록용 호 자동완성 조회
     */
    @Override
    public List<Map<String, Object>> selectHoSuggestList(String mgmtOfcNo, String dongNo, String keyword) {
        // 관리사무소 번호 기준 단지번호 조회
        String aptCmplexNo = meterHstryMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        // 선택 동과 입력 키워드로 기존 검침 이력의 호 후보를 조회함
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("aptCmplexNo", aptCmplexNo);
        paramMap.put("dongNo", dongNo);
        paramMap.put("keyword", keyword);
        return meterHstryMapper.selectHoSuggestList(paramMap);
    }

    /**
     * 검침 이력 단건 상세 조회
     */
    @Override
    public MeterHstryVO selectMeterHstryDetail(String meterHstryNo) {
        return meterHstryMapper.selectMeterHstryDetail(meterHstryNo);
    }

    /**
     * 검침 이력 수정
     */
    @Override
    public int updateMeterHstry(MeterHstryVO meterHstryVO) {
        return meterHstryMapper.updateMeterHstry(meterHstryVO);
    }
}

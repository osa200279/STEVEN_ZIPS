package kr.or.ddit.domain.apt.apiApartment.service;

import kr.or.ddit.domain.apt.apiApartment.mapper.IApiMemberMapper;
import kr.or.ddit.domain.apt.apiApartment.mapper.IAptApiMapper;
import kr.or.ddit.domain.apt.apiApartment.vo.*;
import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.apt.main.vo.AptUnitVO;
import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.member.vo.AuthVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import tools.jackson.databind.ObjectMapper;

import java.util.*;
import java.util.function.Consumer;

@Service
@Slf4j
public class AptApiServiceImpl implements IAptApiService {

    @Autowired
    private IAptApiMapper aptMapper;

    @Autowired
    private IApiMemberMapper memberMapper;

    @Autowired
    private ISeqService aptService;

    private final String serviceKey = "279564b17283c0863ff904cbfee96deb15c26cd426ec71fe7c5966a865f64f2f";
    private final String kakaoKey = "e91015a224888fbe9e2afc3320c22a1b";
    RestTemplate rt = new RestTemplate();

    @Override
    @Transactional
    public void collectApt(String sido, String sigungu, String emd) {
        log.info("collectMapoApt() 실행됨2...!");

        List<String> lawdCdList = aptMapper.selectLawdCdList(sido, sigungu, emd);

        List<AptListItem> AptItemList = new ArrayList<>();

        for (String bjdCode : lawdCdList) {
            int pageNo = 1;
            while (true) {
                String url = "https://apis.data.go.kr/1613000/AptListService3/getLegaldongAptList3"
                        + "?serviceKey=" + serviceKey
                        + "&pageNo=" + pageNo
                        + "&numOfRows=100"
                        + "&bjdCode=" + bjdCode;

                ResponseEntity<AptListResponse> response =
                        rt.getForEntity(url, AptListResponse.class);

                AptListResponse dto = response.getBody();

                if (dto == null
                        || dto.getResponse() == null
                        || dto.getResponse().getBody() == null) {
                    break;
                }

                List<AptListItem> items = response.getBody().getResponse().getBody().getItems();

                if (items == null || items.isEmpty()) {
                    break;
                }

                AptItemList.addAll(items);

                pageNo++;

            }
        }

        Map<String, AptBass> bassMap = new HashMap<>();

        for (AptListItem item : AptItemList) {

            String kaptCode = item.getKaptCode();


            String url = "https://apis.data.go.kr/1613000/AptBasisInfoServiceV4/getAphusBassInfoV4"
                    + "?serviceKey=" + serviceKey
                    + "&kaptCode=" + kaptCode;

            try {
                ResponseEntity<AptBassResponse> res =
                        rt.getForEntity(url, AptBassResponse.class);

                AptBassResponse dto = res.getBody();

                if (dto == null
                        || dto.getResponse() == null
                        || dto.getResponse().getBody() == null
                        || dto.getResponse().getBody().getItem() == null) {
                    continue;
                }

                AptBass bassItem =
                        dto.getResponse().getBody().getItem();

                bassMap.put(kaptCode, bassItem);

            } catch (Exception e) {
                log.error("kaptCode {} bass API 오류", kaptCode, e);
            }
        }

        Map<String, AptDetail> detailMap = new HashMap<>();

        for (AptListItem item : AptItemList) {

            String kaptCode = item.getKaptCode();

            String url = "https://apis.data.go.kr/1613000/AptBasisInfoServiceV4/getAphusDtlInfoV4"
                    + "?serviceKey=" + serviceKey
                    + "&kaptCode=" + kaptCode;

            try {
                ResponseEntity<AptDetailResponse> res =
                        rt.getForEntity(url, AptDetailResponse.class);

                AptDetailResponse dto = res.getBody();

                if (dto == null
                        || dto.getResponse() == null
                        || dto.getResponse().getBody() == null
                        || dto.getResponse().getBody().getItem() == null) {
                    continue;
                }

                AptDetail detailItem =
                        dto.getResponse().getBody().getItem();

                detailMap.put(kaptCode, detailItem);

            } catch (Exception e) {
                log.error("kaptCode {} detail API 오류", kaptCode, e);
            }
        }



        List<AptInfraEntity> infraEntityList = new ArrayList<>();
        List<AptComplexEntity> entityList = new ArrayList<>();
        List<MgmtOfficeEntity> mgmtOfficeEntityList = new ArrayList<>();
        List<ManagerVO> managerVOList = new ArrayList<>();
        List<MemberVO> memberVOList = new ArrayList<>();
        List<AptUnitVO> aptUnitVOList = new ArrayList<>();
        List<AptDetailVO> aptDetailVOList = new ArrayList<>();
        List<AuthVO> authVOList = new ArrayList<>();
        List<AptHoTyVO> aptHoTyVOList = new ArrayList<>();


        for (AptListItem listItem : AptItemList) {

            String userNo = aptService.getMemberSeq();
            String mgmtOfcNo = aptService.getMgmtSeq();

            AptBass bassItem = bassMap.get(listItem.getKaptCode());
            AptDetail detailItem = detailMap.get(listItem.getKaptCode());
            String welfareFacility = detailMap.get(listItem.getKaptCode()).getWelfareFacility();
            String convenientFacility = detailMap.get(listItem.getKaptCode()).getConvenientFacility();
            String educationFacility = detailMap.get(listItem.getKaptCode()).getEducationFacility();
            String subwayLine = detailMap.get(listItem.getKaptCode()).getSubwayLine();
            String kaptdWtimesub = detailMap.get(listItem.getKaptCode()).getKaptdWtimesub();

            /*      인프라 entity 구성 시작! */
            toInfraEntity(welfareFacility, "WELFARE", listItem.getKaptCode(), infraEntityList);
            toInfraEntity(convenientFacility, "CONVENIENCE", listItem.getKaptCode(), infraEntityList);
            toInfraEntity(educationFacility, "EDUCATION", listItem.getKaptCode(), infraEntityList);
            toInfraEntity2(subwayLine,"TRANSIT_LINES",listItem.getKaptCode(), infraEntityList);
            toInfraEntity2(kaptdWtimesub,"TRANSIT_ACCESS",listItem.getKaptCode(), infraEntityList);
            /*      인프라 entity 구성 끝! */

            /*      단지관리소 entity 구성 시작! */
            toMgmtOfficeEntity(bassItem,mgmtOfficeEntityList,mgmtOfcNo);
            /*      단지관리소 entity 구성 끝! */

            /*      단지관리자(member+manager) entity 구성 시작! */
            toMemberEntity(bassItem,memberVOList, userNo);
            toManagerEntity(managerVOList,userNo, mgmtOfcNo);
            toAuthEntity(authVOList,userNo);
            /*      단지관리자(member) entity 구성 끝! */

            /*      동 테이블 entity 구성 시작! */
            toAptUnitVO(aptUnitVOList,bassItem);
            /*      동 테이블 entity 구성 끝! */

            /*      호 테이블 entity 구성 시작! */
            toAptDetailVO(aptDetailVOList, bassItem);
            /*      호 테이블 entity 구성 끝! */

            /* 호 타입 구성*/
            toAptHoTyVO(aptHoTyVOList, bassItem);

            entityList.add(toEntity(listItem, bassItem,detailItem));
        }



        log.info("총 엔티티 개수: {}", entityList.size());
        log.info("총 인프라 개수: {}", infraEntityList.size());

        entityList.stream().limit(5)
                .forEach(e -> log.info("샘플: {}", e));


        /*                   inser 작업 실행 start                */

        batchInsert(entityList, aptMapper::insertAptBatch);
        batchInsert(mgmtOfficeEntityList, aptMapper::insertMgmtOfficeBatch);
        batchInsert(memberVOList, aptMapper::insertMemberBatch);
        batchInsert(managerVOList, aptMapper::insertManagerBatch);
        batchInsert(authVOList, aptMapper::insertAuthBatch);
        batchInsert(aptUnitVOList, aptMapper::insertAptUnitBatch);
        batchInsert(aptHoTyVOList, aptMapper::insertAptHoTyBatch);
        batchInsert(aptDetailVOList, aptMapper::insertAptDetailBatch);

        for (AptInfraEntity infra : infraEntityList) {
            aptMapper.insertInfraOne(infra);
        }

        log.info("APT {}건 insert 완료", entityList.size());
        log.info("INFRA {}건 insert 완료", infraEntityList.size());
        log.info("MGMT {}건 insert 완료", mgmtOfficeEntityList.size());
        /*                   inser 작업 실행 end                */

    }

    private AptComplexEntity toEntity(AptListItem listItem, AptBass bassItem, AptDetail detailItem) {

        AptComplexEntity apt = new AptComplexEntity();

        // 아파트리스트 api 에서 가져온 정보
        apt.setAptCmplexNo(listItem.getKaptCode());
        apt.setAptCmplexNm(listItem.getKaptName());
        apt.setBjdCd(listItem.getBjdCode());
        apt.setSidoNm(listItem.getAs1());
        apt.setSigunguNm(listItem.getAs2());
        apt.setEmdNm(listItem.getAs3());

        // 기본정보 api 에서 가져온 정보
        if (bassItem != null) {
            apt.setHeatTy(bassItem.getCodeHeatNm());
            apt.setBldYr(bassItem.getKaptUsedate());
            apt.setCnscoNm(bassItem.getKaptBcompany());
            int maxFloor = Math.max(
                    bassItem.getKaptTopFloor(),
                    bassItem.getKtownFlrNo()
            );

            apt.setMaxFloor(maxFloor);

            if (bassItem.getKaptDongCnt() != null
                    && !bassItem.getKaptDongCnt().trim().isEmpty()) {

                apt.setDongCnt(safeParseInt(bassItem.getKaptDongCnt()));
            }
            if (bassItem.getKaptdaCnt() != null
                    && !bassItem.getKaptdaCnt().trim().isEmpty()) {

                apt.setUnitCnt(safeParseInt(bassItem.getKaptdaCnt()));
            }
            apt.setDorojuso(bassItem.getDoroJuso());
        }

        // 상세정보 api 에서 가져온 정보
        if (detailItem != null && "Y".equals(detailItem.getUseYn())){
            if (detailItem.getKaptdPcnt() != null
                    && !detailItem.getKaptdPcnt().trim().isEmpty()) {
                apt.setPkgCnt(safeParseInt(detailItem.getKaptdPcnt())+safeParseInt(detailItem.getKaptdPcntu()));
            }
            if (detailItem.getKaptdCccnt() != null
                    && !detailItem.getKaptdCccnt().trim().isEmpty()) {
                apt.setCcCnt(safeParseInt(detailItem.getKaptdCccnt()));
            }
        }

        return apt;
    }

    private List<AptInfraEntity> toInfraEntity(

            String value,
            String categoryCd,
            String kaptCode,
            List<AptInfraEntity> infraEntityList) {

        if (value == null || value.trim().isEmpty()) return infraEntityList;

        // 괄호 없는 경우
        if (!value.contains("(")) {
            String[] simpleItems = value.split(",");
            for (String name : simpleItems) {

                String trimmed = name.trim();

                if (trimmed.isEmpty()) continue;

                AptInfraEntity infra = new AptInfraEntity();
                infra.setCategoryCd(categoryCd);
                infra.setInfraNm(name.trim());
                infra.setAptCmplexNo(kaptCode);

                infraEntityList.add(infra);
            }
            return infraEntityList;
        }

        // 괄호 있는 경우
        String[] items = value.split("\\) ");

        for (String item : items) {

            item = item.trim();

            if (!item.endsWith(")")) {
                item = item + ")";
            }

            int start = item.indexOf("(");
            int end = item.indexOf(")");

            if (start == -1 || end == -1) continue;

            String inner = item.substring(start + 1, end);

            String[] names = inner.split(",");

            for (String name : names) {

                String trimmed = name.trim();

                if (trimmed.isEmpty()) continue;

                AptInfraEntity infra = new AptInfraEntity();
                infra.setCategoryCd(categoryCd);
                infra.setInfraNm(name.trim());
                infra.setAptCmplexNo(kaptCode);

                infraEntityList.add(infra);
            }
        }

        return infraEntityList;
    }

    private List<AptInfraEntity> toInfraEntity2(
            String value,
            String categoryCd,
            String kaptCode,
            List<AptInfraEntity> infraEntityList) {

        if (value == null || value.trim().isEmpty()) return infraEntityList;

        AptInfraEntity infra = new AptInfraEntity();

        infra.setCategoryCd(categoryCd);
        infra.setAptCmplexNo(kaptCode);
        infra.setInfraNm(value);

        infraEntityList.add(infra);

        return infraEntityList;
    }

    // 카카오 경도위도 API
    private Map<String, String> getLatLng(String address) {

        String url = "https://dapi.kakao.com/v2/local/search/address.json?query=" + address;

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + kakaoKey);

        HttpEntity<String> entity = new HttpEntity<>(headers);

        ResponseEntity<Map> response = rt.exchange(
                url,
                HttpMethod.GET,
                entity,
                Map.class
        );

        ObjectMapper mapper = new ObjectMapper();

        String json = mapper.writeValueAsString(response.getBody());

        List<Map<String, Object>> documents =
                (List<Map<String, Object>>) response.getBody().get("documents");

        if (documents == null || documents.isEmpty()) return null;
        Map<String, Object> first = documents.get(0);

        String lat = (String) first.get("y");
        String lng = (String) first.get("x");

        if (lat == null || lng == null) {
            Map<String, Object> road = (Map<String, Object>) first.get("road_address");
            if (road != null) {
                lat = (String) road.get("y");
                lng = (String) road.get("x");
            }
        }

        if (lat == null || lng == null) {
            Map<String, Object> addr = (Map<String, Object>) first.get("address");
            if (addr != null) {
                lat = (String) addr.get("y");
                lng = (String) addr.get("x");
            }
        }

        if (lat == null || lng == null) {
            return null;
        }

        Map<String, String> result = new HashMap<>();
        result.put("lat", lat);
        result.put("lng", lng);

        return result;
    }
    private List<MgmtOfficeEntity> toMgmtOfficeEntity (AptBass bassItem,List<MgmtOfficeEntity> MgmtOfficeEntityList,String mgmtOfcNo){

        MgmtOfficeEntity mgmtOfficeEntity = new MgmtOfficeEntity();
        mgmtOfficeEntity.setMgmtOfcNo(mgmtOfcNo);
        mgmtOfficeEntity.setAptCmplexNo(bassItem.getKaptCode());
        mgmtOfficeEntity.setMgmtOfcNm(bassItem.getKaptName()+" 관리사무소");

        if (bassItem.getKaptTel() == null || bassItem.getKaptTel().trim().isEmpty()) {
            mgmtOfficeEntity.setMgmtOfcTelno("000-0000");
        } else {
            mgmtOfficeEntity.setMgmtOfcTelno(bassItem.getKaptTel());
        }

        mgmtOfficeEntity.setMgmtOfcBankCd("KB");
        mgmtOfficeEntity.setMgmtOfcAcntHldrNm(bassItem.getKaptName()+" 관리사무소");
        mgmtOfficeEntity.setMgmtOfcAcntNo("0000-0000");

        MgmtOfficeEntityList.add(mgmtOfficeEntity);

        return MgmtOfficeEntityList;
    }

    private List<ManagerVO> toManagerEntity(List<ManagerVO> ManagerList, String userNo, String mgmtOfcNo){

        ManagerVO manager = new ManagerVO();

        manager.setUserNo(userNo);
        manager.setMngrDutyCd("HEAD");
        manager.setMgmtOfcNo(mgmtOfcNo);

        ManagerList.add(manager);

        return ManagerList;
    }

    private List<MemberVO> toMemberEntity(AptBass bassItem, List<MemberVO>memberList, String userNo){

        MemberVO member = new MemberVO();
        member.setUserNo(userNo);
        member.setUserId(bassItem.getKaptCode());
        member.setUserPw("1234");
        member.setUserNm(bassItem.getKaptName()+"_관리소장");
        member.setUserRrno("1234561234567");
        member.setUserTelno(bassItem.getKaptTel());

        memberList.add(member);

        return memberList;
    }

    private List<AuthVO> toAuthEntity(List<AuthVO> authVOList, String userNo){

        AuthVO auth = new AuthVO();

        auth.setUserNo(userNo);
        auth.setAuth("ROLE_MNGR");

        authVOList.add(auth);

        return authVOList;
    }

    private List<AptUnitVO> toAptUnitVO (List<AptUnitVO> AptUnitVOList, AptBass bassItem){

        int dongCnt = 0;
        int TotalunitCnt = 0;
        int unitCnt = 0;
        int unitCntRemain = 0;

        if (bassItem.getKaptdaCnt()!=null&&!bassItem.getKaptdaCnt().trim().isEmpty()){
            TotalunitCnt = safeParseInt(bassItem.getKaptdaCnt());
        }
        if (bassItem.getKaptDongCnt() != null
                && !bassItem.getKaptDongCnt().trim().isEmpty()) {

            dongCnt = safeParseInt(bassItem.getKaptDongCnt());
        }


        if (dongCnt != 0){
            unitCnt = TotalunitCnt/dongCnt;
            unitCntRemain =TotalunitCnt%dongCnt;
        }

        for(int i=1;i<=dongCnt;i++){
            AptUnitVO aptUnitVO = new AptUnitVO();

            aptUnitVO.setDongNo(bassItem.getKaptCode()+"_"+i);
            aptUnitVO.setAptCmplexNo(bassItem.getKaptCode());
            aptUnitVO.setDongNm(i+"");

            int maxFloor = Math.max(
                    bassItem.getKaptTopFloor(),
                    bassItem.getKtownFlrNo()
            );

            aptUnitVO.setFloor(maxFloor);

            if(i == dongCnt){
                aptUnitVO.setUnitCnt(unitCnt+unitCntRemain);
            }else{
                aptUnitVO.setUnitCnt(unitCnt);
            }

            AptUnitVOList.add(aptUnitVO);
        }

        return AptUnitVOList;
    }

    private List<AptDetailVO> toAptDetailVO (List<AptDetailVO> aptDetailVOList, AptBass bassItem){

        int totalUnitCnt = safeParseInt(bassItem.getKaptdaCnt());
        int dongCnt = safeParseInt(bassItem.getKaptDongCnt());
        int maxFloor = Math.max(
                bassItem.getKaptTopFloor(),
                bassItem.getKtownFlrNo()
        );

        if (dongCnt == 0 || maxFloor == 0) return aptDetailVOList;

        int householdsPerFloor = (int) Math.ceil(
                (double) totalUnitCnt / dongCnt / maxFloor
        );

        Map<String, Integer> map = new HashMap<>();
        map.put("60", safeParseInt(bassItem.getKaptMparea60()));
        map.put("85", safeParseInt(bassItem.getKaptMparea85()));
        map.put("135", safeParseInt(bassItem.getKaptMparea135()));
        map.put("136", safeParseInt(bassItem.getKaptMparea136()));

        String maxKey = null;
        int maxValue = Integer.MIN_VALUE;

        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            if (entry.getValue() > maxValue) {
                maxValue = entry.getValue();
                maxKey = entry.getKey();
            }
        }

        for(int i=1; i<=dongCnt; i++){

            int unitCnt = totalUnitCnt / dongCnt;

            if(i == dongCnt){
                unitCnt += totalUnitCnt % dongCnt;
            }

            int unitIndex = 1;

            for(int f=1; f<=maxFloor; f++){
                for(int h=1; h<=householdsPerFloor; h++){

                    if(unitIndex > unitCnt) break;

                    AptDetailVO aptDetail = new AptDetailVO();

                    aptDetail.setDongNo(bassItem.getKaptCode()+"_"+i);
                    aptDetail.setFloor(f);
                    aptDetail.setHo(String.valueOf(f*100 + h));
                    aptDetail.setHoNo(bassItem.getKaptCode()+"_"+i+"_"+(f*100+h));
                    aptDetail.setHoTyNo(bassItem.getKaptCode() + "_1");

                    aptDetailVOList.add(aptDetail);

                    unitIndex++;
                }
            }
        }
        return aptDetailVOList;
    }

    private int safeParseInt(String str) {
        if (str == null || str.trim().isEmpty()) return 0;
        return (int) Double.parseDouble(str);
    }

    private <T> void batchInsert(List<T> list, Consumer<List<T>> mapperFunc) {

        if (list == null || list.isEmpty()) return;

        int batchSize = 200;

        for (int i = 0; i < list.size(); i += batchSize) {
            List<T> subList = list.subList(i, Math.min(i + batchSize, list.size()));
            mapperFunc.accept(subList);
        }
    }

    public void updateLatLng() {

        List<AptComplexEntity> list = aptMapper.selectNoCoordList();

        for (AptComplexEntity apt : list) {

            try {
                Map<String, String> coord = getLatLng(apt.getDorojuso());

                if (coord != null) {
                    apt.setLatVal(Double.parseDouble(coord.get("lat")));
                    apt.setLonVal(Double.parseDouble(coord.get("lng")));

                    aptMapper.updateLatLng(apt);
                }

                Thread.sleep(200);

            } catch (Exception e) {
                log.error("좌표 실패: {}", apt.getAptCmplexNo());
            }
        }
    }


    
    @Override
    public void assignResidents(List<String> aptList, int count) {

        Random random = new Random();

        List<AptDetailVO> units = aptMapper.selectAvailableUnits(aptList);

        List<MemberVO> users = memberMapper.selectNotAssignedTestUsers();

        if (users.isEmpty()) {
            throw new RuntimeException("유저 없음");
        }

        if(units.isEmpty()){
            throw new RuntimeException("호실 없음");
        }

        Collections.shuffle(units);
        Collections.shuffle(users);

        int assigned = 0;
        int userIndex = 0;

        for (AptDetailVO unit : units) {

            if (assigned >= count) break;

            int peopleCnt = 1 + random.nextInt(3);

            for (int i = 0; i < peopleCnt; i++) {

                if (assigned >= count || userIndex >= users.size()) break;

                MemberVO user = users.get(userIndex);
                HshldHeadEntity hshldHeadEntity = new HshldHeadEntity();
                HshldMemberEntity HshldMember = new HshldMemberEntity();

                String userNo = user.getUserNo();

                hshldHeadEntity.setUserNo(user.getUserNo());
                hshldHeadEntity.setHeadYn(i == 0 ? "Y" : "N");
                hshldHeadEntity.setHoNo(unit.getHoNo());
                hshldHeadEntity.setInoutCd("LIVE");

                HshldMember.setHoNo(unit.getHoNo());
                HshldMember.setHshldMbrNm(user.getUserNm());

                memberMapper.insertMemberAssign(hshldHeadEntity);
                memberMapper.updateMemberAuth(userNo);
                aptMapper.updateEmpty(unit.getHoNo());
                memberMapper.insertHshldMember(HshldMember);

                assigned++;
                userIndex++;
            }
        }
    }

    @Override
    public List<AptBass> checkBaseInfo(String sido, String sigungu, String emd) {

        log.info("===== checkBaseInfo 시작 =====");
        log.info("조회 조건 sido={}, sigungu={}, emd={}", sido, sigungu, emd);

        List<String> lawdCdList =
                aptMapper.selectLawdCdList(sido, sigungu, emd);

        log.info("조회된 법정동 코드 수 : {}", lawdCdList.size());

        List<AptBass> result = new ArrayList<>();

        for (String bjdCode : lawdCdList) {

            log.info("========== 법정동 시작 ==========");
            log.info("bjdCode={}", bjdCode);

            int pageNo = 1;

            while (true) {

                log.info("페이지 조회 시작 pageNo={}", pageNo);

                String listUrl =
                        "https://apis.data.go.kr/1613000/AptListService3/getLegaldongAptList3"
                                + "?serviceKey=" + serviceKey
                                + "&pageNo=" + pageNo
                                + "&numOfRows=100"
                                + "&bjdCode=" + bjdCode;

                ResponseEntity<AptListResponse> listResponse =
                        rt.getForEntity(listUrl, AptListResponse.class);

                AptListResponse dto = listResponse.getBody();

                if (dto == null
                        || dto.getResponse() == null
                        || dto.getResponse().getBody() == null) {

                    log.warn("목록 API 응답 없음");
                    break;
                }

                List<AptListItem> items =
                        listResponse.getBody()
                                .getResponse()
                                .getBody()
                                .getItems();

                if (items == null || items.isEmpty()) {

                    log.info("현재 법정동 조회 결과 없음");
                    break;
                }

                log.info("현재 페이지 아파트 수 : {}", items.size());

                for (AptListItem item : items) {

                    try {

                        log.info("[page {}] 상세조회 시작 : {}",
                                pageNo,
                                item.getKaptName());

                        String detailUrl =
                                "https://apis.data.go.kr/1613000/AptBasisInfoServiceV4/getAphusBassInfoV4"
                                        + "?serviceKey=" + serviceKey
                                        + "&kaptCode=" + item.getKaptCode();

                        ResponseEntity<AptBassResponse> response =
                                rt.getForEntity(detailUrl, AptBassResponse.class);

                        Thread.sleep(100);

                        AptBassResponse bassDto = response.getBody();

                        if (bassDto == null
                                || bassDto.getResponse() == null
                                || bassDto.getResponse().getBody() == null
                                || bassDto.getResponse().getBody().getItem() == null) {

                            continue;
                        }

                        result.add(
                                bassDto.getResponse().getBody().getItem()
                        );

                        log.info("[page {}] 조회 성공 : {}",
                                pageNo,
                                item.getKaptName());

                    } catch (Exception e) {

                        log.error("조회 실패 : {}", item.getKaptCode(), e);
                    }
                }

                pageNo++;
            }
        }

        log.info("===== checkBaseInfo 종료 =====");
        log.info("최종 결과 수 : {}", result.size());

        return result;
    }


    private List<AptHoTyVO> toAptHoTyVO(
            List<AptHoTyVO> aptHoTyVOList,
            AptBass bassItem){

        Map<String, Integer> map = new HashMap<>();

        map.put("60", safeParseInt(bassItem.getKaptMparea60()));
        map.put("85", safeParseInt(bassItem.getKaptMparea85()));
        map.put("135", safeParseInt(bassItem.getKaptMparea135()));
        map.put("136", safeParseInt(bassItem.getKaptMparea136()));

        String maxKey = null;
        int maxValue = Integer.MIN_VALUE;

        for (Map.Entry<String, Integer> entry : map.entrySet()) {

            if (entry.getValue() > maxValue) {
                maxValue = entry.getValue();
                maxKey = entry.getKey();
            }
        }

        AptHoTyVO hoTy = new AptHoTyVO();

        hoTy.setHoTyNo(bassItem.getKaptCode() + "_1");
        hoTy.setAptCmplexNo(bassItem.getKaptCode());

        hoTy.setTyNm("A타입");

        hoTy.setExclusiveSize(maxKey);

        hoTy.setRoomCnt(1);
        hoTy.setBathroomCnt(1);

        aptHoTyVOList.add(hoTy);

        return aptHoTyVOList;
    }

}
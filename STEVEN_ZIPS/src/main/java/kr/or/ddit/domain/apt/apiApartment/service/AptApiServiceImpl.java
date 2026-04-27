    package kr.or.ddit.domain.apt.apiApartment.service;

    import kr.or.ddit.domain.apt.apiApartment.mapper.IAptApiMapper;
    import kr.or.ddit.domain.apt.apiApartment.vo.*;
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

    import java.io.UnsupportedEncodingException;
    import java.net.URLEncoder;
    import java.util.ArrayList;
    import java.util.HashMap;
    import java.util.List;
    import java.util.Map;

    @Service
    @Slf4j
    public class AptApiServiceImpl implements IAptApiService {

        @Autowired
        private IAptApiMapper aptMapper;

        private String serviceKey = "279564b17283c0863ff904cbfee96deb15c26cd426ec71fe7c5966a865f64f2f";
        private String kakaoKey = "e91015a224888fbe9e2afc3320c22a1b";
        RestTemplate rt = new RestTemplate();


        @Override
        @Transactional
        public void collectMapoApt() {
            log.info("collectMapoApt() 실행됨2...!");

            List<String> lawdCdList = aptMapper.selectMapoLawdCdList();

            RestTemplate restTemplate = new RestTemplate();

            List<AptListItem> AptItemList = new ArrayList<>();
            List<AptBass> bassList = new ArrayList<>();


            for (String bjdCode : lawdCdList) {
                int pageNo = 1;
                while (true) {
                    String url = "https://apis.data.go.kr/1613000/AptListService3/getLegaldongAptList3"
                            + "?serviceKey=" + serviceKey
                            + "&pageNo=" + pageNo
                            + "&numOfRows=100"
                            + "&bjdCode=" + bjdCode;

                    ResponseEntity<AptListResponse> response =
                            restTemplate.getForEntity(url, AptListResponse.class);

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
                            restTemplate.getForEntity(url, AptBassResponse.class);

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
                            restTemplate.getForEntity(url, AptDetailResponse.class);

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
                    log.error("kaptCode {} bass API 오류", kaptCode, e);
                }
            }



            List<AptInfraEntity> infraEntityList = new ArrayList<>();
            List<AptComplexEntity> entityList = new ArrayList<>();

            for (AptListItem listItem : AptItemList) {

                AptBass bassItem = bassMap.get(listItem.getKaptCode());
                AptDetail detailItem = detailMap.get(listItem.getKaptCode());
                String welfareFacility = detailMap.get(listItem.getKaptCode()).getWelfareFacility();
                String convenientFacility = detailMap.get(listItem.getKaptCode()).getConvenientFacility();
                String educationFacility = detailMap.get(listItem.getKaptCode()).getEducationFacility();


                /*      인프라 entity 구성 시작! */
                toInfraEntity(welfareFacility, "WELFARE", listItem.getKaptCode(), infraEntityList);
                toInfraEntity(convenientFacility, "CONVENIENCE", listItem.getKaptCode(), infraEntityList);
                toInfraEntity(educationFacility, "EDUCATION", listItem.getKaptCode(), infraEntityList);
                /*      인프라 entity 구성 끝! */

                /*      단지관리소 entity 구성 시작! */

                /*      단지관리소 entity 구성 끝! */

                /*      단지관리자(member+manager) entity 구성 시작! */

                /*      단지관리자(member) entity 구성 끝! */

                /*      동 테이블 entity 구성 시작! */
                /*      동 테이블 entity 구성 끝! */

                /*      호 테이블 entity 구성 시작! */
                /*      호 테이블 entity 구성 끝! */

                entityList.add(toEntity(listItem, bassItem,detailItem));
            }

            log.info("총 엔티티 개수: {}", entityList.size());
            log.info("총 인프라 개수: {}", infraEntityList.size());

            entityList.stream().limit(5)
                    .forEach(e -> log.info("샘플: {}", e));


            /*                   inser 작업 실행 start                */

            int batchSize = 100;
            int count = 0;

    // 🔵 아파트 insert
            for (AptComplexEntity apt : entityList) {
                aptMapper.insertAptOne(apt);

                count++;
                if (count % batchSize == 0) {
                    log.info("APT {}건 insert 완료", count);
                }
            }

    // 🔵 인프라 insert
            count = 0;
            for (AptInfraEntity infra : infraEntityList) {
                aptMapper.insertInfraOne(infra);

                count++;
                if (count % batchSize == 0) {
                    log.info("INFRA {}건 insert 완료", count);
                }
            }

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
                apt.setMaxFloor(bassItem.getKaptTopFloor());

                if (bassItem.getKaptDongCnt() != null
                        && !bassItem.getKaptDongCnt().trim().isEmpty()) {

                    apt.setDongCnt(Integer.parseInt(bassItem.getKaptDongCnt()));
                }

                apt.setDorojuso(bassItem.getDoroJuso());
            }

            // 상세정보 api 에서 가져온 정보
            if (detailItem != null && "Y".equals(detailItem.getUseYn())){
                if (detailItem.getKaptdPcnt() != null
                        && !detailItem.getKaptdPcnt().trim().isEmpty()) {
                    apt.setPkgCnt(Integer.parseInt(detailItem.getKaptdPcnt())+Integer.parseInt(detailItem.getKaptdPcntu()));
                }
            }

            // 카카오api 경도위도 정보
            if (bassItem != null && bassItem.getDoroJuso() != null && !bassItem.getDoroJuso().trim().isEmpty()) {

                String address = bassItem.getDoroJuso();

                Map<String, String> coord = getLatLng(address);

                if (coord != null) {
                    apt.setLatVal(Double.parseDouble(coord.get("lat")));
                    apt.setLonVal(Double.parseDouble(coord.get("lng")));
                } else {
                    log.warn("좌표 못찾음: {}", bassItem.getDoroJuso());
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

                    if (trimmed.isEmpty()) continue; // 이거 필수

                    AptInfraEntity infra = new AptInfraEntity();
                    infra.setCategoryCd(categoryCd);
                    infra.setInfraNm(name.trim());
                    infra.setAptCmplexNo(kaptCode);

                    infraEntityList.add(infra);
                }
            }

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

            log.info("응답 JSON: {}", json);

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
/*        private List<MgmtOfficeEntity> toMgmtOfficeEntity (){

        }*/
    }
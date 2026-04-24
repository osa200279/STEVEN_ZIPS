package kr.or.ddit.domain.ApiApartment.service;

import kr.or.ddit.domain.ApiApartment.mapper.IAptApiMapper;
import kr.or.ddit.domain.ApiApartment.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

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

    @Override
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




        List<AptComplexEntity> entityList = new ArrayList<>();

        for (AptListItem listItem : AptItemList) {

            AptBass bassItem = bassMap.get(listItem.getKaptCode());
            AptDetail detailItem = detailMap.get(listItem.getKaptCode());

            entityList.add(toEntity(listItem, bassItem,detailItem));
        }

        log.info("총 엔티티 개수: {}", entityList.size());

        entityList.stream().limit(5)
                .forEach(e -> log.info("샘플: {}", e));

    }

    private AptComplexEntity toEntity(AptListItem listItem, AptBass bassItem, AptDetail detailItem) {

        AptComplexEntity apt = new AptComplexEntity();

        // 기본 정보
        apt.setAptCmplexNo(listItem.getKaptCode());
        apt.setAptCmplexNm(listItem.getKaptName());
        apt.setBjdCd(listItem.getBjdCode());
        apt.setSidoNm(listItem.getAs1());
        apt.setSigunguNm(listItem.getAs2());
        apt.setEmdNm(listItem.getAs3());

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

        if (detailItem != null && "Y".equals(detailItem.getUseYn())){
            if (detailItem.getKaptdPcnt() != null
                    && !detailItem.getKaptdPcnt().trim().isEmpty()) {
                apt.setPkgCnt(Integer.parseInt(detailItem.getKaptdPcnt())+Integer.parseInt(detailItem.getKaptdPcntu()));
            }
        }
        return apt;
    }
}
package kr.or.ddit.domain.ApiApartment.service;

import kr.or.ddit.domain.ApiApartment.mapper.IAptApiMapper;
import kr.or.ddit.domain.ApiApartment.vo.AptComplexEntity;
import kr.or.ddit.domain.ApiApartment.vo.AptListItem;
import kr.or.ddit.domain.ApiApartment.vo.AptListResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
public class AptApiServiceImpl implements IAptApiService {
    @Autowired
    private IAptApiMapper aptMapper;
    private String serviceKey = "279564b17283c0863ff904cbfee96deb15c26cd426ec71fe7c5966a865f64f2f";

    @Override
    public void collectMapoApt() {
        log.info("collectMapoApt() 실행됨...!");
        List<String> lawdCdList = aptMapper.selectMapoLawdCdList();
        RestTemplate restTemplate = new RestTemplate();
        List<AptListItem> resultList = new ArrayList<>();
        for (String bjdCode : lawdCdList) {
            int pageNo = 1;
            while (true) {
                String url = "https://apis.data.go.kr/1613000/AptListService3/getLegaldongAptList3" + "?serviceKey=" + serviceKey + "&pageNo=" + pageNo + "&numOfRows=100" + "&bjdCode=" + bjdCode;

                ResponseEntity<AptListResponse> response = restTemplate.getForEntity(url, AptListResponse.class);

                List<AptListItem> items = response.getBody().getResponse().getBody().getItems();

                if (items == null || items.isEmpty()) {
                    break;
                }

                resultList.addAll(items);
                pageNo++;
            }
        }

        List<AptComplexEntity> entityList = new ArrayList<>();

        for (AptListItem item : resultList) {
            entityList.add(toEntity(item));
        }

        log.info("총 아파트 개수: " + resultList.size());
        log.info("체킁 " + entityList.toString());
        log.info("체킁 " + entityList.size());

    }

    private AptComplexEntity toEntity(AptListItem listItem) {

        AptComplexEntity apt = new AptComplexEntity();

        apt.setAptCmplexNo(listItem.getKaptCode());
        apt.setSidoNm(listItem.getAs1());
        apt.setSigunguNm(listItem.getAs2());
        apt.setEmdNm(listItem.getAs3());


        return apt;
    }
}
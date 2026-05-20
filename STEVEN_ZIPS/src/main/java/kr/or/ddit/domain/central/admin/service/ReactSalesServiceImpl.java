package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.central.admin.mapper.IReactSalesMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ReactSalesServiceImpl implements IReactSalesService{

    @Autowired
    private IReactSalesMapper reactSalesMapper;

    @Override
    public List<String> selectBuildingList(String aptCmplexNo) {
        return reactSalesMapper.selectBuildingList(aptCmplexNo);
    }

    @Override
    public List<AptDetailVO> selectHoList(String aptCmplexNo, String dongNm) {
        return reactSalesMapper.selectHoList(aptCmplexNo,dongNm);
    }

    @Override
    @Transactional
    public void registerRentListing(
            Map<String, Object> param
    ) {

        List<String> hoNos = (List<String>) param.get("hoNos");


        /*가져온 Map 에 담긴 정보 꺼내서 담고 insert 진행하기*/
        for (String hoNo : hoNos) {

            Map<String, Object> map = new HashMap<>();

            map.put("hoNo", hoNo);

            map.put("rentTtl", param.get("rentTtl"));

            map.put("rentTypeCd", param.get("rentTypeCd"));

            map.put("dpstAmt", param.get("dpstAmt"));

            map.put("mthlyRentAmt", param.get("mthlyRentAmt"));

            map.put("rentLstgCn", param.get("rentLstgCn"));

            map.put("rcrtLstgSttsCd", param.get("rcrtLstgSttsCd"));

            String existRentLstgNo = reactSalesMapper.selectExistRentListing(hoNo);

            if (existRentLstgNo != null) {
                map.put("rentLstgNo", existRentLstgNo);
                reactSalesMapper.updateRentListing(map);

            } else {
                reactSalesMapper.insertRentListing(map);
            }
        }
    }
}

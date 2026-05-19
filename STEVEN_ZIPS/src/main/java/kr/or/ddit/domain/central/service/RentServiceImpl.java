package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.central.dto.RentListingMapDTO;
import kr.or.ddit.domain.central.mapper.IRentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RentServiceImpl implements IRentService{

    @Autowired
    private IRentMapper rentMapper;

    // 매물 목록/지도 표시용 매물 리스트 조회
    @Override
    public List<RentListingMapDTO> selectRentListingMapList() {
        return rentMapper.selectRentListingMapList();
    }

    // 매물 상세 조회
    @Override
    public RentListingMapDTO selectRentListingDetail(String rentLstgNo) {
        return rentMapper.selectRentListingDetail(rentLstgNo);
    }
}

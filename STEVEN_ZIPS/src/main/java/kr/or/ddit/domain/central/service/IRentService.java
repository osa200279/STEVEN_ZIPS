package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.central.dto.RentListingMapDTO;

import java.util.List;

public interface IRentService {
    List<RentListingMapDTO> selectRentListingMapList();

    RentListingMapDTO selectRentListingDetail(String rentLstgNo);
}

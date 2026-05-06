package kr.or.ddit.domain.apt.apiApartment.service;

import kr.or.ddit.domain.apt.apiApartment.vo.AptBass;

import java.util.List;

public interface IAptApiService {

    void updateLatLng();

    void assignResidents(List<String> aptList, int count);

    void collectApt(String sido, String sigungu, String emd);

    List<AptBass> checkBaseInfo(String sido, String sigungu, String emd);
}

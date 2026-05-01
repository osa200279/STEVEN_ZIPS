package kr.or.ddit.domain.apt.apiApartment.service;

import java.util.List;

public interface IAptApiService {

    void updateLatLng();

    void assignResidents(List<String> aptList, int count);

    void collectApt(String sido, String sigungu, String emd);
}

package kr.or.ddit.domain.central.rentCtrt.service;

import java.util.List;
import java.util.Map;

public interface IRentCtrtService {

    List<Map<String, Object>> selectCtrt(int startRow, int endRow);

    int selectCtrtCount(String userNo);

    Map<String, Object> selectCtrtDashboard();

    Map<String, Object> selectOneCtrtDetail(String rentCtrtNo);

    int updateCtrt(String rentCtrtNo, Map<String, Object> detail);
}

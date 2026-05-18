package kr.or.ddit.domain.central.rentCtrt.service;

import java.util.List;
import java.util.Map;

public interface IRentCtrtService {

    List<Map<String, Object>> selectCtrt(String userNo,  int startRow, int endRow);

    int selectCtrtCount(String userNo);
}

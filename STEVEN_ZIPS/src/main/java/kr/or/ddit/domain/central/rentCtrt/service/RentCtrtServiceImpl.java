package kr.or.ddit.domain.central.rentCtrt.service;

import kr.or.ddit.domain.central.rentCtrt.mapper.IRentCtrtMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Transactional(rollbackFor = Exception.class)
@Service
public class RentCtrtServiceImpl implements IRentCtrtService {

    @Autowired
    private IRentCtrtMapper rentCtrtMapper;

    @Override
    public List<Map<String, Object>> selectCtrt(int startRow, int endRow) {
        return rentCtrtMapper.selectCtrt();
    }

    @Override
    public int selectCtrtCount(String userNo) {
        return rentCtrtMapper.selectCtrtCount(userNo);
    }

    @Override
    public Map<String, Object> selectCtrtDashboard() {
        return rentCtrtMapper.selectCtrtDashboard();
    }
}

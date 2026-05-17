package kr.or.ddit.domain.central.rentCtrt.service;

import kr.or.ddit.domain.central.rentCtrt.mapper.IRentCtrtMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Transactional(rollbackFor = Exception.class)
@Service
public class RentCtrtServiceImpl implements IRentCtrtService {

    @Autowired
    IRentCtrtMapper rentCtrtMapper;

    @Override
    public int makeCtrt(String aplctNo, String manager) {

        Map<String, Object> param = new HashMap<>();
        param.put("aplctNo", aplctNo);

        // 1. 승인된 청약 신청 정보로 임대 가계약서 생성
        int res1 = rentCtrtMapper.insertRentCtrt(param);
        // 가계약 생성 실패시 트랜잭션 롤백 유도
        if (res1 <= 0) throw new RuntimeException("임대계약 생성 실패");

        // 2. 청약 승인한 담당자로 배정
        //int res2 = rentCtrtMapper.insertCtrtMgr(manager);

        //if(res2 <= 0) throw new RuntimeException("담당자 배정 실패");

        return res1;
    }
}

package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import kr.or.ddit.domain.central.admin.mapper.IAplctMapper;
import kr.or.ddit.domain.central.rentCtrt.mapper.IRentCtrtMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Transactional(rollbackFor = Exception.class)
@Service
public class AplctServiceImpl implements IAplctService {

    @Autowired
    private IAplctMapper aplctMapper;

    @Autowired
    private IRentCtrtMapper rentCtrtMapper;

    @Override
    public List<AplctDTO> selectAplctList() {
        return aplctMapper.selectAplctList();
    }

    @Override
    public int approveAplct(List<Map<String, Object>> updateList, String manager) {
        int cnt = aplctMapper.updateAplctStatus(updateList);
        if (cnt == 0) new RuntimeException("청약 상태 업데이트 실패");

        List<Map<String, Object>> qualifiedList = updateList.stream()
                .filter(map -> "QUALIFIED".equals(map.get("aplctSttsCd")))
                .collect(Collectors.toList());

        if (!qualifiedList.isEmpty()) {

            for(Map<String, Object> map : qualifiedList) {
                String seq = rentCtrtMapper.getNextRentCtrtSeq();
                String aplctNo = (String)map.get("aplctNo");
                String rentCtrtNo = aplctNo + "_" + seq;
                map.put("rentCtrtNo", rentCtrtNo);
            }

            log.info("### qualifiedList {}", qualifiedList);
            int res1 = rentCtrtMapper.insertRentCtrt(qualifiedList);
            if (res1 == 0) throw  new RuntimeException("가계약 생성 실패");

            int res2 = rentCtrtMapper.insertCtrtMgr(qualifiedList, manager);
            if (res2 == 0) throw new RuntimeException("담당자 배정 실패");
        }

        return cnt;
    }

}

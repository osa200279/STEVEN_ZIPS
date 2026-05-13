package kr.or.ddit.domain.central.admin.service;
import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import kr.or.ddit.domain.central.admin.mapper.IAplctMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional(rollbackFor = Exception.class)
@Service
public class AplctServiceImpl implements IAplctService {

    @Autowired
    private IAplctMapper aplctMapper;

    @Override
    public List<AplctDTO> selectAplctList() {
        return aplctMapper.selectAplctList();
    }

    @Override
    public int approveAplct(List<String> aplctNos, String aplctSttsCd) {
        return aplctMapper.updateAplctStatus(aplctNos, aplctSttsCd);
    }

}

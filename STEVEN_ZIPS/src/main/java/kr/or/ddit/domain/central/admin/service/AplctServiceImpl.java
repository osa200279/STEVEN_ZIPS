package kr.or.ddit.domain.central.admin.service;
import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import kr.or.ddit.domain.central.admin.mapper.IAplctMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AplctServiceImpl implements IAplctService {

    @Autowired
    private IAplctMapper aplctMapper;

    @Override
    public List<AplctDTO> selectAplctList() {
        return aplctMapper.selectAplctList();
    }
}

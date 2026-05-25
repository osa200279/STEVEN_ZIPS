package kr.or.ddit.domain.central.rentCtrt.service;

import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.central.rentCtrt.mapper.IRentCtrtMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Slf4j
@Transactional(rollbackFor = Exception.class)
@Service
public class RentCtrtServiceImpl implements IRentCtrtService {

    @Autowired
    private IRentCtrtMapper rentCtrtMapper;

    @Autowired
    private IAttachFileService attachFileService;

    @Override
    public List<Map<String, Object>> selectCtrt(int startRow, int endRow) {
        return rentCtrtMapper.selectCtrt(startRow, endRow);
    }

    @Override
    public int selectCtrtCount(String userNo) {
        return rentCtrtMapper.selectCtrtCount(userNo);
    }

    @Override
    public Map<String, Object> selectCtrtDashboard() {
        return rentCtrtMapper.selectCtrtDashboard();
    }

    @Override
    public Map<String, Object> selectOneCtrtDetail(String rentCtrtNo) {
        Map<String, Object> map = rentCtrtMapper.selectOneCtrtDetail(rentCtrtNo);
        String sbmsnDocNo = (String)map.get("SBMSN_DOC_NO");

        if(sbmsnDocNo != null) {
            String fileNo = (String) map.get("ATCH_FILE_ID");

            if (fileNo != null) {
                List<AttachFileVO> docList = attachFileService.setFileMetaData(fileNo);
                map.put("docList", docList);
            }
        }

        return map;
    }
}

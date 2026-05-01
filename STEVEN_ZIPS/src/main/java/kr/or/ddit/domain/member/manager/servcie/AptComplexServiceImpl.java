package kr.or.ddit.domain.member.manager.servcie;

import kr.or.ddit.domain.apt.board.ann.mapper.IAptAnnBoardPostMapper;
import kr.or.ddit.domain.apt.board.ann.vo.AptAnnBoardPostVO;
import kr.or.ddit.domain.apt.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.manager.mapper.IMgmtOfficeMapper;
import kr.or.ddit.domain.apt.manager.vo.MgmtOfficeVO;
import kr.or.ddit.domain.member.manager.mapper.IAptComplexMapper;
import kr.or.ddit.domain.apt.vo.AptComplexVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class AptComplexServiceImpl implements IAptComplexService {

    @Autowired
    private IAptComplexMapper aptComplexMapper;

    @Autowired
    private IMgmtOfficeMapper imgmtOfficeMapper;

    @Autowired
    private IAptAnnBoardPostMapper aptAnnBoardPostMapper;

    @Override
    public AptComplexVO selectAptComplex(String aptCmplexNo) {
        return aptComplexMapper.selectAptComplex(aptCmplexNo);
    }

   /* @Override
    public AptComplexVO selectAptDetailList(String aptCmplexNo) {
        return aptComplexMapper.selectAptDetailList(aptCmplexNo);
    }*/

    @Override
    public String selectManagerAptCmplexNo(String userNo) {
        return aptComplexMapper.selectManagerAptCmplexNo(userNo);
    }

    @Override
    @Transactional
    public int updateAptComplex(AptComplexVO aptComplexVO) {
        return aptComplexMapper.updateAptComplex(aptComplexVO);
    }

    /**
     * 아파트 메인페이지 DTO 셀렉트
     * @author 이용로
     * @param aptCmplexNo 아파트 단지 코드
     * @return AptMainPageDTO.ResponseDto 아파트 메인페이지 DTO
     */
    @Override
    public AptMainPageDTO.ResponseDto selectAptMainDTO(String aptCmplexNo) {
        AptMainPageDTO.ResponseDto resp = new AptMainPageDTO.ResponseDto();

        // 아파트 정보 세팅
        AptComplexVO aptComplexVO = aptComplexMapper.selectAptComplex(aptCmplexNo);
        if(aptComplexVO != null){
            AptMainPageDTO.AptComplexInfo aptComplexInfo = new AptMainPageDTO.AptComplexInfo();
            BeanUtils.copyProperties(aptComplexVO, aptComplexInfo);
            resp.setAptComplexInfo(aptComplexInfo);
        }

        // 관리사무소 정보 세팅
        MgmtOfficeVO mgmtOfficeVO = imgmtOfficeMapper.selectOneMgmtOffice(aptCmplexNo);
        if(mgmtOfficeVO != null){
            AptMainPageDTO.MgmtOfficeInfo mgmtOfficeInfo = new AptMainPageDTO.MgmtOfficeInfo();
            BeanUtils.copyProperties(mgmtOfficeVO, mgmtOfficeInfo);
            resp.setMgmtOfficeInfo(mgmtOfficeInfo);
        }

        // 공지 게시판 글 세팅
        List<AptAnnBoardPostVO> annBoardPostVOList =  aptAnnBoardPostMapper.selectLatest(aptCmplexNo, 3);
        List<AptMainPageDTO.AnnBoardPostInfo> annBoardPostInfoList = new ArrayList<>();
        if(annBoardPostVOList != null){
            for(AptAnnBoardPostVO board : annBoardPostVOList){
                AptMainPageDTO.AnnBoardPostInfo temp = new AptMainPageDTO.AnnBoardPostInfo();
                BeanUtils.copyProperties(board, temp);
                annBoardPostInfoList.add(temp);
            }
            resp.setAnnBoardPostInfoList(annBoardPostInfoList);
        }

        return resp;
    }
}

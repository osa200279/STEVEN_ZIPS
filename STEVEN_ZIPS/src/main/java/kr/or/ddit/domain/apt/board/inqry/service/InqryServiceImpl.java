package kr.or.ddit.domain.apt.board.inqry.service;

import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;
import kr.or.ddit.domain.apt.board.inqry.mapper.IInqryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class InqryServiceImpl implements IInqryService {

    private final IInqryMapper inqryMapper;

    private static final String BOARD_TY_CD_INQRY = "INQRY";
    // 상수란?
    // → 변하지 않는 고정값.
    // 왜 사용?
    // → "INQRY"를 여러 곳에 직접 쓰면 오타 위험이 있어서 한 곳에서 관리한다.

    @Override
    public List<InqryDTO> getList(String userNo, String wrtrId, int startRow, int endRow) {

        String aptCmplexNo = getAptCmplexNo(userNo);

        return inqryMapper.getList(
                wrtrId,
                aptCmplexNo,
                BOARD_TY_CD_INQRY,
                startRow,
                endRow
        );
    }

    @Override
    public void insertQna(InqryDTO dto, String userNo) {

        if (dto.getTtl() == null || dto.getTtl().trim().isEmpty()) {
            throw new RuntimeException("제목 없음");
        }

        if (dto.getCn() == null || dto.getCn().trim().isEmpty()) {
            throw new RuntimeException("내용 없음");
        }

        dto.setAptCmplexNo(getAptCmplexNo(userNo));
        dto.setBoardTyCd(BOARD_TY_CD_INQRY);

        if (dto.getOpnYn() == null || dto.getOpnYn().trim().isEmpty()) {
            dto.setOpnYn("Y");
        }

        inqryMapper.insertQna(dto);
    }

    @Override
    public void deleteQna(String postNo, String userNo, String wrtrId) {

        String aptCmplexNo = getAptCmplexNo(userNo);

        inqryMapper.deleteQna(
                postNo,
                wrtrId,
                aptCmplexNo,
                BOARD_TY_CD_INQRY
        );
    }

    @Override
    public int getTotalCount(String userNo, String wrtrId) {

        String aptCmplexNo = getAptCmplexNo(userNo);

        return inqryMapper.getTotalCount(
                wrtrId,
                aptCmplexNo,
                BOARD_TY_CD_INQRY
        );
    }

    private String getAptCmplexNo(String userNo) {

        Map<String, Object> info = inqryMapper.getResidentInfo(userNo);

        if (info == null || info.get("APTCMPLEXNO") == null) {
            throw new RuntimeException("세대 정보가 연결되지 않은 사용자입니다.");
        }

        return String.valueOf(info.get("APTCMPLEXNO"));
    }
}

//package kr.or.ddit.domain.apt.board.inqry.service;
//
//import kr.or.ddit.domain.apt.board.inqry.mapper.IInqryMapper;
//import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//import java.util.Map;
//
//@Slf4j
//@Service
//public class InqryServiceImpl implements IInqryService {
//
//    @Autowired
//    private IInqryMapper qnaMapper;
//
//    @Override
//    public List<CvplVO> getList(
//            String userNo,
//            int startRow,
//            int endRow
//    ) {
//        return qnaMapper.getList(
//                userNo,
//                startRow,
//                endRow
//        );
//    }
//
//    @Override
//    public void insertQna(CvplVO vo) {
//        if (vo.getCvplTtl() == null || vo.getCvplTtl().trim().isEmpty()) {
//            throw new RuntimeException("제목 없음");
//        }
//
//        if (vo.getCvplCn() == null || vo.getCvplCn().trim().isEmpty()) {
//            throw new RuntimeException("내용 없음");
//        }
//
//        qnaMapper.insertQna(vo);
//    }
//
//    @Override
//    public void deleteQna(String cvplNo, String userNo) {
//        qnaMapper.deleteQna(cvplNo, userNo);
//    }
//
//    @Override
//    public int getTotalCount(String userNo) {
//        return qnaMapper.getTotalCount(userNo);
//    }
//
//    @Override
//    public Map<String, Object> getResidentInfo(String userNo) {
//        Map<String, Object> info = qnaMapper.getResidentInfo(userNo);
//
//        if (info == null || info.isEmpty()) {
//            throw new RuntimeException("세대 정보가 연결되지 않은 사용자입니다.");
//            // 세대 정보란?
//            // → 현재 로그인한 사용자가 어느 호수(HO_NO), 어느 단지(APT_CMPLEX_NO)에 속하는지에 대한 정보.
//        }
//
//        return info;
//    }
//
////    @Override
////    public Map<String, Object> getResidentInfo(String userNo) {
////        return qnaMapper.getResidentInfo(userNo);
////    }
//
//}

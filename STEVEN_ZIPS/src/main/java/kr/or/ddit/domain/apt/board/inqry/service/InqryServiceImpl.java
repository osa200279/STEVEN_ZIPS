package kr.or.ddit.domain.apt.board.inqry.service;

import kr.or.ddit.common.enums.board.BoardTyCd;
import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;
import kr.or.ddit.domain.apt.board.inqry.mapper.IInqryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 입주민 문의게시판 Service 구현체
 *
 * Service란?
 * → Controller와 Mapper 사이에서 업무 로직을 처리하는 클래스.
 */
@Service
@RequiredArgsConstructor
public class InqryServiceImpl implements IInqryService {

    private final IInqryMapper inqryMapper;

    private static final String BOARD_TY_CD_INQRY = BoardTyCd.INQRY.name();

    @Override
    public List<InqryDTO> getList(String userNo, String wrtrId, int startRow, int endRow) {

        InqryDTO residentInfo = getResidentInfo(userNo);

        return inqryMapper.getList(
                wrtrId,
                residentInfo.getAptCmplexNo(),
                BOARD_TY_CD_INQRY,
                startRow,
                endRow
        );
    }

    @Override
    public void insertInqry(InqryDTO dto, String userNo) {

        if (dto.getTtl() == null || dto.getTtl().trim().isEmpty()) {
            throw new RuntimeException("제목 없음");
        }

        if (dto.getCn() == null || dto.getCn().trim().isEmpty()) {
            throw new RuntimeException("내용 없음");
        }

        InqryDTO residentInfo = getResidentInfo(userNo);

        String boardNo = inqryMapper.getBoardNo(
                residentInfo.getAptCmplexNo(),
                BOARD_TY_CD_INQRY
        );

        /* 확인용 */
        System.out.println("로그인 userNo = " + userNo);
        System.out.println("조회된 aptCmplexNo = " + residentInfo.getAptCmplexNo());
        System.out.println("조회된 hoNo = " + residentInfo.getHoNo());
        System.out.println("boardTyCd = " + BOARD_TY_CD_INQRY);
        System.out.println("조회된 boardNo = " + boardNo);

        if (boardNo == null || boardNo.trim().isEmpty()) {
            throw new RuntimeException("해당 단지의 문의게시판이 생성되지 않았습니다.");
        }

        dto.setBoardNo(boardNo);
        dto.setUserNo(userNo);
        dto.setHoNo(residentInfo.getHoNo());
        dto.setAptCmplexNo(residentInfo.getAptCmplexNo());
        dto.setBoardTyCd(BOARD_TY_CD_INQRY);

        if (dto.getOpnYn() == null || dto.getOpnYn().trim().isEmpty()) {
            dto.setOpnYn("Y");
        }

        inqryMapper.insertInqry(dto);
    }

    @Override
    public void deleteInqry(String postNo, String userNo, String wrtrId) {

        InqryDTO residentInfo = getResidentInfo(userNo);

        inqryMapper.deleteInqry(
                postNo,
                wrtrId,
                residentInfo.getAptCmplexNo(),
                BOARD_TY_CD_INQRY
        );
    }

    @Override
    public int getTotalCount(String userNo, String wrtrId) {

        InqryDTO residentInfo = getResidentInfo(userNo);

        return inqryMapper.getTotalCount(
                wrtrId,
                residentInfo.getAptCmplexNo(),
                BOARD_TY_CD_INQRY
        );
    }

    private InqryDTO getResidentInfo(String userNo) {

        InqryDTO residentInfo = inqryMapper.getResidentInfo(userNo);

        if (residentInfo == null || residentInfo.getAptCmplexNo() == null) {
            throw new RuntimeException("세대 정보가 연결되지 않은 사용자입니다.");
        }

        return residentInfo;
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

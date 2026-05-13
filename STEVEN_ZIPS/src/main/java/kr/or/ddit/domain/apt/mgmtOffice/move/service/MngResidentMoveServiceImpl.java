package kr.or.ddit.domain.apt.mgmtOffice.move.service;

import kr.or.ddit.domain.apt.mgmtOffice.move.dto.MngResidentMoveSearchDTO;
import kr.or.ddit.domain.apt.mgmtOffice.move.mapper.IMngResidentMoveMapper;
import kr.or.ddit.domain.apt.mgmtOffice.move.vo.MngResidentMoveVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class MngResidentMoveServiceImpl implements IMngResidentMoveService {

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final IMngResidentMoveMapper residentMoveMapper;

    @Override
    public List<MngResidentMoveVO> selectResidentMoveList(MngResidentMoveSearchDTO searchDTO) {
        return residentMoveMapper.selectResidentMoveList(searchDTO);
    }

    @Override
    public MngResidentMoveVO selectResidentMoveDetail(String mgmtOfcNo, String userNo) {
        return residentMoveMapper.selectResidentMoveDetail(mgmtOfcNo, userNo);
    }

    @Override
    @Transactional
    public Map<String, Object> saveResidentMove(MngResidentMoveVO vo) {
        Map<String, Object> result = new HashMap<>();

        if (!StringUtils.hasText(vo.getUserNo())) {
            result.put("success", false);
            result.put("message", "사용자 번호가 필요합니다.");
            return result;
        }
        if (!StringUtils.hasText(vo.getHoNo())) {
            result.put("success", false);
            result.put("message", "호실 정보가 필요합니다.");
            return result;
        }

        normalizeMoveDates(vo);

        int affected;
        if (residentMoveMapper.countResidentMoveByKey(vo.getUserNo(), vo.getHoNo()) > 0) {
            affected = residentMoveMapper.updateResidentMove(vo);
        } else {
            affected = residentMoveMapper.insertResidentMove(vo);
        }

        result.put("success", affected > 0);
        result.put("affectedRows", affected);
        result.put("message", affected > 0 ? "입주/퇴거 정보가 저장되었습니다." : "저장에 실패했습니다.");
        return result;
    }

    @Override
    @Transactional
    public Map<String, Object> updateResidentMove(MngResidentMoveVO vo) {

        Map<String, Object> result = new HashMap<>();

        if (!StringUtils.hasText(vo.getUserNo())) {
            result.put("success", false);
            result.put("message", "사용자 번호가 필요합니다.");
            return result;
        }

        if (!StringUtils.hasText(vo.getHoNo())) {
            result.put("success", false);
            result.put("message", "호실 정보가 필요합니다.");
            return result;
        }

        normalizeMoveDates(vo);

        int affected = residentMoveMapper.updateResidentMove(vo);

        result.put("success", affected > 0);
        result.put("affectedRows", affected);
        result.put("message",
                affected > 0 ? "입주/퇴거 정보가 수정되었습니다."
                        : "수정에 실패했습니다.");

        return result;
    }

    private void normalizeMoveDates(MngResidentMoveVO vo) {
        if (!StringUtils.hasText(vo.getMoveStatus())) {
            vo.setMoveStatus("WAIT");
        }
        if (!StringUtils.hasText(vo.getInoutCd())) {
            vo.setInoutCd(vo.getMoveStatus());
        }
        if (!StringUtils.hasText(vo.getHeadYn())) {
            vo.setHeadYn("N");
        }

        String today = LocalDate.now().format(DATE_FMT);

        if ("LIVE".equals(vo.getInoutCd()) && !StringUtils.hasText(vo.getMoveInDt())) {
            vo.setMoveInDt(today);
        }
        if ("OUT".equals(vo.getInoutCd()) && !StringUtils.hasText(vo.getMoveOutDt())) {
            vo.setMoveOutDt(today);
        }

        if (!StringUtils.hasText(vo.getMoveStatus())) {
            vo.setMoveStatus(vo.getInoutCd());
        }
    }
}

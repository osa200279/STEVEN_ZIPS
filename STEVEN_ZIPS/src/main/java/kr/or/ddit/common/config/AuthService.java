package kr.or.ddit.common.config;

import kr.or.ddit.domain.member.admin.vo.AdmVO;
import kr.or.ddit.domain.member.manager.vo.MngrVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AuthService {

    /**
     * 접근 권한 소속 확인
     * @author 이용로
     * @param principal
     * @param target
     * @return boolean 접근 허용 여부 true : 허용, false : 불허
     */
    public boolean hasAptAccess(Object principal, String target){      // 캐스팅 안정성 때문에 customUser가 아닌 principal사용

        if(!(principal instanceof CustomUser)) return false;   // 익명 사용자 거르기

        CustomUser user = (CustomUser)principal;    // 익명 사용자 방어코드
        if(user == null) return false;

        MemberVO member = user.getMember();
        if(member == null) return false;    // null 방어 코드


        // 다운캐스팅
        if(member instanceof ResidentVO){
            ResidentVO resident = (ResidentVO) member;

            boolean isOwner = resident.getMyAptList().stream()
                    .anyMatch(apt -> apt.getAptCmplexNo().equals(target));

            if(!isOwner){
                log.info("권한 없는 단지 접근 시도 유저 : {}", resident.getUserId());
            }
            return isOwner;
        }else if(member instanceof MngrVO){
            MngrVO mngr = (MngrVO) member;

            boolean isManager = mngr.getAptCmplexNo().equals(target);

            if(!isManager){
                log.info("권한 없는 단지 접근 시도 유저 : {}", mngr.getUserId());
            }
            return isManager;
        }else if(member instanceof AdmVO){
            return true;
        }
        return false;
    }
}

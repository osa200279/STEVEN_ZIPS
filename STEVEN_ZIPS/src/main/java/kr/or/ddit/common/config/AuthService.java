package kr.or.ddit.common.config;

import kr.or.ddit.domain.member.admin.vo.AdmVO;
import kr.or.ddit.domain.member.manager.vo.MngrVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
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
        
        if(principal == null || "anonymousUser".equals(principal)){ // anonymousUser : 시큐리티 내부에서 사용하는 비로그인 사용자 명
            return false;
        }

        // 다운캐스팅
        if(principal instanceof ResidentVO){
            ResidentVO resident = (ResidentVO) principal;

            boolean isOwner = resident.getMyAptList().stream()
                    .anyMatch(apt -> apt.getAptCmplexNo().equals(target));

            if(!isOwner){
                log.info("권한 없는 단지 접근 시도 유저 : {}", resident.getUserId());
            }
            return isOwner;
        }else if(principal instanceof MngrVO){
            MngrVO mngr = (MngrVO) principal;

            boolean isManager = mngr.getAptCmplexNo().equals(target);

            if(!isManager){
                log.info("권한 없는 단지 접근 시도 유저 : {}", mngr.getUserId());
            }
            return isManager;
        }else if(principal instanceof AdmVO){
            return true;
        }
        return false;
    }
}

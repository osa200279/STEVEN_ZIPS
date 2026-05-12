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
    public boolean hasAccess(Object principal, String target){   // 캐스팅 안정성 때문에 customUser가 아닌 principal사용

        if(!(principal instanceof CustomUser user)) return false;   // principal이 CustomUser타입이면 user변수 생성후 초기화하고 아니면 false반환

        MemberVO member = user.getMember();

        if(member instanceof ResidentVO resident){

            boolean isOwner = resident.getMyAptList().stream()
                    .anyMatch(apt -> apt.getAptCmplexNo().equals(target));

            if(!isOwner) log.info("권한 없는 단지 접근 시도 유저 : {}", resident.getUserId());

            return isOwner;
        }else if(member instanceof MngrVO mngr){

            boolean isManager = mngr.getMgmtOfcNo().equals(target) || mngr.getAptCmplexNo().equals(target);

            if(!isManager) log.info("권한 없는 단지 접근 시도 유저 : {}", mngr.getUserId());

            return isManager;
        }else return member instanceof AdmVO;

    }

    /**
     * only 입주민만 허용해주는 서비스
     * @author 이용로
     * @param principal
     * @param aptCmplexNo
     * @return
     */
    public boolean isResidentOnly(Object principal, String aptCmplexNo){
        if (!(principal instanceof CustomUser user)) return false;

        MemberVO member = user.getMember();

        return (member instanceof ResidentVO) ? hasAccess(user, aptCmplexNo) : false;
    }

    /**
     * 관리사무소 계정 여부 확인
     *
     * ADMIN은 RoleHierarchy 때문에 hasRole('MNGR')를 통과할 수 있으므로,
     * 실제 처리성 기능(등록/수정/삭제/취소)은 Member 타입이 MngrVO인 경우만 허용한다.
     *
     * @param principal 로그인 사용자 principal
     * @return true: 관리사무소 계정, false: 그 외 사용자
     */
    public boolean isManagerOnly(Object principal) {
        if (!(principal instanceof CustomUser)) return false;

        CustomUser user = (CustomUser) principal;
        MemberVO member = user.getMember();

        // canMgmtCrud() 내부에서 ADMIN을 제외하기 위한 보조 검사.
        // RoleHierarchy 때문에 ADMIN도 hasRole('MNGR')를 통과할 수 있으므로,
        // 실제 Member 타입이 MngrVO인 관리사무소 계정만 처리성 기능을 허용한다.
        return member instanceof MngrVO;
    }

    /**
     * 관리사무소 CUD 처리 권한 확인
     *
     * 관리사무소 등록/수정/삭제/취소 같은 CUD성 API에서 사용한다.
     * ADMIN은 조회만 가능하므로 제외하고,
     * 실제 MngrVO이면서 본인 소속 관리사무소인 경우만 허용한다.
     *
     * @param principal 로그인 사용자 principal
     * @param mgmtOfcNo 요청 URL의 관리사무소 번호
     * @return true: 처리 허용, false: 처리 불허
     */
    public boolean canMgmtCrud(Object principal, String mgmtOfcNo) {
        return isManagerOnly(principal) && hasAccess(principal, mgmtOfcNo);
    }
}

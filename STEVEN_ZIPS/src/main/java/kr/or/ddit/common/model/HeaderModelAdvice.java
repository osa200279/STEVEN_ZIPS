package kr.or.ddit.common.model;

import kr.or.ddit.domain.apt.manager.service.IMgmtOfficeService;
import kr.or.ddit.domain.apt.manager.vo.MgmtOfficeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@Slf4j
// 여러 Controller에 공통으로 적용되는 보조 Controller
@ControllerAdvice(annotations = Controller.class)
/**
 * 모든 화면에서 공통으로 필요한 데이터를 Model에 자동으로 넣어주는 클래스
 * 작성자 : 이윤진
 */
public class HeaderModelAdvice {

    @Autowired
    private IMgmtOfficeService mgmtOfficeService;

    /*
     * 모든 Controller가 JSP로 이동하기 전에
     * Model에 "office"라는 이름으로 관리사무소 정보를 자동 추가함.
     *
     * JSP에서 사용 예시:
     * ${office.aptCmplexNm}
     * ${office.mgmtOfcTelno}
     * ${office.dorojuso}
     */

    // 메서드가 return한 값을 Model에 "office"라는 이름으로 담아서 jsp에서 사용
    @ModelAttribute("office")
    public MgmtOfficeVO addOffice(Authentication authentication) {

        // 비로그인 상태
        if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
            return null;
        }

        // 인증은 되었지만 anonymousUser인 경우 방어
        if (!authentication.isAuthenticated() || "anonymousUser".equals(authentication.getName())) {
            return null;
        }

        // 관리소장 권한인지 확인
        boolean isManager = authentication.getAuthorities()
                .stream()
                .anyMatch(auth -> "ROLE_MNGR".equals(auth.getAuthority()));

        if (!isManager) {
            return null;
        }

        String userId = authentication.getName();

        try {
            MgmtOfficeVO office = mgmtOfficeService.selectMgmtOfficeByManagerUserNo(userId);

            log.info("공통 office 조회 userId = {}, office = {}", userId, office);

            return office;

        } catch (Exception e) {
            /*
             * 공통 헤더 정보 조회 실패 때문에 전체 화면이 죽는 것을 막기 위한 방어 코드
             */
            log.error("공통 office 정보 조회 중 오류 userId = {}", userId, e);
            return null;
        }

    }
}





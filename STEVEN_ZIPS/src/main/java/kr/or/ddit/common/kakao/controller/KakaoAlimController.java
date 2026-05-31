package kr.or.ddit.common.kakao.controller;

import kr.or.ddit.common.kakao.service.IKakaoAlimService;
import kr.or.ddit.common.kakao.vo.KakaoAlimVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 카카오 알림 Controller
 *
 * Controller란?
 * 화면의 요청을 받아 Service를 호출하고 결과를 반환하는 계층입니다.
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/resident/kakaoAlim")
public class KakaoAlimController {

    private final IKakaoAlimService kakaoAlimService;

    @GetMapping("/list")
    public List<KakaoAlimVO> list(@AuthenticationPrincipal CustomUser customUser) {
        String userNo = customUser.getMember().getUserNo();
        return kakaoAlimService.getMyAlimList(userNo);
    }

    @PostMapping("/{alimNo}/read")
    public void read(
            @PathVariable String alimNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        String userNo = customUser.getMember().getUserNo();
        kakaoAlimService.readAlim(alimNo, userNo);
    }
}
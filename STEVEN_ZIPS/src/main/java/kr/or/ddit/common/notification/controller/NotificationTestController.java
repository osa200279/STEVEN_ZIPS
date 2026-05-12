package kr.or.ddit.common.notification.controller;

import kr.or.ddit.common.notification.dto.NotificationDTO;
import kr.or.ddit.common.notification.service.NotificationService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class NotificationTestController {

    private final NotificationService notificationService;

    @GetMapping("/ztest/noti")
    public String test(
            @AuthenticationPrincipal CustomUser principal
    ) {

        String userNo = principal.getMember().getUserNo();

        notificationService.send(
                userNo,
                NotificationDTO.builder()
                        .title("테스트 알림")
                        .message("웹소켓 연결 성공")
                        .type("success")
                        .url("/apt/main")
                        .build()
        );

        return "ok";
    }
}
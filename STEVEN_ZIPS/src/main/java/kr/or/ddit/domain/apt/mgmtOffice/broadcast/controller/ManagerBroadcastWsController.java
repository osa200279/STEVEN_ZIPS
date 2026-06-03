package kr.or.ddit.domain.apt.mgmtOffice.broadcast.controller;

import kr.or.ddit.common.config.AuthService;
import kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo.BroadcastDongTargetVO;
import kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo.BroadcastPlayMessageVO;
import kr.or.ddit.domain.apt.mgmtOffice.broadcast.vo.BroadcastStartRequestVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class ManagerBroadcastWsController {

    private final SimpMessagingTemplate messagingTemplate;
    private final AuthService authService;

    @MessageMapping("/broadcast/start")
    public void startBroadcast(BroadcastStartRequestVO request, Principal principal) {
        if (request == null || principal == null || !(principal instanceof Authentication auth)) {
            return;
        }
        if (!(auth.getPrincipal() instanceof CustomUser user)) {
            return;
        }

        String mgmtOfcNo = trim(request.getMgmtOfcNo());
        String text = trim(request.getText());
        if (mgmtOfcNo.isEmpty() || text.isEmpty()) {
            return;
        }
        if (!authService.hasAccess(user, mgmtOfcNo)) {
            return;
        }

        List<BroadcastDongTargetVO> targets = normalizeTargets(request.getTargets());
        if (targets.isEmpty()) {
            return;
        }

        String languageCode = defaultIfBlank(request.getLanguageCode(), "ko-KR");
        String voiceName = defaultIfBlank(request.getVoiceName(), "ko-KR-Standard-C");
        List<String> areas = request.getAreas() != null ? request.getAreas() : List.of("전체");

        long sentAt = System.currentTimeMillis();
        String senderUserNo = user.getMember().getUserNo();
        String senderUserNm = user.getMember().getUserNm();

        for (BroadcastDongTargetVO target : targets) {
            String dongNo = trim(target.getDongNo());
            if (dongNo.isEmpty()) {
                continue;
            }

            BroadcastPlayMessageVO payload = new BroadcastPlayMessageVO();
            payload.setAction("PLAY");
            payload.setMgmtOfcNo(mgmtOfcNo);
            payload.setText(text);
            payload.setLanguageCode(languageCode);
            payload.setVoiceName(voiceName);
            payload.setAreas(areas);
            payload.setTargetDongNo(dongNo);
            payload.setTargetDongLabel(defaultIfBlank(target.getDongLabel(), dongNo));
            payload.setSenderUserNo(senderUserNo);
            payload.setSenderUserNm(senderUserNm);
            payload.setSentAt(sentAt);

            messagingTemplate.convertAndSend(
                    "/sub/broadcast/" + mgmtOfcNo + "/" + topicKey(dongNo),
                    payload
            );
        }
    }

    private List<BroadcastDongTargetVO> normalizeTargets(List<BroadcastDongTargetVO> raw) {
        List<BroadcastDongTargetVO> out = new ArrayList<>();
        if (raw == null) {
            return out;
        }
        for (BroadcastDongTargetVO t : raw) {
            if (t == null) {
                continue;
            }
            String dongNo = trim(t.getDongNo());
            if (dongNo.isEmpty()) {
                continue;
            }
            BroadcastDongTargetVO copy = new BroadcastDongTargetVO();
            copy.setDongNo(dongNo);
            copy.setDongLabel(defaultIfBlank(t.getDongLabel(), dongNo));
            out.add(copy);
        }
        return out;
    }

    private String topicKey(String dongNo) {
        return dongNo.replace("/", "_").replace(" ", "_");
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private String defaultIfBlank(String value, String fallback) {
        String v = trim(value);
        return v.isEmpty() ? fallback : v;
    }
}

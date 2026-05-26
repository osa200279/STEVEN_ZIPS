package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.member.resident.service.IResidentPaymentService;
import kr.or.ddit.domain.member.resident.vo.PaymentCompleteRequestVO;
import kr.or.ddit.domain.member.resident.vo.PaymentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/resident/payment")
public class ResidentPaymentController {

    @Autowired
    private IResidentPaymentService residentPaymentService;

    /**
     * @Author 이윤진
     * 결제 요청 생성
     *
     * 예: POST /resident/payment/prepare
     *
     * body:
     * {
     *   "billNo": "BL2605210001647",
     *   "payMthdCd": "CRD"
     * }
     */
    @PostMapping("/prepare")
    public ResponseEntity<Map<String, Object>> preparePayment(
            @RequestBody PaymentVO requestVO,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        log.info("===== 결제 prepare Controller 진입 =====");
        log.info("request billNo = {}", requestVO.getBillNo());
        log.info("request payMthdCd = {}", requestVO.getPayMthdCd());

        Map<String, Object> result = new HashMap<>();

        try {
            String userNo = customUser.getMember().getUserNo();

            Map<String, Object> paymentData =
                    residentPaymentService.preparePayment(
                            requestVO.getBillNo(),
                            requestVO.getPayMthdCd(),
                            userNo
                    );

            result.put("success", true);
            result.putAll(paymentData);

        } catch (Exception e) {
            log.error("관리비 결제 요청 생성 실패", e);

            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 고지서별 결제 이력 조회
     *
     * 요청 예:
     * GET /resident/payment/history/BL2605210001647
     */
    @GetMapping("/history/{billNo}")
    public ResponseEntity<Map<String, Object>> selectPaymentHistory(
            @PathVariable String billNo
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            List<PaymentVO> paymentList =
                    residentPaymentService.selectPaymentListByBillNo(billNo);

            result.put("success", true);
            result.put("list", paymentList);

        } catch (Exception e) {
            log.error("관리비 결제 이력 조회 실패", e);

            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }

    /**
     * PortOne 결제 완료 검증
     *
     * 예 : POST /resident/payment/complete
     *
     * body:
     * {
     *   "impUid": "imp_1234567890",
     *   "ordId": "ORD_BL2605210001647_20260526164954439"
     * }
     */
    @PostMapping("/complete")
    public ResponseEntity<Map<String, Object>> completePayment(
            @RequestBody PaymentCompleteRequestVO requestVO,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String userNo = customUser.getMember().getUserNo();

            Map<String, Object> paymentData =
                    residentPaymentService.completePayment(
                            requestVO.getImpUid(),
                            requestVO.getOrdId(),
                            userNo
                    );

            result.put("success", true);
            result.putAll(paymentData);

        } catch (Exception e) {
            log.error("관리비 결제 완료 검증 실패", e);

            result.put("success", false);
            result.put("message", e.getMessage());
        }

        return ResponseEntity.ok(result);
    }
}

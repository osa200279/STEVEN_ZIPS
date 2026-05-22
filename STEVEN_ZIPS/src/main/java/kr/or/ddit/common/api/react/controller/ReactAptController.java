package kr.or.ddit.common.api.react.controller;

import kr.or.ddit.common.api.react.service.IReactAptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/offlineCtrt/apt")
public class ReactAptController {

    @Autowired
    private IReactAptService reactAptService;

    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> searchApartment(
            @RequestParam String keyword
            , @RequestParam(defaultValue = "1") int page
            , @RequestParam(defaultValue = "10") int size
    ) {

        Map<String, Object> result = reactAptService.searchApartment(keyword, page, size);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/dong-list")
    public ResponseEntity<List<Map<String, Object>>> getDongList(
            @RequestParam String aptCmplexNo
    ) {

        List<Map<String, Object>> result = reactAptService.getDongList(aptCmplexNo);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/ho-list")
    public ResponseEntity<List<Map<String, Object>>> getHoList(
            @RequestParam String aptCmplexNo,
            @RequestParam String dongNo
    ) {

        List<Map<String, Object>> result =
                reactAptService.getHoList(
                        aptCmplexNo,
                        dongNo
                );

        return ResponseEntity.ok(result);
    }

    @GetMapping("/rent-detail")
    public ResponseEntity<Map<String, Object>>
    getRentListingDetail(
            @RequestParam String hoNo
    ) {

        Map<String, Object> result = reactAptService.getRentListingDetail(hoNo);

        return ResponseEntity.ok(result);
    }

    @GetMapping("/required-docs")
    public ResponseEntity<List<Map<String, Object>>>
    getRequiredDocs(
            @RequestParam String rentLstgNo
    ) {

        List<Map<String, Object>> result =
                reactAptService.getRequiredDocs(rentLstgNo);

        return ResponseEntity.ok(result);
    }
}
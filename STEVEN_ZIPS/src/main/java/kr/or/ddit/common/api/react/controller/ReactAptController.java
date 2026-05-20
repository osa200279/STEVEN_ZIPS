package kr.or.ddit.common.api.react.controller;

import kr.or.ddit.common.api.react.service.IReactAptService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/react/apt")
public class ReactAptController {

    @Autowired
    private IReactAptService reactAptService;

    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> searchApartment(
            @RequestParam String keyword
            ,@RequestParam(defaultValue = "1") int page
            ,@RequestParam(defaultValue = "10") int size
    ) {

        Map<String, Object> result = reactAptService.searchApartment(keyword, page, size);

        return ResponseEntity.ok(result);
    }
}
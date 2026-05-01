package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.member.resident.service.IResidentMainService;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.security.Principal;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/vhcl")
public class ResidentVhclController {

    @Autowired
    private IResidentMainService residentService;


    /**
     * 로그인한 유저 기준으로 등록된 차량을 가져오는 메서드
     * 로그인한 유저의 호수와 파라메타에 입력된 아파트단지번호와 동일한 차량만 가져온다.
     *
     * @param principal 로그인 사용자 정보(스프링시큐리티)
     * @param aptCmplexNo 아파트 단지번호
     * @return 사용자가 등록한 차량 LIST
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/myVhcl")
    @ResponseBody
    public List<RsidVhclVO> selectMyVhclList(Principal principal, String aptCmplexNo) {

        String userId = principal.getName();

        return residentService.selectMyVhclList(userId, aptCmplexNo);
    }
}

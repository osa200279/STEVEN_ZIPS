package kr.or.ddit.domain.member.service;

import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.domain.member.mapper.IMemberMapper;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberServiceImpl implements IMemberService {

    @Autowired
    private IMemberMapper mapper;

    @Override
    public ServiceResult joinMember(MemberVO member) {
        ServiceResult res = null;

        int status = mapper.joinMember(member);

        if(status>0){
            mapper.addAuth(member.getUserNo());
            res = ServiceResult.OK;
        }else{
            res = ServiceResult.FAILED;
        }
        return res;
    }
}

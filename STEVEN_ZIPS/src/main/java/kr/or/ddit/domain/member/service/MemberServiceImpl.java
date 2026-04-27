package kr.or.ddit.domain.member.service;

import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.common.util.AESUtil;
import kr.or.ddit.domain.member.mapper.IMemberMapper;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Slf4j
@Service
public class MemberServiceImpl implements IMemberService {

    @Autowired
    private IMemberMapper mapper;

    @Autowired
    private PasswordEncoder pe;

    @Autowired
    private AESUtil aes;

    @Override
    @Transactional(rollbackFor = Exception.class)   // encrypt(암호화)에러와 insert에러 모두 트랜잭션 적용
    public ServiceResult joinMember(MemberVO member) {
        ServiceResult res = null;

        try{
            if(member.getUserPw() != null) {
                member.setUserPw(pe.encode(member.getUserPw()));    // 비밀번호 암호화
            }

            if(member.getUserRrno() != null){
                member.setUserRrno(aes.encrypt(member.getUserRrno()));
                log.info("암호화된 비밀번호 {}",member.getUserRrno());
            }

            int status = mapper.joinMember(member);     // 회원 등록

            if(status>0){
                mapper.addAuth(member.getUserNo());
                res = ServiceResult.OK;
            }else{
                res = ServiceResult.FAILED;
            }
        }catch (Exception e){
            log.error("회원가입 실패: {}", e.getMessage());   // 에러 원인 로그
            throw new RuntimeException("회원가입 처리 중 오류 발생", e);   // 트랜잭션 롤백 유도
        }

        return res;
    }


    @Override
    public ServiceResult updateMember(MemberVO member) {
        try {
            // 🔥 로그 먼저 찍어
            log.info("🔥 userNo = [{}]", member.getUserNo());
            log.info("🔥 userNm = [{}]", member.getUserNm());
            log.info("🔥 userTelno = [{}]", member.getUserTelno());
            log.info("🔥 userEml = [{}]", member.getUserEml());

            // 🔥 주민번호 암호화
            if(member.getUserRrno() != null && !member.getUserRrno().isEmpty()) {
                member.setUserRrno(aes.encrypt(member.getUserRrno()));
            }

            int status = mapper.updateMember(member);

            // 🔥 결과 로그
            log.info("🔥 update 결과 = {}", status);

            return status > 0 ? ServiceResult.OK : ServiceResult.FAILED;

        } catch (Exception e) {
            log.error("회원정보 수정 실패", e);
            return ServiceResult.FAILED;
        }
    }

    @Override
    public void deleteMember(String userNo) {
        mapper.deleteMember(userNo);
    }

    @Override
    public void updatePassword(String userNo, String newPw) {

        // 1. 비밀번호 암호화
        String encodedPw = pe.encode(newPw);

        // 2. DB 업데이트
        mapper.updatePassword(userNo, encodedPw);
    }

    @Override
    public MemberVO getMemberByUserNo(String userNo) {
        return mapper.getMemberByUserNo(userNo);
    }

    @Override
    public void updateAlarm(Map<String, Object> param) {
        mapper.updateAlarm(param);
    }
    }



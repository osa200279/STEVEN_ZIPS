package kr.or.ddit.domain.apt.apiApartment.service;

import kr.or.ddit.common.util.AESUtil;
import kr.or.ddit.domain.apt.apiApartment.mapper.IApiMemberMapper;
import kr.or.ddit.domain.apt.apiApartment.mapper.IAptApiMapper;
import kr.or.ddit.domain.apt.apiApartment.vo.AptComplexEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.HshldHeadEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.HshldMemberEntity;
import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.member.vo.AuthVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Random;

@Service
public class AptMemberApiServiceImpl implements IAptMemberApiService{

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private IAptApiMapper aptMapper;

    @Autowired
    private IApiMemberMapper memberMapper;

    AESUtil autil = new AESUtil();

    @Override
    public List<String> getSidoList() {
        return aptMapper.selectSidoList();
    }

    @Override
    public List<String> getSigunguList(String sido) {
        return aptMapper.selectSigunguList(sido);
    }

    @Override
    public List<String> getEmdList(String sido, String sigungu) {
        return aptMapper.selectEmdList(sido, sigungu);
    }

    @Override
    public List<AptComplexEntity> getAptList(String sido, String sigungu, String emd) {
        return aptMapper.selectAptList(sido, sigungu, emd);
    }

    @Override
    public void createDummyUsers(int count) {
        for (int i = 0; i < count; i++) {

            MemberVO member = new MemberVO();
            AuthVO auth = new AuthVO();
            String encodedPw = passwordEncoder.encode("1234");


            member.setUserPw(encodedPw);
            member.setUserNm(generateRandomName());
            member.setUserTelno("000-0000-0000");
            try {
                member.setUserRrno(autil.encrypt(generateRrn()));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

            memberMapper.insertMember(member);
            auth.setUserNo(member.getUserNo());
            auth.setAuth("ROLE_MEMBER");
            memberMapper.insertMemberAuth(auth);
        }

    }


    @Override
    public int getNotAssignedUserCount() {
        return memberMapper.selectNotAssignedUserCount();
    }

    @Override
    public void assignResidents(List<String> aptList, int count) {

        Random random = new Random();

        List<AptDetailVO> units = aptMapper.selectAvailableUnits(aptList);

        List<MemberVO> users = memberMapper.selectNotAssignedTestUsers();

        if (users.isEmpty()) {
            throw new RuntimeException("유저 없음");
        }

        if(units.isEmpty()){
            throw new RuntimeException("호실 없음");
        }

        Collections.shuffle(units);
        Collections.shuffle(users);

        int assigned = 0;
        int userIndex = 0;

        for (AptDetailVO unit : units) {

            if (assigned >= count) break;

            int peopleCnt = 1 + random.nextInt(3);

            for (int i = 0; i < peopleCnt; i++) {

                if (assigned >= count || userIndex >= users.size()) break;

                MemberVO user = users.get(userIndex);
                HshldHeadEntity hshldHeadEntity = new HshldHeadEntity();
                HshldMemberEntity HshldMember = new HshldMemberEntity();

                String userNo = user.getUserNo();

                hshldHeadEntity.setUserNo(user.getUserNo());
                hshldHeadEntity.setHeadYn(i == 0 ? "Y" : "N");
                hshldHeadEntity.setHoNo(unit.getHoNo());
                hshldHeadEntity.setInoutCd("LIVE");

                HshldMember.setHoNo(unit.getHoNo());
                HshldMember.setHshldMbrNm(user.getUserNm());

                memberMapper.insertMemberAssign(hshldHeadEntity);
                memberMapper.updateMemberAuth(userNo);
                aptMapper.updateEmpty(unit.getHoNo());
                memberMapper.insertHshldMember(HshldMember);

                assigned++;
                userIndex++;
            }
        }
    }

    private static final String[] LAST_NAMES = {
            "김","이","박","최","정","강","조","윤","장","임","한","오","서","신","권",
            "황","안","송","전","홍","유","고","문","양","손","배","백","허","남","심",
            "노","하","곽","성","차","주","우","구","민","류","진","엄","채","원","천",
            "방","공","강","현","변","염","여","추","도","소","석","선","설","마","길",
            "연","위","표","명","기","반","왕","금","옥","육","인","맹","제","모","남궁"
    };

    private static final String[] FIRST_NAMES = {
            "민수","서연","지훈","지우","도윤","하은","지민","수현","예준","서준",
            "하윤","지아","건우","유진","현우","소율","은우","나연","준호","다은",

            "서진","서현","지호","주원","시우","하린","예원","지안","태현","동현",
            "민재","수아","채원","다윤","지유","은서","가은","유나","서우","아린",

            "승현","재윤","정우","민호","성민","준영","태윤","시윤","지후","건호",
            "예빈","소연","채은","유빈","수빈","예린","하율","연우","나은","다인",

            "태민","영준","동훈","진우","광수","철수","영희","미영","정희","순자",
            "은정","혜진","경민","성훈","병철","상현","명수","지숙","선영","지영",

            "지혁","도현","시현","민성","준서","태경","상민","동욱","정민","진호",
            "아영","소희","지은","혜원","수진","유리","보람","은지","나영","서영",

            "준혁","태호","민석","지성","우진","기현","상훈","종현","현준","동건",
            "수경","유정","소영","혜린","채린","은별","다혜","지혜","유미","보미"
    };

    private String generateRandomName() {
        Random random = new Random();

        String lastName = LAST_NAMES[random.nextInt(LAST_NAMES.length)];
        String firstName = FIRST_NAMES[random.nextInt(FIRST_NAMES.length)];

        return lastName + firstName;
    }

    private String generateRrn() {

        Random random = new Random();

        int year = 1970 + random.nextInt(40);
        int month = 1 + random.nextInt(12);
        int day = 1 + random.nextInt(28);

        String birth = String.format("%02d%02d%02d",
                year % 100, month, day);

        boolean isMale = random.nextBoolean();

        int genderCode;
        if (year < 2000) {
            genderCode = isMale ? 1 : 2;
        } else {
            genderCode = isMale ? 3 : 4;
        }

        int back = 100000 + random.nextInt(900000);

        return birth + genderCode + back;
    }
}

package kr.or.ddit.domain.member.mapper;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IMemberMapper {

    MemberVO readByUserInfo(String username);
}

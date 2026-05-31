package kr.or.ddit.common.kakao.mapper;

import kr.or.ddit.common.kakao.vo.KakaoAlimVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 카카오 알림 Mapper
 *
 * Mapper란?
 * Java 메서드와 SQL XML을 연결하는 인터페이스입니다.
 */
@Mapper
public interface IKakaoAlimMapper {

    String selectNextAlimNo();

    int insertKakaoAlim(KakaoAlimVO vo);

    List<KakaoAlimVO> selectMyKakaoAlimList(String userNo);

    int updateReadYn(@Param("alimNo") String alimNo, @Param("userNo") String userNo);
}
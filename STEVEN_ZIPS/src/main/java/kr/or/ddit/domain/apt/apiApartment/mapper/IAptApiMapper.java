package kr.or.ddit.domain.apt.apiApartment.mapper;


import kr.or.ddit.domain.apt.apiApartment.vo.AptComplexEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyDTO;
import kr.or.ddit.domain.apt.apiApartment.vo.AptInfraEntity;
import kr.or.ddit.domain.apt.apiApartment.vo.MgmtOfficeEntity;
import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.apt.main.vo.AptUnitVO;
import kr.or.ddit.domain.member.vo.AuthVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface IAptApiMapper {


    List<String> selectLawdCdList(String sido, String sigungu, String emd);

    void insertAptBatch(List<AptComplexEntity> list);

    void insertMgmtOfficeBatch(List<MgmtOfficeEntity> list);

    void insertMemberBatch(List<MemberVO> list);

    void insertManagerBatch(List<ManagerVO> list);

    void insertAptUnitBatch(List<AptUnitVO> list);

    void insertAptDetailBatch(List<AptDetailVO> list);

    void insertInfraOne(AptInfraEntity infra);

    long getMemberSeq();

    long getMgmtOfcNoSeq();

    List<String> selectSidoList();

    List<String> selectSigunguList(String sido);

    List<String> selectEmdList(String sido, String sigungu);

    List<AptComplexEntity> selectAptList(String sido, String sigungu, String emd);

    void insertAuthBatch(List<AuthVO> list);

    List<AptComplexEntity> selectNoCoordList();

    void updateLatLng(AptComplexEntity apt);

    List<AptDetailVO> selectAvailableUnits(List<String> aptList);

    void updateEmpty(String hoNo);

    void insertAptHoTyBatch(List<AptHoTyDTO> list);
}

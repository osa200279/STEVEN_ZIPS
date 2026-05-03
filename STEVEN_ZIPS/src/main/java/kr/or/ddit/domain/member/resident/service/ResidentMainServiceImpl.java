package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.mapper.IResidentMapper;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class ResidentMainServiceImpl implements IResidentMainService{

    @Autowired
    IResidentMapper residentMapper;

    @Autowired
    GoogleDriveService googleDriveService;

    @Autowired
    IAttachFileMapper attachFileMapper;


    @Override
    public List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo) {

        return residentMapper.selectMyVhclList(userNo,aptCmplexNo);
    }

    @Override
    public List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo) {

        return residentMapper.selectMyRoomList(userNo, aptCmplexNo);
    }

    @Override
    public ChatRoomVO createRoom(ChatRoomVO vo, String userNo) {

/*        채팅방 생성 메서드
        residentMapper.insertChatRoom(vo);

        본인 방장으로 참여시킴
        residentMapper.insertChatRoomMember(vo.getChatRoomNo(), userNo);

        생성된 방 객체 리턴
        return residentMapper.selectChatRoom(vo.getChatRoomNo());*/
        return null;
    }


    /*첫번째 자동차(승인대기없이 바로 승인하는 메서드)*/
    @Override
    public void registerVhcl(RsidVhclVO vo, MultipartFile file) {

        String path = "resident/myVhcl/"+"userNo_"+vo.getUserNo();
        String savedFileName = UUID.randomUUID().toString().replace("-","")+"_"+file.getOriginalFilename();

        /* 차량번호 중복 체크하는 메서드 */
        int exists = residentMapper.existsVhclNo(vo.getVhclNo());
        if (exists > 0) {
            throw new RuntimeException("이미 등록된 차량번호");
        }

        long seq = attachFileMapper.getSeqFileGroupNo();

        vo.setVhclFileNo(String.valueOf(seq));

        if (file != null && !file.isEmpty()) {

            try {

                String googleId = googleDriveService.uploadFile(file, path, savedFileName);

                AttachFileVO attachFile = AttachFileVO.fileSettings(
                        file, seq, "vhcl", savedFileName, googleId, path, 1
                );

                attachFileMapper.insertAttachFile(attachFile);

            } catch (IOException e) {
                /*  파일 삭제하는 로직!
                if (googleId != null) {
                    googleDriveService.deleteFile(googleId);
                }
                */
                throw new RuntimeException(e);
            }
        }
        vo.setVhclSttsCd("APRV");

        residentMapper.insertVhcl(vo);
    }


    @Override
    public void requestExtraVhcl(RsidVhclVO vo, MultipartFile file) {

    }

}

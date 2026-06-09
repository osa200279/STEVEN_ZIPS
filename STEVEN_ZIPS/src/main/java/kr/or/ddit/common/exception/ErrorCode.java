package kr.or.ddit.common.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {

    // 공고
    ANN_NOT_FOUND(HttpStatus.NOT_FOUND, "공고를 찾을 수 없습니다."),

    // 청약
    SUB_NOT_FOUND(HttpStatus.NOT_FOUND, "청약을 찾을 수 없습니다."),
    SUB_ALREADY_EXIST(HttpStatus.CONFLICT, "이미 청약 신청되었습니다."),

    // 파일 업로드
    FILE_UPLOAD_FAIL(HttpStatus.INTERNAL_SERVER_ERROR, "파일 업로드에 실패했습니다."),

    // 민원
    CVPL_NOT_FOUND(HttpStatus.NOT_FOUND, "민원 조회에 실패했습니다."),
    CVPL_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "민원 신청에 실패했습니다."),

    // 방송
    TTS_CONVERT_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "음성 변환에 실패했습니다."),
    TTS_BROADCAST_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "방송 송출에 실패했습니다."),

    // 공통
    INTERVAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "서버 내부 오류가 발생했습니다.");


    private final HttpStatus status;
    private final String message;

    }


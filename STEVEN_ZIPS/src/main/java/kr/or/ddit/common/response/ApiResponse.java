package kr.or.ddit.common.response;

import lombok.Builder;
import lombok.Getter;


/**
 * API 응답 유틸 클래스
 * 빌더패턴을 적용하여 코드 가독성을 높임
 */
@Getter
@Builder
public class ApiResponse<T> {

    private int code;
    private T data;
    private String message;

}

package kr.or.ddit.common.api.react.service;

import java.util.Map;

public interface IReactAptService {
    Map<String, Object> searchApartment(String keyword, int page, int size);
}

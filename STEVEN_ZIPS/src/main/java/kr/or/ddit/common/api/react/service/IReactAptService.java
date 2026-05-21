package kr.or.ddit.common.api.react.service;

import java.util.List;
import java.util.Map;

public interface IReactAptService {
    Map<String, Object> searchApartment(String keyword, int page, int size);

    List<String> getDongList(String aptCmplexNo);
}

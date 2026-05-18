package kr.or.ddit.domain.central.rentCtrt.service;

import kr.or.ddit.domain.central.rentCtrt.mapper.IRentCtrtMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Transactional(rollbackFor = Exception.class)
@Service
public class RentCtrtServiceImpl implements IRentCtrtService {

}

package kr.or.ddit.domain.apt.mgmtOffice.broadcast.service;

public interface IManagerBroadcastService {

    byte[] convertTextToSpeech(String text, String languageCode, String voiceName) throws Exception;
}

package kr.or.ddit.common.util;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.InputStreamContent;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.File;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Collections;

@Service
public class GoogleDriveService {

    @Value("${google.drive.folder-id}")
    private String folderId;

    public String uploadFile(MultipartFile file) throws IOException {
        try {
            // 1. 아까 받은 client_secrets.json 로드
            InputStream in = new ClassPathResource("client_secrets.json").getInputStream();
            GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(
                    GsonFactory.getDefaultInstance(), new InputStreamReader(in));

            // 2. 인증 설정 (프로젝트 폴더에 'tokens' 폴더가 자동 생성되어 인증 정보를 저장합니다)
            GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(),
                    GsonFactory.getDefaultInstance(),
                    clientSecrets,
                    Collections.singleton(DriveScopes.DRIVE_FILE)) // 파일 생성 권한만 요청
                    .setDataStoreFactory(new FileDataStoreFactory(new java.io.File("tokens")))
                    .setAccessType("offline")
                    .build();

            // 3. 브라우저를 띄워 로그인 진행 (최초 1회만 실행됨)
            LocalServerReceiver receiver = new LocalServerReceiver.Builder().setPort(8888).build();
            Credential credential = new AuthorizationCodeInstalledApp(flow, receiver).authorize("user");

            // 4. 구글 드라이브 서비스 빌드
            Drive service = new Drive.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(),
                    GsonFactory.getDefaultInstance(),
                    credential)
                    .setApplicationName("StevenZips")
                    .build();

            // 5. 파일 업로드 실행
            File fileMetadata = new File();
            fileMetadata.setName(file.getOriginalFilename());
            fileMetadata.setParents(Collections.singletonList(folderId));

            InputStreamContent mediaContent = new InputStreamContent(
                    file.getContentType(),
                    file.getInputStream()
            );

            File uploadedFile = service.files().create(fileMetadata, mediaContent)
                    .setFields("id, webViewLink")
                    .execute();

            return uploadedFile.getWebViewLink();

        } catch (Exception e) {
            e.printStackTrace();
            throw new IOException("구글 업로드 에러: " + e.getMessage());
        }
    }
}



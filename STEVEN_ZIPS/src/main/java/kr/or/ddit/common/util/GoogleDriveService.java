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
import com.google.api.services.drive.model.FileList; // 추가됨
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

    // 수정: path(경로) 인자를 추가로 받음
    public String uploadFile(MultipartFile file, String path) throws IOException {
        try {
            InputStream in = new ClassPathResource("client_secrets.json").getInputStream();
            GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(
                    GsonFactory.getDefaultInstance(), new InputStreamReader(in));

            GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(),
                    GsonFactory.getDefaultInstance(),
                    clientSecrets,
                    Collections.singleton(DriveScopes.DRIVE_FILE))
                    .setDataStoreFactory(new FileDataStoreFactory(new java.io.File("tokens")))
                    .setAccessType("offline")
                    .build();

            LocalServerReceiver receiver = new LocalServerReceiver.Builder().setPort(8888).build();
            Credential credential = new AuthorizationCodeInstalledApp(flow, receiver).authorize("user");

            Drive service = new Drive.Builder(
                    GoogleNetHttpTransport.newTrustedTransport(),
                    GsonFactory.getDefaultInstance(),
                    credential)
                    .setApplicationName("StevenZips")
                    .build();

            // --- [여기서부터 핵심 수정 구간] ---

            // 1. mkdirs 로직 실행 (하위 폴더 생성 및 최종 폴더 ID 추출)
            String targetFolderId = getOrCreateFolders(service, folderId, path);

            // 2. 파일 메타데이터 설정 (부모 폴더를 targetFolderId로 지정)
            File fileMetadata = new File();
            fileMetadata.setName(file.getOriginalFilename());
            fileMetadata.setParents(Collections.singletonList(targetFolderId));

            InputStreamContent mediaContent = new InputStreamContent(
                    file.getContentType(),
                    file.getInputStream()
            );

            // 3. 파일 업로드 및 ID 가져오기
            File uploadedFile = service.files().create(fileMetadata, mediaContent)
                    .setFields("id") // webViewLink 대신 id만 받아도 충분
                    .execute();

            // 4. 결과값: <img> 태그에서 바로 쓸 수 있는 직링크로 변환해서 리턴
            return "https://drive.google.com/uc?export=view&id=" + uploadedFile.getId();

            // --- [수정 구간 끝] ---

        } catch (Exception e) {
            e.printStackTrace();
            throw new IOException("구글 업로드 에러: " + e.getMessage());
        }
    }

    // 추가: mkdirs 처럼 동작하는 폴더 생성/탐색 메서드
    private String getOrCreateFolders(Drive service, String rootId, String path) throws IOException {
        String[] folderNames = path.split("/");
        String currentParentId = rootId;

        for (String name : folderNames) {
            if (name.trim().isEmpty()) continue;

            // 현재 부모 폴더 내에 해당 이름의 폴더가 있는지 검색
            String query = "name = '" + name + "' and mimeType = 'application/vnd.google-apps.folder' and '" + currentParentId + "' in parents and trashed = false";
            FileList result = service.files().list().setQ(query).setFields("files(id)").execute();

            if (!result.getFiles().isEmpty()) {
                // 있으면 해당 ID로 이동
                currentParentId = result.getFiles().get(0).getId();
            } else {
                // 없으면 생성 후 그 ID로 이동
                File folderMetadata = new File();
                folderMetadata.setName(name);
                folderMetadata.setMimeType("application/vnd.google-apps.folder");
                folderMetadata.setParents(Collections.singletonList(currentParentId));

                File folder = service.files().create(folderMetadata).setFields("id").execute();
                currentParentId = folder.getId();
            }
        }
        return currentParentId;
    }
}
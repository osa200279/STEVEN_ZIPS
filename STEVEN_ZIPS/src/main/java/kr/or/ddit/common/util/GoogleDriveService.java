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

/*
    google drive 파일 메서드 참고문서
    https://developers.google.com/workspace/drive/api/guides/search-files?hl=ko
*/
@Service
public class GoogleDriveService {

    @Value("${google.drive.folder-id}")
    private String folderId;

    // 업로드 파일 메서드
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

            // 1. mkdirs() 로직 메서드인 getOrCreateFolders 실행 (하위 폴더 생성 및 최종 폴더 ID 추출)
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

            return uploadedFile.getId();

        } catch (Exception e) {
            e.printStackTrace();
            throw new IOException("구글 업로드 에러: " + e.getMessage());
        }
    }

    /**
     * mkdirs() 처럼 동작하는 폴더 생성/탐색 메서드
     * @param service - 사용할 google drive 서비스 객체
     * @param rootId - 탐색을 시작할 최상위 폴더 이름
     * @param path - 파일을 저장할 경로
     * @return currentParentId - 최종 생성된 폴더명
     * @throws IOException
     * @query name = '' :: 찾고자 하는 콘텐츠 명
     * @query mimeType = '' :: 데이터 타입 'application/vnd.google-apps.folder', 'image/jpeg'
     * @query '' in parents :: ''컬렉션(폴더) 내 파일 (ex. myFolder 내 파일 => 'myFolder' in parents)
     */
    private String getOrCreateFolders(Drive service, String rootId, String path) throws IOException {
        String[] folderNames = path.split("/"); // '/'로 구분된 각 경로 분리
        String currentParentId = rootId;
        String targetType = "application/vnd.google-apps.folder";

        // 구분된 각 경로에 대해서 검사
        for (String name : folderNames) {
            if (name.trim().isEmpty()) continue;

            String query = String.format(
                    "name = '%s' and " +    // 찾을 폴더명
                    "mimeType = '%s' and " +   // targetType
                    "'%s' in parents and " +    // currentParentId
                    "trashed = false ",    // 휴지통에 있는 폴더 제외
                    name, targetType, currentParentId );

            FileList result = service.files().list().   // 파일 목록 조회 메서드
                                setQ(query).   // 쿼리로 조건 필터링
                                setFields("files(id)").execute();   // 찾은 파일들 중에서 파일 아이디만 가져오기(속도 및 효율성)

            if (!result.getFiles().isEmpty()) {
                // 찾은게 있으면 해당 ID로 이동
                currentParentId = result.getFiles().get(0).getId();
            } else {
                // 없으면 생성 후 그 ID로 이동
                File folderMetadata = new File();
                folderMetadata.setName(name);
                folderMetadata.setMimeType("application/vnd.google-apps.folder");   // 폴더 타입으로 생성
                folderMetadata.setParents(Collections.singletonList(currentParentId));  // 현재 생성하는 폴더의 부모(상위)폴더 설정
                // 구글 드라이

                File folder = service.files().create(folderMetadata).setFields("id").execute();
                currentParentId = folder.getId();
            }
        }
        return currentParentId; // 매개변수 path로 받은 경로의 최종목적지 폴더 위치 값
    }
}
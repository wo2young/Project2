package kr.or.mes2.service;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Base64;
import java.util.Collections;
import java.util.Properties;

import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.stereotype.Service;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.gmail.Gmail;
import com.google.api.services.gmail.GmailScopes;

@Service
public class GmailService {

    private static final String APPLICATION_NAME = "MES2 Mail Sender";
    private static final String USER_ID = "me"; // Gmail API에서 "me"는 인증된 사용자 계정
    private static final JacksonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private static final String TOKENS_DIRECTORY_PATH = "tokens";

    private Credential getCredentials(final NetHttpTransport HTTP_TRANSPORT) throws Exception {
        // credentials.json 파일 로드
        InputStream in = GmailService.class.getResourceAsStream("/credentials.json");
        GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, new InputStreamReader(in));

        FileDataStoreFactory dataStoreFactory = new FileDataStoreFactory(new java.io.File(TOKENS_DIRECTORY_PATH));

        GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, Collections.singleton(GmailScopes.GMAIL_SEND))
                .setDataStoreFactory(dataStoreFactory)
                .setAccessType("offline")
                .build();

        LocalServerReceiver receiver = new LocalServerReceiver.Builder().setPort(9999).build();
        return new AuthorizationCodeInstalledApp(flow, receiver).authorize("user");
    }

    // ✅ 이메일 전송 메서드
    public void sendEmail(String to, String subject, String bodyText) throws Exception {
        final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
        Gmail service = new Gmail.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
                .setApplicationName(APPLICATION_NAME)
                .build();

        MimeMessage email = createEmail(to, USER_ID, subject, bodyText);
        com.google.api.services.gmail.model.Message message = createMessageWithEmail(email);
        service.users().messages().send(USER_ID, message).execute();

        System.out.println("[Gmail 전송 완료] → " + to);
    }

    // ✅ 메일 작성
    private MimeMessage createEmail(String to, String from, String subject, String bodyText) throws Exception {
        Properties props = new Properties();
        Session session = Session.getDefaultInstance(props, null);

        MimeMessage email = new MimeMessage(session);
        email.setFrom(new InternetAddress(from));
        email.addRecipient(javax.mail.Message.RecipientType.TO, new InternetAddress(to)); // 충돌 방지용
        email.setSubject(subject, "UTF-8");
        email.setText(bodyText, "UTF-8");
        return email;
    }

    // ✅ Gmail API용 메시지 객체로 변환
    private com.google.api.services.gmail.model.Message createMessageWithEmail(MimeMessage email) throws Exception {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        email.writeTo(buffer);
        String encodedEmail = Base64.getUrlEncoder().encodeToString(buffer.toByteArray());

        com.google.api.services.gmail.model.Message message =
                new com.google.api.services.gmail.model.Message();
        message.setRaw(encodedEmail);
        return message;
    }
}

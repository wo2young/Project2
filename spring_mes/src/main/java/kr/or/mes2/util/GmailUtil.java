package kr.or.mes2.util;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.gmail.Gmail;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.Session;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Base64;
import java.util.Collections;
import java.util.List;
import java.util.Properties;

public class GmailUtil {

    private static final String APPLICATION_NAME = "MES Mail Service";
    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();
    private static final List<String> SCOPES =
            Collections.singletonList("https://www.googleapis.com/auth/gmail.send");
    private static final String TOKENS_DIRECTORY_PATH = "tokens";

    private static Credential getCredentials(final com.google.api.client.http.HttpTransport HTTP_TRANSPORT)
            throws Exception {
        InputStream in = GmailUtil.class.getResourceAsStream("/credentials.json");
        GoogleClientSecrets clientSecrets =
                GoogleClientSecrets.load(JSON_FACTORY, new InputStreamReader(in));

        GoogleAuthorizationCodeFlow flow =
                new GoogleAuthorizationCodeFlow.Builder(
                        HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, SCOPES)
                        .setDataStoreFactory(new FileDataStoreFactory(new java.io.File(TOKENS_DIRECTORY_PATH)))
                        .setAccessType("offline")
                        .build();

        LocalServerReceiver receiver = new LocalServerReceiver.Builder().setPort(8888).build();
        return new AuthorizationCodeInstalledApp(flow, receiver).authorize("user");
    }

    public static void sendMail(String to, String subject, String bodyText) throws Exception {
        final com.google.api.client.http.HttpTransport HTTP_TRANSPORT =
                GoogleNetHttpTransport.newTrustedTransport();

        Gmail service = new Gmail.Builder(HTTP_TRANSPORT, JSON_FACTORY, getCredentials(HTTP_TRANSPORT))
                .setApplicationName(APPLICATION_NAME)
                .build();

        MimeMessage email = createEmail(to, "me", subject, bodyText);
        sendMessage(service, "me", email);
    }

    private static MimeMessage createEmail(String to, String from, String subject, String bodyText)
            throws Exception {
        Properties props = new Properties();
        Session session = Session.getDefaultInstance(props, null);

        MimeMessage email = new MimeMessage(session);
        email.setFrom(new InternetAddress(from));
        email.addRecipient(javax.mail.Message.RecipientType.TO, new InternetAddress(to)); // ✅ 명시적 패키지 지정
        email.setSubject(subject, "UTF-8");
        email.setText(bodyText, "UTF-8");
        return email;
    }

    private static void sendMessage(Gmail service, String userId, MimeMessage email)
            throws Exception {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        email.writeTo(buffer);

        String encodedEmail = Base64.getUrlEncoder().encodeToString(buffer.toByteArray());

        com.google.api.services.gmail.model.Message message =
                new com.google.api.services.gmail.model.Message(); // ✅ Gmail API용 Message 명시
        message.setRaw(encodedEmail);

        service.users().messages().send(userId, message).execute();
        System.out.println("[Gmail 전송 성공] → " + email.getAllRecipients()[0]);
    }
}

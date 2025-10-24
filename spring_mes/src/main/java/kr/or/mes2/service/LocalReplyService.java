package kr.or.mes2.service;

import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public class LocalReplyService {
    private final Map<String, String> map = Map.ofEntries(
        // 인사 / 기본 대화
        Map.entry("안녕", "안녕하세요! MES 챗봇입니다. 무엇을 도와드릴까요?"),
        Map.entry("안녕하세요", "안녕하세요! 오늘도 좋은 하루 되세요."),
        Map.entry("하이", "안녕하세요! 생산 현황을 보시겠어요?"),
        Map.entry("고마워", "별말씀을요! 도움이 되어 기쁩니다."),
        Map.entry("감사", "언제든지요! 다른 것도 물어보세요."),
        Map.entry("도와줘", "생산, 불량, 재고, 설비 중 어떤 정보를 보시겠어요?"),
        Map.entry("메뉴", "대시보드, 게시판, 마이페이지, 관리자 메뉴 중 어디로 가시겠어요?"),
        Map.entry("누구야", "저는 MES 챗봇이에요. 생산관리 시스템 도우미입니다."),
        Map.entry("너는 누구야", "저는 MES 챗봇이에요. 대시보드 데이터와 기본 안내를 도와드릴 수 있어요."),

        // 대시보드 / 데이터 조회 요청 관련
        Map.entry("생산량 알려줘", "답변 생각 중…"),
        Map.entry("불량률 알려줘", "답변 생각 중…"),
        Map.entry("재고 현황", "답변 생각 중…"),
        Map.entry("설비 상태", "답변 생각 중…"),

        // 시스템 / 지원 관련
        Map.entry("비밀번호", "비밀번호 변경은 마이페이지에서 가능합니다."),
        Map.entry("이메일", "이메일 변경은 마이페이지 설정에서 변경할 수 있습니다."),
        Map.entry("문의", "고객지원 탭에서 문의를 남기실 수 있습니다."),
        Map.entry("에러", "에러가 발생하셨나요? 어떤 화면에서 발생했는지 알려주시면 도와드릴게요."),
        Map.entry("로그인", "로그인 화면으로 이동하시겠어요?"),

        // 마무리 대화
        Map.entry("잘가", "안녕히 가세요! 다음에 또 뵙겠습니다."),
        Map.entry("수고", "감사합니다! 오늘도 좋은 하루 되세요.")
    );

    public String getLocalReply(String message) {
        if (message == null || message.isBlank()) return null;
        return map.getOrDefault(message.trim(), null);
    }
}

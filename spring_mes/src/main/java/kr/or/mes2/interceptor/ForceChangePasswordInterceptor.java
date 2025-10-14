package kr.or.mes2.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class ForceChangePasswordInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler)
            throws Exception {

        String ctx  = req.getContextPath();
        String path = req.getServletPath();

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("loginUser") != null);

        boolean must = false;
        if (loggedIn && session != null) {
            Object v = session.getAttribute("mustChangePw");
            if (v instanceof Boolean) must = (Boolean) v;
            else if (v != null) {
                String sv = String.valueOf(v);
                must = "true".equalsIgnoreCase(sv) || "Y".equalsIgnoreCase(sv) || "1".equals(sv);
            }
        }

        boolean allowed =
               path.startsWith("/mypage")
            || path.equals("/logout")
            || path.equals("/login")
            || path.startsWith("/resources/")
            || path.startsWith("/static/")
            || path.endsWith(".css") || path.endsWith(".js")
            || path.endsWith(".png") || path.endsWith(".jpg")
            || path.endsWith(".jpeg") || path.endsWith(".gif")
            || path.endsWith(".svg") || path.endsWith(".ico")
            || path.endsWith(".woff") || path.endsWith(".woff2");

        if (loggedIn && must && !allowed) {
            resp.sendRedirect(ctx + "/mypage");
            return false;  // 요청 중단
        }

        return true; // 다음 단계(Controller)로 진행
    }

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		
	}
}

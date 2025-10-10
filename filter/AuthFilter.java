package kr.or.human99.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private boolean isPublicPath(String uri, String ctx) {
        return uri.equals(ctx + "/login")
            || uri.equals(ctx + "/logout")
            || uri.startsWith(ctx + "/resources/")
            || uri.startsWith(ctx + "/css/")
            || uri.startsWith(ctx + "/js/")
            || uri.startsWith(ctx + "/images/")
            || uri.startsWith(ctx + "/assets/")
            || uri.startsWith(ctx + "/static/");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String ctx = req.getContextPath();
        String uri = req.getRequestURI();

        if (isPublicPath(uri, ctx)) {
            chain.doFilter(request, response);
            return;
        }
        if (uri.equals(ctx + "/login") && "POST".equalsIgnoreCase(req.getMethod())) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null) && Boolean.TRUE.equals(session.getAttribute("loggedIn"));
        if (!loggedIn) {
            res.sendRedirect(ctx + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}

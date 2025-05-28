package com.medicalcenter.filter;

import com.medicalcenter.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/doctor/*", "/patient/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession();
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            String requestURI = httpRequest.getRequestURI();

            // Check role-based access
            if (requestURI.contains("/admin/") && !"admin".equals(user.getRole())) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
                return;
            } else if (requestURI.contains("/doctor/") && !"doctor".equals(user.getRole())) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
                return;
            } else if (requestURI.contains("/patient/") && !"patient".equals(user.getRole())) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied.jsp");
                return;
            }

            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        }
    }

    @Override
    public void destroy() {
    }
}
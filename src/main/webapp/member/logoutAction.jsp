<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate(); //세션 갱신(기존 세션을 지운다)
	response.sendRedirect(request.getContextPath()+"/home.jsp");	//response는 클라이언트 명령이라 컨텍스트패스 필요함
%>
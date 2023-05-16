<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>

<%
	//deleteLocalForm 의 ActionForm입니다
	//인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	//디버깅 창의 폰트 색상 바꾸기
	final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
	final String RED = "\u001B[31m";	//stmt 디버깅 때 사용
	
	//로그인 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
	   response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
	   return;
	}
	
	//입력된 값에 대한 유효성 겁사
	if(request.getParameter("localName") == null
		|| request.getParameter("localName").equals("")){ // 지역명이 공백/null 넘어왔을 때
		
		response.sendRedirect(request.getContextPath()+"/local/deleteLocalForm.jsp");	
		return;
	}

	String localName = request.getParameter("localName");
	System.out.println(localName +"deleteLocalAction / param / localName");
	
	
	

	//db 불러오기
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbUser = "root";
	String dbPw = "java1234";	
	Class.forName(driver);
	System.out.println("deleteLocalAction"+"<-deleteLocalAction / 드라이버 로딩 성공");	
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
	System.out.println(conn+"deleteLocalAction- / 접속성공 ");
	
		
		
	//SQL 1. select로 db에 localName이 있는지 확인
	
	/* 쿼리문
	"SELECT COUNT(local_name)
	FROM board
	WHERE local_name=?"
	*/
	String sql = "SELECT COUNT(local_name) FROM board WHERE local_name=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	System.out.println(RED+stmt + "deleteLocalAction / Stmt" + RESET);
	ResultSet rs = stmt.executeQuery();
	

	
	//SQL 2. 삭제
	
	/* 쿼리문
	"DELETE FROM local
	where local_name=?"
	*/
	
	String delSql = "DELETE FROM local where local_name=?";
	PreparedStatement delStmt = conn.prepareStatement(delSql);
	delStmt.setString(1, localName);
	System.out.println(RED+ delStmt + "deleteLocalAction / delStmt" + RESET);
	
	//삭제 후 메세지 보내기
	int delRow = delStmt.executeUpdate();
	if (delRow > 0) { //삭제 성공
	    response.sendRedirect(request.getContextPath() + "/local/localㅣistForm.jsp?msg=지역 삭제가 완료되었습니다");
	    System.out.println("deleteLocalAction / 지역 삭제 성공");
	} else {
	    System.out.println( "지역 삭제 실패");
	}
	
	
	
%>




















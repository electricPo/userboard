<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>

<%
// insertLocallistForm의 ActionFrom 입니다
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	//디버깅 창의 폰트 색상 바꾸기
	final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
	final String RED = "\u001B[31m";	//stmt 디버깅 때 사용
	
	//로그인 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		//비 로그인 상태라면 메세지 없이 로컬리스트로 돌려보냄
	   response.sendRedirect(request.getContextPath()+"/local/localList.jsp");
	   return;
	}
	
	//입력된 값에 대한 유효성 겁사
	if(request.getParameter("localName2") == null
		|| request.getParameter("localName2").equals("")){ // 지역명이 공백/null 넘어왔을 때
		
		response.sendRedirect(request.getContextPath()+"/local/insertLocarlistForm.jsp");	
		return;
	}

	//  파라미터값 확인
	String localName2 = request.getParameter("localName2");
	System.out.println(localName2 + "<-insertLocalAction / localName2");
	
	

	//db 불러오기
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	//1)지역추가 결과셋
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// sql 문
	
	/*
	INSERT INTO local
		(local_name localName, createdate, updatedate) 
		VALUES(?, now(), now())
	*/
	
	String sql = "insert into local(local_name,  createdate, updatedate)  values(?, now(), now())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName2);
	System.out.println(RED+stmt + "<-insertLocalAction / stmt"+RESET);
	
	int row = stmt.executeUpdate();
	System.out.println(row+"<-insertLocalAction / row");
	
	// 수정된  DB값을  localListForm 보내기
	
	if(row != 0){ //입력성공
		response.sendRedirect(request.getContextPath()+"/local/localistForm.jsp?msg= !!!지역 추가 완료!!!");
		return;
		
	}
	
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %><!-- 글자깨짐 방지 -->
<%@ page import = "vo.*" %>

<%	

	//request 인코딩 설정

	request.setCharacterEncoding("utf-8");

	//세션 유효성 검사
	
	if(session.getAttribute("loginMemberId") !=null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//입력된 값에 대한 유효성 겁사
	if(request.getParameter("memberId") == null
		|| request.getParameter("memberPw") == null
		|| request.getParameter("memberId").equals("")
		|| request.getParameter("memberPw").equals("")){
		
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	
	

	//입력한 값 불러오기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅
	System.out.println(memberId +"insertMemberAction/param/memberId");
	System.out.println(memberPw +"insertMemberAction/param/memberPw");

	
	//드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	
	//불러오기
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	
	/*
	INSERT INTO member(
			member_id, 
			member_pw,
			createdate,
			updatedate,)
			VALUES(?, PASSWORD(?), NOW(), NOW())

	
	*/
	//쿼리 명령문
	String sql = "INSERT INTO member(member_id,member_pw,createdate,updatedate) VALUES(?, PASSWORD(?), NOW(), NOW())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	System.out.println(stmt +"<-insertMemberAction / stmt");
	
	
	int row = stmt.executeUpdate();	
	System.out.println(row + "<-updatestoreAction / row");
	
	
	//가입 성공에 따른 리다이렉션
	
	if(row == 1){ //가입 성공 경우
		System.out.println("가입 성공");
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		
	} else { //실패한 경우 다시 가입폼으로 돌아감
		response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
		System.out.println("가입 실패");
	}	
	
%>
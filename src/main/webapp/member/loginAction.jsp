<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%	
	


	//세션 유효성 검사 -> 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") !=null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//요청값 유효성 검사 //vo타입으로 묶기 //하나 이상인 경우 묶어서 처리
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//디버깅 출력
	
	System.out.println(request.getParameter("memberId")+"<-loginAction / param / memberId");
	System.out.println(request.getParameter("memberPw")+"<-loginAction / param / memberPw");
	
	/*
	//vo타입으로 묶기
	Member paramMember= new Member();
	paramMember.memberId = memberId;
	paramMember.memberPw = memberPw;
	*/
	

	
	
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

	
	//쿼리문
	/*
	"SELECT member_id memberId FROM member 
	WHERE member_id=? AND member_PW = PASSWORD(?)";
	*/
	
	
	String sql = "SELECT member_id memberId FROM member WHERE member_id=? AND member_PW = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	System.out.println(stmt +"<-loginAction / stmt");
	rs=stmt.executeQuery();
	
	if(rs.next()){ //로그인 성공
		session.setAttribute("loginMemberId", rs.getString("MemberId"));
		System.out.println("로그인 성공");
	}	else { //로그인 실패
		
		System.out.println("로그인 실패");
	}
	
	//로그인에 따른 메세지 보내기(선택)
	
	//String msg="";
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map -->
<%@ page import = "vo.*" %> 

<%

//!!!!!!!!!디버깅 창의 폰트 색상 바꾸기
	final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
	final String RED = "\u001B[31m";
	//stmt 디버깅 때 사용	

	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 
	if(session.getAttribute("loginMemberId")== null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	//리다이렉트용 변수 선언 (초기화/공백)
	String msg = null;
	String memberId = "";
	String memberPw = "";
	String newPw1 = "";
	String newPw2 = "";
	
	//공백/null값이 넘어오면 폼에서 메세지 출력(informMember.jsp)
	
	if(request.getParameter("memberId") == null
		||request.getParameter("memberPw") == null
		||request.getParameter("newPw1") == null
		||request.getParameter("newPw2") == null
		||request.getParameter("memberId").equals("")
		||request.getParameter("memberPw").equals("")
		||request.getParameter("newPw1").equals("")
		||request.getParameter("newPw2").equals("")){
			msg = "다시 시도해주세요";		
	}
	
	//새 비밀번호와 일치하지 않을 경우 폼에서 메세지 출력(informMember.jsp)
	
	if(!request.getParameter("newPw1").equals(request.getParameter("newPw2"))){
		
		msg = "비밀번호가 일치하지 않습니다";
	}
	//디버깅
	System.out.println(request.getParameter("memberId")+"<-informMemberAction / param / memberId");
	System.out.println(request.getParameter("memberPw")+"<-informMemberAction / param / memberPw");
	System.out.println(request.getParameter("newPw1")+"<-informMemberAction / param / newPw1");
	System.out.println(request.getParameter("newPw2")+"<-informMemberAction / param / newPw2");
	
	
	
	//String에 파라미터 값 넣기
	memberId = request.getParameter("memberId");
	memberPw = request.getParameter("memberPw");
	newPw1 = request.getParameter("newPw1");
	newPw2 = request.getParameter("newPw2");
	
	//확인
	
	System.out.println(memberId +"informMemberAction / memberId");
	System.out.println(memberPw +"informMemberAction / memberPw");
	System.out.println(newPw1 +"informMemberAction / newPw1");
	System.out.println(newPw2 +"informMemberAction / newPw2");
	

	
	//db 불러오기
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	System.out.println("informMemberAction" +"informMemberAction / 드라이버 접송 성공");
	
	//쿼리문 (db의 회원정보가 일치한다면 -> 정보 바꾸기)
	String upMember = "UPDATE member SET member_pw=PASSWORD(?), updatedate=NOW() WHERE member_id=? AND member_pw=PASSWORD(?)";
	PreparedStatement upStmt = conn.prepareStatement(upMember);
	System.out.println(RED+upStmt +"informMemberAction / upStmt"+RESET);
	upStmt.setString(1, newPw1);
	upStmt.setString(2, memberId);
	upStmt.setString(3, memberPw);
	
	int row = upStmt.executeUpdate();
	System.out.println(RED+ upStmt +"<-informMemberAction upStmt"+RESET);
	
	//비밀번호 변경 성공/실패에 따라
	
	if(row == 0){	//변경 실패
		response.sendRedirect(request.getContextPath()+"/member/informMember.jsp?msg=pw error");
		System.out.println("수정 실패");
	}	else if (row == 1){ //변경 성공
		response.sendRedirect(request.getContextPath()+"/member/informMember.jsp?msg=pw changed");	
		System.out.println("수정 성공");
	}
	
	
	


%>
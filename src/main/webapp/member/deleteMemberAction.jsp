<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map -->
<%@ page import = "vo.*" %> 
<%
//!!!!!!!!!디버깅 창의 폰트 색상 바꾸기
	final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
	final String RED = "\u001B[31m";
	//stmt 디버깅 때 사용	


	//인코딩
	request.setCharacterEncoding("utf-8");
	
	//유효성 검사 
	if(session.getAttribute("loginMemberId")== null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//msg 변수 선언
	String msg = null;
	
	//memberPw가 null/"" 일 때 보낼 메세지
	if(request.getParameter("memberPw") == null||
	request.getParameter("memberPw").equals("")){
		msg = "비밀번호를 다시 확인하세요";			
	}
	if(msg != null){												
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp?msg="+msg);
		return;
	}
	
	//디버깅
	System.out.println(request.getParameter("memberId")+"<-deleteMemberAction / param / memberId");
	System.out.println(request.getParameter("memberPw")+"<-deleteMemberAction / param / memberPw");
	
	//String에 파라미터 값 넣기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//확인
	
	System.out.println(memberId +"deleteMemberAction / memberId");
	System.out.println(memberPw +"deleteMemberAction / memberPw");
	
	//db 불러오기
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	System.out.println("deleteMemberAction" +"deleteMemberAction / 드라이버 접송 성공");
	
	PreparedStatement delStmt = null;
	int delMemberRow = 0;
	
	//쿼리문 (db에서 회원정보 삭제)
	String delMemberSql = "DELETE FROM member WHERE member_id = ? AND member_Pw = PASSWORD(?)";
	delStmt = conn.prepareStatement(delMemberSql);
	delStmt.setString(1, memberId);
	delStmt.setString(2, memberPw);
	System.out.println(RED+"delStmt" +"deleteMemberAction / delStmt" +RESET);
	
	delMemberRow = delStmt.executeUpdate();
	System.out.println("delMemberRow" +"deleteMemberAction / deleteMemberRow");
	
	
	//삭제 실패/성공 여부에 따라 다음 페이지로 보낸다
	 
	if(delMemberRow == 0){	//변경 실패
		msg = "!!!!Error!!!!";
		response.sendRedirect(request.getContextPath()+"/member/deleteMemberForm.jsp");
		System.out.println("탈퇴 실패");
	}	else{ //변경 성공
		session.invalidate(); //탈퇴 성공 ->세션 무효화하기
		response.sendRedirect(request.getContextPath()+"/member/home.jsp");	
		System.out.println("탈퇴 성공");
	}
	
	
	
		

%>
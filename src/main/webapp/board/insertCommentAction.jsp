<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	//!!!!!!!!!디버깅 창의 폰트 색상 바꾸기
	final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
	final String RED = "\u001B[31m";
	//stmt 디버깅 때 사용	
	
	
	// 세션 유효성 검사: 로그인이 되어있지 않으면 댓글입력은 불가하므로 상세페이지로 되돌아가기
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp?");
		return;
	}
	
	//값이 넘어왔는지 확인
	System.out.println(request.getParameter("commentContent")+"<-insertCommentAction / param / commentContent");
	System.out.println(request.getParameter("memberId")+"<-insertCommentAction / param / memberId");
	System.out.println(request.getParameter("createdate")+"<-insertCommentAction / param / createdate");
	System.out.println(request.getParameter("updatedate")+"<-insertCommentAction / param / updatedate");

// !!!!!!!!!세션 유효성 검사 -> 요청값 유효성 검사
	//넘어오는 값: commentContent memberId createdate updatedate
	if(request.getParameter("boardNo") == null
		||request.getParameter("commentContent") == null
		||request.getParameter("boardNo").equals("")
		||request.getParameter("commentContent").equals("")){
 		response.sendRedirect(request.getContextPath()+"/home.jsp");
 		return;
 		}	//값이 넘어왔다면
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
 		String memberId = request.getParameter("memberId");
 		
 		
	//commentContent 값이 null이라면
	if(request.getParameter("commentContent") == null
		||request.getParameter("commentContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?board="+boardNo);
 		return;
	}	//댓글 내용이 있다면 파라미터 값 요청
	
	String commentContent = request.getParameter("commentContent");
 	
	//디버깅
	System.out.println(request.getParameter("boardNo")+"<-insertCommentAction / boardNo");
	System.out.println(request.getParameter("memberId")+"<-insertCommentAction / memberId");
	System.out.println(request.getParameter("commentContent")+"<-insertCommentAction / commentContent");
	

 		
 		
//!!!!!!!!!!!!!!!!!!!!!!!!모델계층



	//db 불러오기
 		String driver = "org.mariadb.jdbc.Driver";
 		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
 		String dbuser = "root";
 		String dbpw = "java1234";
 		
 		Class.forName(driver);
 		Connection conn = null;
 		conn = DriverManager.getConnection(dburl, dbuser, dbpw);
 		
 	//디버깅
 	System.out.println(conn+"<-insertCommentAction / conn");
 	
 	//댓글창 결과셋		
 		String commentSql = null;
 		PreparedStatement commentStmt = null;
 		int commentRow = 0;
 		
 	//쿼리문
 		/*
 		INSERT INTO comment
 		(board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate)
 		VALUES(?, ?, ?, NOW(), NOW())";

 		
 		*/
 		commentSql= "INSERT INTO COMMENT (board_no, comment_content, member_id, createdate, updatedate) VALUES(?, ?, ?, NOW(), NOW())";
 		commentStmt = conn.prepareStatement(commentSql);
 		commentStmt.setInt(1, boardNo);
 		commentStmt.setString(2, commentContent);
 		commentStmt.setString(3, memberId);
 		System.out.println(RED+ commentStmt + " <-insertCommentAction commentStmt" + RESET);
 		
 		//쿼리 실행 결과에 따른 결과 출력
 		commentRow = commentStmt.executeUpdate();
 		if(commentRow == 1){ //댓글 입력 성공시
 			System.out.println(commentRow + " <-insertCommentAction 입력성공");
 		} else{
 			System.out.println(commentRow + " <-insertCommentAction 입력실패");
 		}
 		
 		
		// 입력이 완료후 리다이렉션
		// 결과와 상관없이 boardOne으로 되돌아간다
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
	
	
	
	
	
%>	
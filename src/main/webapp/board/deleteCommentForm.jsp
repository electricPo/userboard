<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map, ArrayList...-->
<%@ page import = "vo.*" %> 




<% 

//!!!!!!!!!디버깅 창의 폰트 색상 바꾸기
	final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
	final String RED = "\u001B[31m";
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	
	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	//입력값 유효성 검사
		if(request.getParameter("commentNo") == null
			||request.getParameter("boardNo") == null
			||request.getParameter("memberId") == null
			
			||request.getParameter("commentNo").equals("")
			||request.getParameter("boardNo").equals("")
			||request.getParameter("memberId").equals("")){
	 		response.sendRedirect(request.getContextPath()+"/home.jsp");
	 		return;
	 		}	//값이 넘어왔다면
			

		
		String loginMemberId =(String)session.getAttribute("loginMemberId") ;
		System.out.println(request.getParameter(session.getAttribute("loginMemberId") + "<-deleteCommentAction / param / loginMemberId" ));
		
		
		//String에 파라미터 값 넣기
		String boardNo=request.getParameter("boardNo");	
		String commentNo =request.getParameter("commentNo");
		String memberId=request.getParameter("memberId");
		
		
		//값이 넘어왔는지 확인
		System.out.println(commentNo + "<-deleteCommentForm / param / commentContent");
		System.out.println(boardNo + "<-deleteCommentForm  / param / boardNo");
		System.out.println(memberId +"<-deleteCommentForm  / param / memberId");

		
		
		//db 불러오기
 		String driver = "org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbUser = "root";
		String dbPw = "java1234";	
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
		
		//디버깅
	 	System.out.println(conn+ "<-deleteCommentForm  / conn");
		
		
		//삭제 sql문
	 	String delSql = "DELETE FROM comment where comment_no =? AND member_id =? ANd board_no=?";
			PreparedStatement delStmt = conn.prepareStatement(delSql);
			delStmt.setString(1, commentNo);
			delStmt.setString(2, memberId);
			delStmt.setString(3, boardNo);
			System.out.println(delStmt + " <---stmt-- commentDelete.jsp delStmt");
	 	System.out.println(RED+ delStmt + "<-deleteCommentForm  stmt" +RESET);
	 	
		int delrow = delStmt.executeUpdate();
		
		
		if(delrow  > 0 ){ //삭제 성공

			response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo);
			System.out.println("삭제 성공");		
		}else{//삭제 실패
			response.sendRedirect(request.getContextPath() +"/board/boardOne.jsp");
			System.out.println("삭제 실패");
			return;
		}
		
%>




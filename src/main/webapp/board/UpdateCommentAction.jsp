<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map -->
<%@ page import = "vo.*" %> 


<%

//!!!!!!!!!디버깅 창의 폰트 색상 바꾸기
	final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
	final String RED = "\u001B[31m";
	
	//세션 유효성 검사: 로그인 유무에 따라 접근이 제한됨
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp?");
		return;
	}
	System.out.println(request.getParameter(session.getAttribute("loginMemberId") + "<-updateCommentAction / param / loginMemberId" ));	
	String loginMemberId =(String)session.getAttribute("loginMemberId") ;
	
	// 유효성 검사 -> 요청값 유효성 검사

		if(request.getParameter("commentNo") == null
			||request.getParameter("boardNo") == null
			||request.getParameter("memberId") == null
			||request.getParameter("commentContent") == null
			||request.getParameter("password") == null
			||request.getParameter("commentNo").equals("")
			||request.getParameter("boardNo").equals("")
			||request.getParameter("memberId").equals("")
			||request.getParameter("commentContent").equals("")
			||request.getParameter("password").equals("")){
	 		response.sendRedirect(request.getContextPath()+"/home.jsp");
	 		return;
	 		}	//값이 넘어왔다면
			
		String boardNo=request.getParameter("boardNo");	
		int commentNo =Integer.parseInt(request.getParameter("commentNo"));
		String memberId=request.getParameter("memberId");
		String password=request.getParameter("password");
		String commentContent =request.getParameter("commentContent");
		

		//값이 넘어왔는지 확인
		System.out.println(commentNo + "<-commentUpateAction / param / commentContent");
		System.out.println(boardNo + "<-commentUpateAction / param / boardNo");
		System.out.println(memberId +"<-commentUpateAction / param / memberId");
		System.out.println(commentContent +"<-commentUpateAction / param / commentContent");
		System.out.println(password +"<-commentUpateAction / param / password");

		//db 불러오기
 		String driver = "org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbUser = "root";
		String dbPw = "java1234";	
		Class.forName(driver);
		System.out.println("commentUpdateAction-->드라이버 로딩 성공");	
		Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);	
		System.out.println("commentUpdateAction-->접속성공 "+conn);	
 		
	 	//디버깅
	 	System.out.println(conn+"<-commentUpateAction / conn");
		
	 	//수정 쿼리문
		String sql = "UPDATE comment c JOIN member m ON c.member_id = m.member_id SET c.comment_content = ?, c.updatedate = NOW() WHERE c.comment_no = ? AND m.member_pw = PASSWORD(?);";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, commentContent);
		stmt.setInt(2, commentNo);
		stmt.setString(3, password);
		System.out.println(RED+ stmt + "<----upComStmt-commentUpdateAction.jsp" +RESET);

		
		int row = stmt.executeUpdate();
		
		if(row == 0){ //수정 실패

			response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo);
			System.out.println("수정불가");		
		}else if(row==1){//수정 성공
			response.sendRedirect(request.getContextPath() +"/board/boardOne.jsp?boardNo="+boardNo);
			System.out.println("수정성공");
			return;
		}
		
%>
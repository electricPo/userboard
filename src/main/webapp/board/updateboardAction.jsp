<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map, ArrayList...-->
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
	
		if(request.getParameter("memberId") == null
			||request.getParameter("localName") == null
			||request.getParameter("boardTitle") == null
			||request.getParameter("boardContent") == null

			||request.getParameter("memberId").equals("")
			||request.getParameter("localName").equals("")
			||request.getParameter("boardTitle").equals("")
			||request.getParameter("boardContent").equals("")){
	 		System.out.println("디시 입력하세요" + ("updateboardAction Param"));
	 		return;
	 		}	//값이 넘어왔다면
			
			
		String memberId=request.getParameter("memberId");	
		String localName =request.getParameter("localName");
		String boardTitle=request.getParameter("boardTitle");
		String boardContent=request.getParameter("boardContent");
		
		//값이 넘어왔는지 확인
		System.out.println(memberId + "<-updateboardAction / param / memberId");
		System.out.println(localName + "<-updateboardAction / param / localName");
		System.out.println(boardTitle +"<-updateboardAction / param / boardTitle");
		System.out.println(boardContent +"<-updateboardAction / param / boardContent");

	


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
		String sql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate,updatedate) VALUES (?,?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, localName);
		stmt.setString(2, boardTitle);
		stmt.setString(3, boardContent);
		stmt.setString(4, memberId);
		
		System.out.println(RED+ stmt + "<-updateboardAction stmt" +RESET);

		
		int row = stmt.executeUpdate();


		if(row > 0){ //수정 성공

			response.sendRedirect(request.getContextPath() + "/home.jsp?boardNo");
			System.out.println("수정 성공");		
		}else if(row==1){//수정 성공
			response.sendRedirect(request.getContextPath() +"/home.jsp?boardNo");
			System.out.println("수정 실패");
			return;
		}
	 	
		
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map, ArrayList...-->
<%@ page import = "vo.*" %> 


<%
//!!!!!!!!!디버깅 창의 폰트 색상 바꾸기
	final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
	final String RED = "\u001B[31m";
	//stmt 디버깅 때 사용	

	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	// 세션 유효성 검사
	if(session.getAttribute("loginMemberId") ==null){ //세션 로그인 값이 없다면
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}
	
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	System.out.println(session.getAttribute("loginMemberId") + "<-deleteboardAction param  loginMemberId");

	
	//파라미터값 검사
		if(request.getParameter("boardNo") == null ||
		request.getParameter("memberId") == null ||
		
		request.getParameter("boardNo").equals("")||
		request.getParameter("memberId").equals("")){
			
			System.out.println("deleteboardAction param error");
			response.sendRedirect(request.getContextPath()+"/board/boarOne.jsp?boardNo="+request.getParameter("boardNo"));
			return;	
		}
		
	
		String boardNo = request.getParameter("boardNo");
		String memberId = request.getParameter("memberId");
		System.out.println(boardNo + "<-deleteboardAction boardNo ");
		System.out.println(memberId + "<-deleteboardAction memberId ");
	
	
		//db 불러오기
		String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbuser = "root";
		String dbpw = "java1234";
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		System.out.println(conn +"<-updateboardForm / conn");
		
		
		//삭제 sql문
		String sql = "DELETE FROM board where board_no =? AND member_id =?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, boardNo);
		stmt.setString(2, memberId);
		System.out.println(RED + stmt + " <-deleteboardAction stmt" + RESET);
		ResultSet rs = stmt.executeQuery();


		//똑바로 들어갔다면 한 행만 갱신됐다고 뜰 것이다.
		int row = stmt.executeUpdate();
		if (row > 0) { //삭제 실패
		    response.sendRedirect(request.getContextPath() + "/home.jsp?msg=delete Successful!");
		    System.out.println(" 성공 후 home으로 리턴 deleteBoardAction");
		    return;
		} else {
		    System.out.println("삭제된 row가 없습니다.");
		}
		
		
%>





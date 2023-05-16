<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %>

<%
	//updateLocalForm 의 ActionForm  입니다
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
	if(request.getParameter("newLocalName") == null
		|| request.getParameter("newLocalName").equals("")){ // 지역명이 공백/null 넘어왔을 때
		
		response.sendRedirect(request.getContextPath()+"/local/updateLocalForm.jsp");	
		return;
	}
	
	//  파라미터값 확인
	String newLocalName = request.getParameter("newLocalName");
	String LocalName = request.getParameter("LocalName");
	System.out.println(newLocalName + "<- updateLocalAction / newLocalName");
	
	//db 불러오기
		String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbuser = "root";
		String dbpw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		
	// 로컬메뉴 결과셋
	PreparedStatement Stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	String sql = null;
	sql = "SELECT local_name localName FROM local";
	Stmt = conn.prepareStatement(sql);
	Stmt.setString(1, newLocalName);
	rs = Stmt.executeQuery();
	
	// 결과셋을 어레이리스트로
	//VO/Local클래스로 어레이리스트 만들기 ->  게시판 모양
	ArrayList<Local> localList = new ArrayList<Local>();	//사이즈가 0인 ArrayList 선언
	
	//resultSet을 AllayList로 바꿔준다
	//vo에서 getter setter 자동변환해두기
	while(rs.next()){
		Local c = new Local();
		c.setLocalName(rs.getString("localName"));
		localList.add(c);
	}
	System.out.println(localList.size() + " <--updateLocalAction localList.size()"); 
	
	
	// 불러온 db값과 입력값을 비교
	for(Local c : localList){
		if(newLocalName.equals("localName")){
			response.sendRedirect(request.getContextPath()+"/local/updateLocalForm.jsp");
			return;
		}
	} 
	
	//수정할 db 쿼리문
	//변수 초기화
	String updateSql = null;
	PreparedStatement updateStmt = null;
	ResultSet updateRs = null;
	int updateRow = 0;
	
	updateSql = "UPDATE local SET local_name = ? WHERE local_name = ?";
	updateStmt = conn.prepareStatement(updateSql);
	updateStmt.setString(1, newLocalName);
	updateStmt.setString(2, LocalName);
	System.out.println(RED+ updateStmt + " <--updateLocalAction updateStmt" +RESET);
	updateRow = updateStmt.executeUpdate();
	
	// 입력 성공/실패시 리다이렉션
	if(updateRow == 1){ //입력 성공
		System.out.println(updateRow + " <--updateLocalAction updateRow // 입력 성공");
		response.sendRedirect(request.getContextPath()+"/local/locallistForm.jsp");
	} else {
		System.out.println(updateRow + " <--updateLocalAction updateRow // 입력 실패");
		response.sendRedirect(request.getContextPath()+"/local/locallistForm.jsp");
	}


	
	
%>
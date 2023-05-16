<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map -->
<%@ page import = "vo.*" %> 


<%
 //!!!!!!!!!디버깅 창의 폰트 색상 바꾸기
 		final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
 		final String RED = "\u001B[31m";
 		//stmt 디버깅 때 사용	

 	
 /*	home의 게시글을 클릭했을 때
 	게시글의 상세내용과 밑에 댓글창이 보이게
 */
 		

 //!!!!!!!!!!!!!!!!!!!!!!!!요청분석 유효성 검사
 		int currentPage = 1;
 		int rowPerPage = 10;//페이지 가져오기(필수)
 		int startRow = 0;

 
 		
 		if(request.getParameter("boardNo") == null
 		|| request.getParameter("boardNo").equals("")){
 		response.sendRedirect(request.getContextPath()+"/home.jsp");
 		return;
 		}
 		
 		int boardNo = Integer.parseInt(request.getParameter("boardNo"));

 		System.out.println(boardNo + "<-boardOne ");

 		

 //!!!!!!!!!!!!!!!!!!!!!!!!모델계층

 	
 		//db 불러오기
 		String driver = "org.mariadb.jdbc.Driver";
 		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
 		String dbuser = "root";
 		String dbpw = "java1234";
 		
 		Class.forName(driver);
 		Connection conn = null;
 		conn = DriverManager.getConnection(dburl, dbuser, dbpw);
 		
 		//게시판 결과셋
 		PreparedStatement onemenuStmt = null;
 		ResultSet onemenuRs = null;	
 		
 		
 		/*
		 		SELECT
		 	board_no boardNo,
		 	local_name localName,
		 	board_title boardTitle,
		 	board_content boardContent,
		 	member_id memberId,
		 	createdate
		 		FROM board
		 		 WHERE board_no = ?
		 		;
 		*/
 		
 		

 		//첫번째 쿼리문
 		String oneSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
 		onemenuStmt = conn.prepareStatement(oneSql);
 		onemenuStmt.setInt(1, boardNo);
 		System.out.println(onemenuStmt +"<-boardOne / onemenuStmt");
 		
 		//쿼리실행
 		onemenuRs = onemenuStmt.executeQuery();
 		
 		

 		
 		//onemenuRs 결과셋을 어레이리스트로
 		Board board = null;
 		ArrayList<Board> oneList = new ArrayList<Board>(); //애플리케이션에서 사용할 모델 (사이즈 0)
 		while(onemenuRs.next()){
		 	Board o = new Board();
		 	
		 	o.setBoardNo(onemenuRs.getInt("boardNo"));
		 	o.setLocalName(onemenuRs.getString("LocalName"));
		 	o.setBoardTitle(onemenuRs.getString("BoardTitle"));
		 	o.setCreatedate(onemenuRs.getString("Createdate"));
		 	o.setBoardContent(onemenuRs.getString("BoardContent"));
		 	o.setMemberId(onemenuRs.getString("MemberId"));
		 	oneList.add(o);
		 		}
 		
 		
 		//댓글창 결과셋
 		
 		PreparedStatement commentListStmt = null;
 		ResultSet commentRs = null;
 		
 		System.out.println(RED+commentListStmt + "<-boardOne / commentListStmt"+RESET);
 			
 		
 		/*
 		SELECT comment_no, board_no, comment_content
		FROM COMMENT
		WHERE board_no = 1000
		LIMIT 0,10;
 		
 		SELECT board_no, board_title
		FROM board
		WHERE board_no=1000;
 	
 		*/
 		
 		//두번째 쿼리문
 		String commentListSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? ORDER BY createdate DESC LIMIT ?, ?";
 		commentListStmt = conn.prepareStatement(commentListSql);
 		commentListStmt.setInt(1, boardNo);
 		commentListStmt.setInt(2, startRow);
 		commentListStmt.setInt(3, rowPerPage);
 		 		
 		//쿼리실행
 		
 		commentRs = commentListStmt.executeQuery(); //ArrayList<Comment>
 		
 		//commentListRs 결과셋을 어레이리스트로
 			//오류:JSP를 위한 클래스를 컴파일할 수 없습니다.
 			//You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'createdate DESC LIMIT 0,10' at line 1
 			//해결:sql문에 createdate -> x
 		
 		ArrayList<Comment> commentList = new ArrayList<Comment>();
			while(commentRs.next()) {
				Comment c = new Comment();
				
			c.setCommentNo(commentRs.getInt("CommentNo"));
 			c.setCommentContent(commentRs.getString("CommentContent"));
 			c.setMemberId(commentRs.getString("MemberId"));
 			c.setCreatedate(commentRs.getString("Createdate"));
 			c.setUpdatedate(commentRs.getString("Updatedate"));
 			
 			commentList.add(c);
 		}
 		System.out.println(commentList.size()+ "<-boardOne / commentList.size()");
 		
 		
 		//디버깅
 		System.out.println(oneList + "<-boardOne / oneList");
 		System.out.println(oneList.size() + "<-boardOne / oneList"); //10
 		System.out.println(RED+onemenuStmt + "<-boardOne / oneList"+RESET);
 %>


<!DOCTYPE html>
<html>
<head>
<style>

	.navbar-nav{
		font-weight: 800;
	}

	a {
		decoration:none;
	}
</style>



<!------------------------------- 전체 테마 부트스트랩 탬플릿1 -->

  <!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	
    
    
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        
        
<!------------------------------- 지역 click 부트스트랩 템플릿 -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>


<meta charset="UTF-8">
<title>boardOne</title>
<!------------------------------- 전체 테마 부트스트랩 탬플릿2 -->
<!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
        <!-- Font Awesome icons (free version)-->
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
        <!-- Google fonts-->
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
        <link href="https://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic" rel="stylesheet" type="text/css" />
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="css/styles.css" rel="stylesheet" />
        
        

</head>
<body id="page-top">
        <!-- Navigation-->
        <nav class="navbar navbar-expand-lg bg-secondary text-uppercase fixed-top" id="mainNav">
            <div class="container">
                <a class="navbar-brand" href="<%= request.getContextPath()%>/home.jsp">USER BOARD</a>
                <button class="navbar-toggler text-uppercase font-weight-bold bg-primary text-white rounded" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                    Menu
                    <i class="fas fa-bars"></i>
                </button>
                <!-- 메인메뉴(가로) -->
                <!-- 메인메뉴를 가로 -> mainmanu.jps에서  -->
				<div  class="collapse navbar-collapse"  id="navbarResponsive" >
					<ul class="navbar-nav ms-auto">
						<li class="nav-item mx-0 mx-lg-1">
							<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
						</li>
					</ul>
				</div>
                <!-- 
                <div class="collapse navbar-collapse" id="navbarResponsive">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#portfolio">Portfolio</a></li>
                        <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#about">About</a></li>
                        <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#contact">Contact</a></li>
                    </ul>
                </div>
                 -->
            </div>
        </nav>


<!--!!!!!!!!!!!!!!!!!!!!!!!!<시작> oneList !!!!!!!!!!!!!!!!!!!!!!!!-->
	<!-- 게시글의 상세 내용 보이기 -->
	<div class="container px-4 px-lg-5 text-center">
		<table class=" table table-hovered">
				<tr>
					<th class="text-center">board No</th>
					<th class="text-center">local Name</th>
					<th class="text-center">board Title</th>
					<th class="text-center">board Content</th>
					<th class="text-center">member Id</th>
					<th class="text-center">createdate</th>
					<th colspan="2"></th>
				</tr>
			 
			<%
						for(Board o : oneList){
			%>
			
				<tr>
					<td><%=o.getBoardNo()%></td>
					<td><%=o.getLocalName()%></td>
					<td><%=o.getBoardTitle()%></td>
					<td><%=o.getBoardContent()%></td>
					<td><%=o.getMemberId()%></td>
					<td><%=o.getCreatedate()%></td>
					<td>
						<a href="<%=request.getContextPath()%>/board/updateboardForm.jsp?boardNo=<%=o.getBoardNo()%>" class="btn btn-secondary">
							수정
						</a>
					</td>
					<td>
						<form action="<%=request.getContextPath()%>/board/deleteboardAction.jsp" method="post">
							<input type="hidden" name="boardNo" value="<%=o.getBoardNo()%>">
							<input type="hidden" name="memberId" value="<%=o.getMemberId()%>">
							
							<button type="submit" class="btn btn-secondary">삭제</button>
						</form>
					</td>
				</tr>
		
			<%
				}
			%>
		</table>

	</div>

<!--!!!!!!!!!!!!!!!!!!!!!!!!<끝> oneList !!!!!!!!!!!!!!!!!!!!!!!!-->
	
<!-- comment 입력: 세션유무에 따른 분기 --> 
<!-- 로그인 사용자만 댓글 입력 허용 -->
	<%
	
	if(session.getAttribute("loginMemberId") != null){
		String loginMemberId = (String)session.getAttribute("loginMemberId"); //현재 로그인 사용자의 아이디
	%>
		<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">	
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<input type="hidden" name="memberId" value="<%=loginMemberId%>">
			<div class="container px-4 px-lg-5 text-center">
			<table class="table table-hovered ">
				
				<tr>
					<th class="text-center">댓글</th>
					<td><textarea rows = "2" cols="80" name="commentContent"></textarea></td>
					<td><button type="submit" class="btn btn-secondary">입력</button></td>
				</tr>
			
			</table>
			
			</div>
		</form>
		&nbsp;
	<%
		
		
	}
	
	%>
<!-- comment list 결과셋 -->	
	<div class="container px-4 px-lg-5 text-center">
		<table class="table table-hover " style="text-align: center;">
				<tr>
					<th class="text-center">CommentNo</th>
					<th class="text-center">commentContent</th>
					<th class="text-center">memberId</th>
					<th class="text-center">createdate</th>
					<th class="text-center">updatedate</th>
					<th colspan="2"></th>
					
				</tr>
			<%
				for(Comment c : commentList){
			%>		
				<tr>
					<td><%=c.getCommentNo()%></td>
					<td><%=c.getCommentContent()%></td>
					<td><%=c.getMemberId()%></td>
					<td><%=c.getCreatedate()%></td>
					<td><%=c.getUpdatedate()%></td>
					<td><a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>&memberId=<%=c.getMemberId()%>&commentContent=<%=c.getCommentContent()%>">
										수정 </a> </td>
					<td><a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.getCommentNo()%>&boardNo=<%=c.getBoardNo()%>&memberId=<%=c.getMemberId()%>">
										 삭제 </a></td>
			
				</tr>
			<%		
				}
			%>
			<tr>
				<td></td>
				
			</tr>
		</table>
	</div>
<!-- 페이징 -->

	<div class="container px-4 px-lg-5 text-center">
	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">이전</a>
	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">다음</a>
	</div>
	
	
	
	<div>
	<!-- include 페이지 : copyright &copy; 구디아카데미-->
	<%
	
	//request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response); 
	//RequestDispatcher: 이 페이지의 '리퀘스트'와 '리스폰스'를 copyright.jsp와 공유함 (한 페이지에 같이 보임)
	//request.getContextPath(): 절대 주소 메서드 : 파일 위치가 바뀌어도 찾을 수 있다
	 
	%>
	
	
	
	
	
        <nav class="navbar navbar-expand-lg bg-secondary text-uppercase fixed-top" id="mainNav">
            <div class="container">

				<div  class="collapse navbar-collapse" id="navbarResponsive">
				
					<jsp:include page="/inc/copyright.jsp"></jsp:include>
				</div>
                <!-- 
                <div class="collapse navbar-collapse" id="navbarResponsive">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#portfolio">Portfolio</a></li>
                        <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#about">About</a></li>
                        <li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="#contact">Contact</a></li>
                    </ul>
                </div>
                 -->
            </div>
        </nav>
</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map -->
<%@ page import = "vo.*" %> 

<%
	//세션 유효성 검사: 로그인 유무에 따라 접근이 제한됨
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp?");
		return;
	}
	System.out.println(request.getParameter(session.getAttribute("loginMemberId") + "<-commentUpateForm / param / loginMemberId" ));	
	String loginMemberId =(String)session.getAttribute("loginMemberId") ;


	// 유효성 검사 -> 요청값 유효성 검사

	if(request.getParameter("commentNo") == null
		||request.getParameter("boardNo") == null
		||request.getParameter("memberId") == null
		||request.getParameter("commentContent") == null
		||request.getParameter("commentNo").equals("")
		||request.getParameter("boardNo").equals("")
		||request.getParameter("memberId").equals("")
		||request.getParameter("commentContent").equals("")){
 		response.sendRedirect(request.getContextPath()+"/home.jsp");
 		return;
 		}	//값이 넘어왔다면
		
	String boardNo=request.getParameter("boardNo");	
	String commentNo=request.getParameter("commentNo");
	String memberId=request.getParameter("memberId");
	String commentContent =request.getParameter("commentContent");
	

	//값이 넘어왔는지 확인
	System.out.println(commentNo + "<-commentUpateForm / param / commentContent");
	System.out.println(boardNo + "<-commentUpateForm / param / boardNo");
	System.out.println(memberId +"<-commentUpateForm / param / memberId");
	System.out.println(commentContent +"<-commentUpateForm / param / commentContent");
	
	
%>


<!DOCTYPE html>
<html>
<head>
<style>

	.navbar-nav{
		font-weight: 800;
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
<title>home</title>
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


	

	<div class="container px-4 px-lg-5 text-center">
	<h3>댓글 수정</h3>
		<form action="<%=request.getContextPath()%>/board/UpdateCommentAction.jsp" method="post">
					<input type="hidden" name="boardNo" value="<%=boardNo.trim()%>">
					<input type="hidden" name="commentNo" value="<%=commentNo.trim()%>">
					<table class=" table table-hovered">
						<tr>
							<td>User Id</td>
							<td>
								<input type="text" class="form-control" name="memberId" readonly="readonly" value="<%=memberId.trim()%>">
							</td>
						</tr>
						<tr>
							<td>Password</td>
							<td>
								<input type="password" class="form-control" name="password">
							</td>
						</tr>
						<tr>
							<td>Comment Content</td>
							<td>
								<textarea rows="3" cols="80" name="commentContent" ><%=commentContent.trim()%></textarea>
							</td>
						</tr>
					</table>
					<div align="center">
						<button type="submit"  class="btn btn-primary" >수정</button>
						<button> <a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-secondary">취소</a> </button>	
					</div>
				</form>	
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
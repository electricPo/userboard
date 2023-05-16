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

	//회원정보 보이게
	//넘어올 값 member member_id member_pw, createdate updatedate

	//유효성 검사 -> 애초에 로그인 된 사람만 회원정보 창이 보임
	if(session.getAttribute("loginMemberId")== null){
		response.sendRedirect(request.getContextPath()+"home.jsp");
		return;
	}
	

	//db 불러오기
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		
	//sql (회원정보 가져오기)
	PreparedStatement stmt = null;
	ResultSet rs = null;
	String sql = "SELECT member_id memberId, createdate, updatedate  FROM member WHERE member_id=?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, (String)session.getAttribute("loginMemberId"));
	
	System.out.println(RED+stmt+"<-informMember / stmt"+RESET);
	
	rs = stmt.executeQuery();
	
	//정보값을 넣기 위한 리스트 생성
	
	Member m = null;
	
	if(rs.next()){
		m = new Member();
		m.setMemberId(rs.getString("memberId"));
		m.setCreatedate(rs.getString("createdate"));
		m.setUpdatedate(rs.getString("updatedate"));
		
		
	}
	
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


<!-- !!!!!!!!!!!!!! 뷰 계층 -->	

	<!-- 모델을 출력 -->
	<!-- 회원정보를 출력 -->
	<div class="container px-4 px-lg-5 text-center">
	<% //msg 표시
		if (request.getParameter("msg") != null){
	%>
			<div style="color: red">
				<%=request.getParameter("msg") %>
			</div>		
	<%		
			
		}
		
	
	%>
	</div>

	

	<div class="container px-4 px-lg-5 text-center">
		<h3>비밀번호 수정</h3>
			<form action="<%=request.getContextPath()%>/member/informMemberAction.jsp" method="post">
			<table class="table table-hover">	
				<tr>
					<td>ID</td>
					<td>
						<input type="hidden" name="memberId" value="<%=m.getMemberId()%>">
						<%=m.getMemberId()%>
					</td>
				</tr>
				<tr>
					<td>기존 비밀번호</td>
					<td>
						<input type = "password" name = "memberPw">
					</td>
				</tr>
				<tr>
					<td>새 비밀번호</td>
					<td>
						<input type = "password" name = "newPw1">
					</td>
				</tr>
				<tr>
					<td>새 비밀번호</td>
					<td>
						<input type = "password" name = "newPw2">
					</td>
				</tr>
				<tr>
					<td>createdate</td>
					<td><%=m.getCreatedate()%></td>
				</tr>
				<tr>
					<td>updatedate</td>
					<td><%=m.getUpdatedate()%></td>
				</tr>
					<td colspan="2" align="center">
					<button type="submit" class="btn btn-success">정보 수정</button>
					</td>
				</tr>
				
			</table>
				
			</form>
	</div>
		<div class="container px-4 px-lg-5 text-center">
			<button type="submit" class="btn btn-warning">
				<a href="deleteMemberForm.jsp" style="color: white ">회원탈퇴</a>
			</button>
		</div>
		&nbsp;
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map, ArrayList...-->
<%@ page import="java.net.URLEncoder" %>
<%@ page import = "vo.*" %> 

<%
	
	// 로그인 사용자만 카테고리 수정 삭제 할 수 있음
	// 하지만 리스트 페이지 열람은 비 로그인 상태에서도 가능
	//인코딩 설정
	request.setCharacterEncoding("utf-8");

	// 유효성 검사
	if(session.getAttribute("loginMemberId") ==null){ //세션 로그인 값이 없다면
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}


	//db 불러오기
	//select 를 사용해 local 데이터를 출력한다
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
	sql = "SELECT local_name localName, createdate, updatedate FROM local";
	Stmt = conn.prepareStatement(sql);
	rs = Stmt.executeQuery();
	
	// 결과셋을 어레이리스트로
	//VO/Local클래스로 어레이리스트 만들기 ->  게시판 모양
	ArrayList<Local> localList = new ArrayList<Local>();	//사이즈가 0인 ArrayList 선언
	
	//resultSet을 AllayList로 바꿔준다
	//vo에서 getter setter 자동변환해두기
	while(rs.next()){
		Local c = new Local();
		c.setLocalName(rs.getString("localName"));
		c.setCreatedate(rs.getString("createdate"));
		c.setUpdatedate(rs.getString("updatedate"));
		localList.add(c);
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
		text-decoration:none;
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

<!--!!!!!!!!!!!!!!!!!!!!!!!!! 뷰 !!!!!!!!!!!!!!!!!!!!!!!!!-->
	<!--  msg -->
	<div  class="container px-4 px-lg-5 text-center">
	<%
		if(request.getParameter("msg") != null){
	%>		
			<div>
				<%=request.getParameter("msg") %>
			</div>	
	<%		
		}
	%>
	</div>
<!--!!!!!!!!!!!!!!!!!!!!!!!!! 지역 추가 !!!!!!!!!!!!!!!!!!!!!!!!!-->
	<div  class="container px-4 px-lg-5 text-center">
	<table class=" table table-hover">
		<tr>
			<td class="text-center">
				<button type="submit" class="btn btn-secondary">
				<a href="<%=request.getContextPath()%>/local/insertLocallistForm.jsp" style="color: white"> 지역 추가</a>		
				</button>
							
			</td>
		</tr>
	
	</table>
	</div>
<!--!!!!!!!!!!!!!!!!!!!!!!!!! 보여지는 테이블 !!!!!!!!!!!!!!!!!!!!!!!!!-->
	<div class="container px-4 px-lg-5 text-center">
		<table class=" table table-hover">
			<tr>
				<th class="text-center">localName</th>
				<th class="text-center">createdate</th>
				<th class="text-center">updatedate</th>
				<th colspan="2"></th>
			</tr>
<!--!!!!!!!!!!!!!!!!!!!!!!!!!  입력/ 수정/ 삭제 !!!!!!!!!!!!!!!!!!!!!!!!!-->
			<% 
			for(Local c : localList){ 
			%>
				<tr>
					<td><%=c.getLocalName()%></td>
					<td><%=c.getCreatedate()%></td>
					<td><%=c.getUpdatedate()%></td>
					<td>
						<form action="<%=request.getContextPath()%>/local/updateLocalForm.jsp">
							<input type="hidden" name="localName" value="<%=c.getLocalName()%>">
							<button type="submit" class="btn btn-secondary">수정</button>
						</form>
					</td>
					<td>
						<form action="<%=request.getContextPath()%>/local/deleteLocalForm.jsp">
							<input type="hidden" name="localName" value="<%=c.getLocalName()%>">
							<button type="submit" class="btn btn-secondary">삭제</button>
						</form>
					</td>
				</tr>
			<%
			} 
			%>
			
	
		</table>
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
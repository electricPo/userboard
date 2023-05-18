<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map -->
<%@ page import = "vo.*" %> 


	<%
 	//!!!!!!!!!디버깅 창의 폰트 색상 바꾸기
 			final String RESET = "\u001B[0m";  //바꿀수 없는 변수 / 대문자로 설정함
 			final String RED = "\u001B[31m";
 			//stmt 디버깅 때 사용	
 		
 	//!!!!!!!!!!요청분석(컨트롤러 계층) / 요청값에 대한 유효성 검사
 			//1) session JSP내장객체(기본 객체, 빌트인 객체) -> 리퀘스트, 리스폰스, 어플리케이션, 페이지컨텍스트
 			
 			//인코딩 설정
 			request.setCharacterEncoding("utf-8");
 			
 			//2) request/response 
 			int currentPage = 1;
 			int rowPerPage = 10;//페이지 가져오기(필수)
 			int startRow = 10;
 			String localName = "전체"; //초기값을 전체로 설정
 			if(request.getParameter("localName") != null){
 			localName = request.getParameter("localName"); //그렇지 않은 경우 localName을 불러온다
 			}
 			
 	//!!!!!!!!!!모델계층
 			
 			
 			
 			//db 불러오기
 			String driver = "org.mariadb.jdbc.Driver";
 			String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
 			String dbuser = "root";
 			String dbpw = "java1234";
 			Class.forName(driver);
 			Connection conn = null;
 			
 			//1)서브메뉴 결과셋
 			PreparedStatement submenustmt = null;
 			ResultSet submenurs = null;
 			conn = DriverManager.getConnection(dburl, dbuser, dbpw);
 		
 			/*
 			 SELECT '전체' localName, COUNT(local_name) cnt FROM board
 			 UNION ALL 
 			 SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name;
 			*/
 			
 			//전체 지역 카테고리와 갯수에 대한 쿼리
 			
 			String submenusql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name;";
 		//local_name 이라는 중복된 이름 중 대표값을 정하고(group by) 그 값마다 총 개수(cnt)를 출력함
 			submenustmt = conn.prepareStatement(submenusql);
 			submenurs= submenustmt.executeQuery();
 		//ArrayList-HashMap
 		//ArrayList 안에 HashMap<String, Object>(기존: VO)이 들어가는게 복잡함
 			ArrayList<HashMap<String, Object>> submenuList = new ArrayList<HashMap<String, Object>> ();
 			while(submenurs.next()){
		 		HashMap<String, Object> m = new HashMap<String, Object>();
		 		m.put("localName", submenurs.getString("localName"));
		 		m.put("cnt", submenurs.getInt("cnt"));
		 		submenuList.add(m);

 		
 			}
 			//디버깅
 			System.out.println(submenuList + "<-home / submenuList");
 			
 			//2)게시판 목록 결과셋
 			//카테고리를 누르면 출력되는 게시판 sql 만들기
 			

 			
 			PreparedStatement stmt2 = null;
 			ResultSet rs2 =null;
 			

 			/*
 		SELECT '전체' localName, board_title FROM board
 	 			UNION ALL 
 	 			SELECT local_name, board_title FROM board GROUP BY board_title;	
 			
 			*/
 			
 			/*
 		SELECT
 			board_no boardNo,
 			local_name localName,
 			board_title boardTitle,
 			createdate
 		FROM board
 		WHERE local_name=?
 		ORDER BY createdate DESC
 		LIMIT ?,?;
 			
 			*/
 			String sql2 = ""; // 스트링 타입은 null보다는 공백으로 초기화를
 			
 			sql2 = "SELECT board_no boardNo, local_name localName, board_title boardTitle, createdate FROM board WHERE local_name=? ORDER BY createdate DESC LIMIT ?,?" ;
 			stmt2 = conn.prepareStatement(sql2);
 			
 		//전체 값과 나머지 local_name을 분기
 		if(localName.equals("전체")){
 			sql2 = "SELECT board_no boardNo, local_name localName, board_title boardTitle ,createdate FROM board ORDER BY createdate DESC LIMIT ?,?";
 			stmt2 = conn.prepareStatement(sql2);
 			stmt2.setInt(1, startRow);
 			stmt2.setInt(2, rowPerPage);
 			rs2= stmt2.executeQuery();
 			System.out.println(RED+stmt2 + "<-home / stmt2"+RESET);
 			} else{
 				sql2 = "SELECT board_no boardNo, local_name localName, board_title boardTitle ,createdate FROM board WHERE local_name=? LIMIT 0,10"; 
 				stmt2 = conn.prepareStatement(sql2);
 				stmt2.setString(1,localName);
 				stmt2.setInt(2,startRow);
 				stmt2.setInt(3,rowPerPage);
 				rs2= stmt2.executeQuery(); //db쿼리 결과셋 모델
 				System.out.println(RED+stmt2 + "<-home / stmt2"+RESET);
 			}
 		
 		
 		//VO/board클래스로 어레이리스트 만들기 -> 게시판
 		ArrayList<Board> List2 = new ArrayList<Board> (); //애플리케이션에서 사용할 모델 (사이즈 0)
 		//rs2를 boardList로
 		while(rs2.next()){
 			Board m = new Board(); //while문 밖으로 나가면 같은 값이 10번 반복된다
 			m.setBoardNo(rs2.getInt("boardNo"));
 			m.setLocalName(rs2.getString("localName"));
 			m.setBoardTitle(rs2.getString("boardTitle"));
 			m.setCreatedate(rs2.getString("createdate"));
 			
 			List2.add(m);
 			
 		}
 		
 		//디버깅
 		System.out.println(List2 + "<-home / List2");
 		System.out.println(List2.size() + "<-home / List2.size()"); //10
 		System.out.println(RED+stmt2 + "<-home / stmt2"+RESET);
 		System.out.println(List2 + "<-home / List2");
 		
 		
 
 		
 		
 
 	
 		
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


	
<!-- !!!!!!!!!!!!!! 뷰 계층 -->	

	<!-- 서브메뉴(세로)submenuList 모델을 출력 -->
	<div>
	<table class="container">
		<tr>
			<td>
				<h2 class="page-section-heading text-center text-uppercase text-secondary mb-0">location</h2>
					<!--참고 https://nowonbun.tistory.com/646 -->
				    <div style="margin:10px;" class="text-center">
				      <!-- Javascript가 필요없이 data-toggle에 collapse href에 대상 id을 설정합니다. -->
				      <button data-toggle="collapse" href="#collapseExample" aria-expanded="false" aria-controls="collapseExample" class="btn btn-secondary">지역 리스트</button>
				    </div>
				    <div class="collapse" id="collapseExample">
			     	 <div class="well">
							<ul class="center">
						
								<%
									for(HashMap<String, Object> m  : submenuList){
									%>		
										<li>
											<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>"> <!-- 전체/ null를 넘길 땐 where절 생략-->
											<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
											
											</a>	
										</li>
										
								<%
								}
								%>
							
							</ul>
							<form action="<%=request.getContextPath()%>/local/localistForm.jsp" method="post">
									
								<button type="submit" class="btn btn-secondary"> 지역 더보기</button>
							</form>
								
				    </div>
				  </div>
					
				
			</td>
			
			<td>
				<h2 class="page-section-heading text-center text-uppercase text-secondary mb-0">login</h2>
					<div style="margin:10px;" class="text-center">
					<!-- home 내용 : 로그인 폼(null일 때) / 카테고리별 게시글 5개씩 -->
					<!-- 로그인 폼 -->
					<%
					if(session.getAttribute("loginMemberId") == null){ //로그인 전이면 로그인 폼 출력
					%>
							<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post"> <!-- web프로젝트 기반 주소로 쓰기 
																										//ContextPath : 전체 프로젝트의 경로 
																										//이름, 위치 변경해도 메소드를 사용해 불러올 수 있다-->
							<table class=" table table-hover">
								<tr>
									<td>ID</td>
									<td><input type="text" name="memberId"></td>
								</tr>
								<tr>
									<td>PW</td>
									<td><input type="password" name="memberPw"></td>
								</tr>
							</table>
							<button type="submit" class="btn btn-secondary">로그인</button>
							</form>
					<%
					}
					%>	
				
			
					</div>
			</td>
		</tr>
	</table>
	</div>
<!-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!<시작> list2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-->
	<!-- 로그인 안 해도 전체 글 열람 가능 -->	
	<!-- 게시판 눌렀을 때 게시글 제목 보이게 -->
	
	<div class="container px-4 px-lg-5 text-center">
	<table class=" table table-hover">
		

					<tr>
						<th>
						지역명
						</th>
						<th>
						제목
						</th>
						<th>
						생성일
						</th>
					</tr>
			
		<%
					for(Board m  : List2){
					%>	
					<tr>
						<td>
						<%=m.getLocalName() %>
						</td>
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=m.getBoardNo()%>">
								<%=m.getBoardTitle() %>
							</a> <!-- 타이틀 클릭했을 때 /board/boardOne.jsp?boardNo= 댓글입력폼과 (댓글입력리스트), 페이징까지 -->
						</td>
						<td>
						<%=m.getCreatedate().substring(0, 10) %>
						</td>
					</tr>  
					
				
		<%		
			}
		
		%>
	
	</table>
	
	</div>
<!-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!<끝> list2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-->	
	
	
	
	
	
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
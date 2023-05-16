<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>




<div  class="collapse navbar-collapse justify-content-end"   id="navbarResponsive" >

	<ul class="navbar-nav ms-auto">
		<li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="<%= request.getContextPath()%>/home.jsp">&nbsp;홈으로&nbsp;</a></li>
		
		<!-- 로그인 전: 회원가입 -->
		<!-- 로그인 후: 회원정보(마이페이지, 회원탈퇴...) / 로그아웃 (로그인 정보는 세션에 loginMemberId -->
		
		<%
			if(session.getAttribute("loginMemberId") == null){ //로그인 전
		%>
				<li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="<%= request.getContextPath()%>/member/insertMemberForm.jsp">&nbsp;회원가입&nbsp;</a></li> 
		<%
			}	else {
		%>
				<li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="<%= request.getContextPath()%>/member/informMember.jsp">&nbsp;회원정보&nbsp;</a></li>
				<li class="nav-item mx-0 mx-lg-1"><a class="nav-link py-3 px-0 px-lg-3 rounded" href="<%= request.getContextPath()%>/member/logoutAction.jsp">&nbsp;로그아웃&nbsp;</a></li>
		<%
			}
		%>	
		
			
		
	
		
	</ul>

</div>
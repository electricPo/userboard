<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %> <!-- Hash Map -->



<%
		String driver = "org.mariadb.jdbc.Driver";
		String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
		String dbuser = "root";
		String dbpw = "java1234";
		Class.forName(driver);
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		
		
		//쿼리문
		/*
		SELECT local_name localName, '대한민국' country ,'김미선' worker 
		FROM LOCAL LIMIT 0, 1;
		*/
		
		String sql = "SELECT local_name localName, '대한민국' country ,'김미선' worker FROM LOCAL LIMIT 0, 1;";
		stmt = conn.prepareStatement(sql);
		rs= stmt.executeQuery();
		
		//VO대신 HashMap(Map의 한 종류)타입을 사용
			//(키, 값-Object(최상위 루트타입)라고 적으면 모든 값이 들어올 수 있다-) 여러 타입 넣을 수 있음 / cf. 어레이리스트는 한 타입
			
			/*어레이리스트의 구조 예
				ArrayList<Emp> empList = new ArrayList<Emp>();
				while(rs.next()){
					Emp e = new Emp();
					e.empNo = rs.getInt("emp_no");
					empList.add(e);
			*/
			
		HashMap<String, Object> map = null; 
		if(rs.next()){
			//디버깅
			//System.out.println(rs.getString("localName"));
			//System.out.println(rs.getString("country"));
			//System.out.println(rs.getString("worker"));
			
			map = new HashMap<String, Object>();
			map.put("localName", rs.getString("localName"));
			map.put("country", rs.getString("country"));
			map.put("worker", rs.getString("worker"));
		}
		
			System.out.println((String)map.get("localName"));
			System.out.println((String)map.get("country"));
			System.out.println((String)map.get("worker"));

			
			//Hagh Map 여러개일 때
				//ArrayList-HashMap
			PreparedStatement stmt2 = null;
			ResultSet rs2 =null;
			String sql2 = "SELECT local_name localName, '대한민국' country ,'김미선' worker FROM LOCAL;"; //sql에서 불러온 데이터와 관련없는 데이터를 따로 만듦
			stmt2 = conn.prepareStatement(sql2);
			rs2= stmt2.executeQuery();
			
			ArrayList<HashMap<String, Object>> list2 = new ArrayList<HashMap<String, Object>>(); //이때 size=0
				//-> ArrayList 안에 HashMap<String, Object>(기존: VO)이 들어가는게 복잡함
			while(rs2.next()){
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("localName", rs2.getString("localName"));
				m.put("country", rs2.getString("country"));
				m.put("worker", rs2.getString("worker"));
				list2.add(m);
				
			}


				//ArrayList-HashMap
			PreparedStatement stmt3 = null;
			ResultSet rs3 =null;
			String sql3 = "SELECT local_name localName, COUNT(board_no) cnt FROM board GROUP BY local_name;"; //sql 집계함수 중 GROUP BY
				//local_name 이라는 중복된 이름 중 대표값을 정하고(group by) 그 값마다 총 개수(cnt)를 출력함
			stmt3 = conn.prepareStatement(sql3);
			rs3= stmt3.executeQuery();
			
			ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>(); //이때 size=0
			while(rs3.next()){
				HashMap<String, Object> m = new HashMap<String, Object>();
				m.put("localName", rs3.getString("localName"));
				m.put("cnt", rs3.getInt("cnt"));
				list3.add(m);
				
			}




%>




<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>localListByMap.jsp</title>
</head>
<body>
	<table>
		<tr>
			<td>localName</td>
			<td>country</td>
			<td>worker</td>
		</tr>
		<%
			for(HashMap<String, Object> m : list2){
		
		%>
				<tr>
					<td><%=m.get("localName")%></td>
					<td><%=m.get("country")%></td>
					<td><%=m.get("worker")%></td>
					
				</tr>
		
		<%
			}
		
		%>
	</table>
	
	<hr>
	
	<ul>
		<li>
			<a href="">전체</a>
		</li>
		<%
			for(HashMap<String, Object> m  : list3){
		%>		
				<li>
					<a href="">
					<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>))
					<!-- 에러: class java.lang.String cannot be cast to class java.lang.Integer -> 해결: "cnt"불러올 때 getString으로 불러와서 수정 -->
					</a>	
				</li>
		<%		
			}
		
		
		
		%>
	
	</ul>
</body>
</html>
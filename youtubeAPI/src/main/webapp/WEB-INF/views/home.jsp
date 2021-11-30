<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<title>Home</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
</head>
<body>
	<button onclick="location.href='${pageContext.request.contextPath}/login/signin'">Sign In</button>
	<button onclick="location.href='${pageContext.request.contextPath}/test/dashboard'">Teacher</button>
	<button onclick="location.href='${pageContext.request.contextPath}/student/class/test/dashboard/1'">Student1</button>
	<button onclick="location.href='${pageContext.request.contextPath}/student/class/test/dashboard/2'">Student2</button>
	<button onclick="location.href='${pageContext.request.contextPath}/attendCSV'">CSV파싱 구현</button>
	<!-- 나중에는 학생이 join한 class들을 먼저 보여주고, 거기서 선택해서 들어갈 수 있도록하기
	지금은 그냥 임의로 ClassID가 1인 수업으로 들어가고있음! -->
	<button onclick="location.href='${pageContext.request.contextPath}/entryCode'">초대링크 구현</button>

</body>
</html>
<%--잘못된 호출일 때 알려주는 화면 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>안내</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="page-main">
	<jsp:include page="/WEB-INF/views/common/header.jsp"/>
	
	<%--내용 시작 --%>
		<div class="content-main">
			<h2>안내</h2>
			<div class="result-display">
				<div class="align-center" style = "font-size: 30px;">
					<c:if test="${!empty accessMsg}">
						${accessMsg}
					</c:if>
					
					<c:if test="${empty accessMsg}">
						잘못된 접속입니다
					</c:if>
					<p>
					<c:if test="${!empty accessUrl}">
						<input type="button" value="이동" onclick="location.href='${accessUrl}'">					
					</c:if>
					
					<c:if test="${empty accessUrl }">
						<input type="button" value="이동" 
								   onclick="location.href='${pageContext.request.contextPath}/main/main.do'">
					</c:if>
					
					
				</div>
			
			</div>
		</div>
	
	<%--내용 끝 --%>
</div>
</body>
</html>
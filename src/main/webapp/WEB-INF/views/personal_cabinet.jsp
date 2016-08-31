<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page session="true"%>
<html>
<head>
<spring:url value="/resources/css/main.css" var="mainCss" />
<spring:url value="/create_poll" var="create_poll" />

<link href="${mainCss}" rel="stylesheet" />

</head>
<body>
	<%@ include file="top_menu.jsp"%>
	<div class="content">
		<h2>
			Welcome to personal cabinet: <span
				style="font-size: 150%; color: #00334d">${pageContext.request.userPrincipal.name}</span><br />
			<a href="${create_poll}" style="text-align: center;"><button>Create
					new Poll</button></a>
		</h2>
		<table class="table_main">
			<tr>
				<th>User questions</th>
				<th>Picked questions</th>
			</tr>
			<tr>
				<td><c:forEach var="question" items="${userQuestions}"
						varStatus="status">
						<%@ include file="text_card_poll_element.jsp"%>
					</c:forEach></td>
				<td><c:forEach var="question" items="${pickedQuestions}"
						varStatus="status">
						<%@ include file="text_card_poll_element.jsp"%>
					</c:forEach></td>
			</tr>
		</table>
	</div>
</body>
</html>
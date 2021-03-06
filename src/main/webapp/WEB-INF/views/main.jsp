<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page session="true"%>
<html>
<head>
<spring:url value="/resources/css/main.css" var="mainCss" />

<link href="${mainCss}" rel="stylesheet" />

</head>
<body>
	<%@ include file="top_menu.jsp"%>
	<div class="content">
		<table class="table_main">
			<tr>
				<th>Popular</th>
				<th>Newest</th>
			</tr>
			<tr>
				<td><c:forEach var="question" items="${popularQuestions}"
						varStatus="status">
						<%@ include file="text_card_poll_element.jsp"%>
					</c:forEach></td>
				<td><c:forEach var="question" items="${newestQuestions}"
						varStatus="status">
						<%@ include file="text_card_poll_element.jsp"%>
					</c:forEach></td>
			</tr>
		</table>
	</div>
</body>
</html>
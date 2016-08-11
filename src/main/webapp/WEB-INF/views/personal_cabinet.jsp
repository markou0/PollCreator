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
		<h2>Welcome to personal cabinet: <span style="font-size:150%;color: #00334d">${pageContext.request.userPrincipal.name}</span><h2>
		<a href="${create_poll}"><button>Create new Poll</button></a>
		<table class="table_main">
			<tr>
				<th>User questions</th>
				<th>Picked questions</th>
			</tr>
			<tr>
				<td><c:forEach var="question" items="${userQuestions}"
						varStatus="status">
						<a href="<c:out value="poll/${question.id}"/>">
						<div class="text_card poll_element">
							<div class="question_metadata">
								<p>
									<c:if test="${not empty question.userName}">
										<c:out value="${question.userName}" />
									</c:if>
									<c:if test="${empty question.userName}">
										anonim
									</c:if>
								</p>
								voted:
								<c:out value="${question.totalVotes}" />
								<p>
									<c:out value="${question.created}" />
								</p>
							</div>
							<c:if test="${not empty question.image}">
								<div class="img_container">
									<img src="<c:out value="${question.image}" />" />
								</div>
							</c:if>
							<div class="question">
								<c:out value="${question.question}" />
							</div>
						</div>
						</a>
					</c:forEach></td>
								<td><c:forEach var="question" items="${pickedQuestions}"
						varStatus="status">
						<a href="<c:out value="poll/${question.id}"/>">
						<div class="text_card poll_element">
							<div class="question_metadata">
								<p>
									<c:if test="${not empty question.userName}">
										<c:out value="${question.userName}" />
									</c:if>
									<c:if test="${empty question.userName}">
										anonim
									</c:if>
								</p>
								voted:
								<c:out value="${question.totalVotes}" />
								<p>
									<c:out value="${question.created}" />
								</p>
							</div>
							<c:if test="${not empty question.image}">
								<div class="img_container">
									<img src="<c:out value="${question.image}" />" />
								</div>
							</c:if>
							<div class="question">
								<c:out value="${question.question}" />
							</div>
						</div>
						</a>
					</c:forEach></td>
			</tr>
		</table>
	</div>
</body>
</html>
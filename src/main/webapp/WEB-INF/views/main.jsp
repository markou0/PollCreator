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
								<td><c:forEach var="question" items="${newestQuestions}"
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
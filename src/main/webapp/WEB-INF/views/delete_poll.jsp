<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page session="true"%>
<html>
<head>
<spring:url value="/resources/css/main.css" var="mainCss" />
<spring:url value="/resources/css/poll.css" var="PollCss" />
<spring:url value="/resources/css/popup.css" var="PopUpCss" />

<link href="${mainCss}" rel="stylesheet" />
<link href="${PollCss}" rel="stylesheet" />
<link href="${PopUpCss}" rel="stylesheet" />

<script src="http://code.jquery.com/jquery-2.0.2.min.js"></script>
<script>
	$(document).ready(function() {
		//Скрыть PopUp при загрузке страницы    
		PopUpHide();
	});
	//Функция отображения PopUp
	function PopUpShow() {
		$("#popup1").show();
	}
	//Функция скрытия PopUp
	function PopUpHide() {
		$("#popup1").hide();
	}
</script>
</head>
<body>
	<%@ include file="top_menu.jsp"%>
	<div class="content">
		<c:choose>
			<c:when test="${not empty isDeleted}">
				<h1>Poll deleted successfully!</h1>
			</c:when>
			<c:when test="${empty question}">
				<h1>Non-existent Poll!</h1>
			</c:when>
			<c:otherwise>
				<form:form action="poll/${question.id}/delete" method="post"
					modelAttribute="question" id="poll_from">
					<div class="question">${question.question}</div>
					<c:forEach var="answer" items="${question.answers}"
						varStatus="status">
						<div class=answer>
							<c:out value="${answer.answer}" />
							<br>
						</div>
					</c:forEach>
					<input type="button" value="Delete poll" onclick="PopUpShow()">
					<input type="button" value="Take poll" onclick="location.href='poll/${question.id}?forAdmin=true';">
					<input type="button" value="Poll results" onclick="location.href='poll/${question.id}/results';">
					<div class="b-popup" id="popup1">
						<div class="b-popup-content">
							<h2>Are you sure want delete this poll? </h2><input type="submit"
								id="submit" value="Delete" onclick="PopUpHide()" /> <input
								type="reset" value="Cancel" onclick="PopUpHide()" style="float: right"/>
						</div>
					</div>

				</form:form>
			</c:otherwise>
		</c:choose>
	</div>
</body>
</html>
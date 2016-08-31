<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@page session="true"%>
<html>
<head>
<spring:url value="/resources/css/main.css" var="mainCss" />
<spring:url value="/resources/css/popup.css" var="PopUpCss" />
<spring:url value="/resources/css/user_polls.css" var="UserPollsCss" />
<spring:url value="user/${username}/delete" var="delete_user" />


<link href="${mainCss}" rel="stylesheet" />
<link href="${PopUpCss}" rel="stylesheet" />
<link href="${UserPollsCss}" rel="stylesheet" />

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
			<c:when test="${isDeleted}">
				<h1>User successfully deleted!</h1>
			</c:when>
			<c:when test="${!isUserExists}">
				<h1>Non-existent User!</h1>
			</c:when>
			<c:otherwise>
				<h2>
					Polls of user: <span style="font-size: 150%; color: #00334d">${username}</span>
				</h2>
				<br />
				<sec:authorize access="hasRole('ROLE_ADMIN')">
					<form:form id="deleteUserForm" action="${delete_user}"
						method="post">
						<input type="button" id="deleteUserButton" value="Delete User"
							onclick="PopUpShow()" />
						<div class="b-popup" id="popup1">
							<div class="b-popup-content">
								<h2>Are you sure to delete this user and all his polls?</h2>
								<input type="submit" id="submit" value="Delete"
									onclick="PopUpHide()" /> <input type="reset" value="Cancel"
									onclick="PopUpHide()" style="float: right" />
							</div>
						</div>
					</form:form>
				</sec:authorize>
				<c:forEach var="question" items="${userQuestions}"
					varStatus="status">

					<c:choose>
						<c:when test="${!question.isAnonimius}"><%@ include
								file="text_card_poll_element.jsp"%></c:when>
						<c:otherwise>
							<sec:authorize access="hasRole('ROLE_ADMIN')"><%@ include
									file="text_card_poll_element.jsp"%></sec:authorize>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
</body>
</html>
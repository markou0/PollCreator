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

<link href="${mainCss}" rel="stylesheet" />
<link href="${PollCss}" rel="stylesheet" />

<!-- <script type='text/javascript'>
	var executed = false;
	function otherAnswer() {
		if (!executed) {
			var container = document.getElementById("other");
			var input = document.createElement("input");
			input.type = "text";
			input.id = "other_answer";
			input.className = "answer";
			input.placeholder = "Type your alternative answer here";
			container.appendChild(input);
			container.appendChild(document.createElement("br"));
			executed = true;
		}
	}
</script> -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script>
	$(document).ready(function() {
		$("input[name=idAnswer]:radio").change(function() {
			$('input[type="submit"]').prop('disabled', false);
			validOtherChoise();
		})
	});

	function validOtherChoise() {
		var value = document.querySelector('input[name="idAnswer"]:checked').value;
		if (value == -1) {
			$('#other_text').show();
			if ($('#other_text').val() == '')
				$('input[type="submit"]').prop('disabled', true);
			else
				$('input[type="submit"]').prop('disabled', false);
		} else {
			$('#other_text').hide();
			$('input[type="submit"]').prop('disabled', false);
		}
	}
</script>
</head>
<body>
	<%@ include file="top_menu.jsp"%>
	<div class="content">
		<c:choose>
			<c:when test="${empty question}">
				<h1>Non-existent Poll!</h1>
			</c:when>
			<c:when test="${pageContext.request.userPrincipal.name == null}">
				<h1>
					<a href='<c:url value ="/login"></c:url>'>Login to take poll!</a>
				</h1>
			</c:when>
			<c:when test="${voteDenied}">
				<h1>
					Your voice can`t be accepted</br>You have already took this poll! <a
						href='<c:url value ="/poll/${pollId}/poll_results"></c:url>'>See
						results of poll</a>
				</h1>
			</c:when>
			<c:otherwise>
				<form:form action="poll/${question.id}/submit_poll" method="post"
					modelAttribute="answer" id="poll_from">
					<div class="question">${question.question}</div>
					<c:forEach var="answer" items="${question.answers}"
						varStatus="status">
						<div class=answer>
							<form:radiobutton path="idAnswer" value="${answer.idAnswer}" />
							<c:out value="${answer.answer}" />
							<br>
						</div>
					</c:forEach>
					<div id="other" class=answer>
						<form:radiobutton id="other_radio" path="idAnswer" value="-1" />
						Other <br>
					</div>
					<form:input type="text" cssClass="answer" path="answer"
						id="other_text" placeholder="Type your alternative answer here"
						onblur="validOtherChoise()" hidden="true" />
					<input type="submit" id="submit" value="vote" disabled="disabled" />
				</form:form>
			</c:otherwise>
		</c:choose>
	</div>
</body>
</html>
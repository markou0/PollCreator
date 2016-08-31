<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="text_card poll_element">
	<div class="question_metadata">
		<p>
			<a href="user/${question.userName}">${question.userName}</a>
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
	<input type="button" value="Take poll"
		onclick="location.href='poll/${question.id}';" />
</div>
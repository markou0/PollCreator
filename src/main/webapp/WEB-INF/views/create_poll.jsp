<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page session="true"%>
<html>
<head>
<spring:url value="/resources/css/main.css" var="mainCss" />
<spring:url value="/resources/css/create_poll.css" var="CreatePollCss" />

<link href="${mainCss}" rel="stylesheet" />
<link href="${CreatePollCss}" rel="stylesheet" />

<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js">
	
</script>
<script>
	var countAnswers = 2;

	function addAnswer() {
		countAnswers++;
		var container = document.getElementById("answers");
		var input = document.createElement("div");
		input.className = "answer_container";
		input.id = "answer_container_" + (countAnswers);
		container.appendChild(input);
		container = document.getElementById("answer_container_" + countAnswers);
		input = document.createElement("input");
		input.type = "text";
		input.id = "answer" + (countAnswers);
		input.name = "answer_" + (countAnswers);
		input.className = "answer";
		input.placeholder = "Type answer here";
		container.appendChild(input);
		
		/* input = document.createElement("input");
		input.type = "file";
		input.id = "answer_img_upload_" + (countAnswers);
 		$("#answer_container_" + countAnswers)
				.append(
						"<label for=\"answer_img_upload_"+countAnswers+"\"><img src=\"images\\image.svg\" height=\"30px\"/></label>"); 
		container.appendChild(input); */
	}

	function deleteAnswer() {
		var container = document.getElementById("answers");
		if (countAnswers > 2) {
			container.removeChild(document.getElementById('answer_container_'
					+ countAnswers));
			countAnswers--;
		}
	}

	$(document).ready(function() {

		$('form[id="pollForm"] input[type="text"]').blur(function() {
			if ($(this).val() == '') {
				disableSubmit();
				$(this).addClass('error');
				$(this).attr('title', 'This field may not be empty!');
			} else {
				enableSubmit();
				$(this).removeClass('error');
				$(this).attr('title', null);
			}
		})
	});

	function disableSubmit() {
		document.getElementById("submit").setAttribute("disabled", true);
	}

	function enableSubmit() {
		document.getElementById("submit").disabled=false;
	}

	function validateForm() {
		var error = '';
		if ($('#question_text').val() == '') {
			$('#question_text').addClass("error");
			error = "Question may not be empty!";
		} else
			$('#question_text').removeClass("error");

		for (i = 1; i <= countAnswers; i++) {
			if ($('#answer' + i).val() == '') {
				$('#answer' + i).addClass("error");
				error = "Answers may not be empty!";
			} else
				$('#answer' + i).removeClass("error");
		}

		if (error == '') {
			enableSubmit();
		} else
			disableSubmit();
	}
</script>
</head>
<body>
<%@ include file="top_menu.jsp" %>
<div class="content">
	<div class="form_box">
		<form:form action="create_poll" method="post"
			modelAttribute="question" onsubmit="return validateForm()"
			name="pollForm" id="pollForm">
			<h1>Create poll/vote</h1>
			<fieldset>
				<form:checkbox path="isPublic" label="Public vote" />
				<form:checkbox path="isAnonimius" label="Hide Author" />
				<form:input type="text" path="question" cssClass="question"
					id="question_text" placeholder="Type your question here"
					onblur="validTextInputs(this)" />
				<form:errors path="question" cssClass="error" />
				<%-- <label for="question_img_upload"> <img
				src="images\image.svg" height="30px" />
			</label> <form:input path="avatar" type="file" id="question_img_upload"/> --%>
				<section id="answers">
					<div id="answer_container_1" class="answer_container">
						<input type="text" min="1" class="answer" id="answer1"
							name="answer_1" placeholder="Type answer here"
							onblur="validTextInputs(this)" />
						<!-- <label
						for="answer_img_upload_1"> <img src="images\image.svg" />
					</label> <input type="file" id="answer_img_upload_1"> -->
					</div>
					<div id="answer_container_2" class="answer_container">
						<input type="text" class="answer" id="answer2" name="answer_2"
							placeholder="Type answer here" />
						<!-- <label
						for="answer_img_upload_1"> <img src="images\image.svg" />
					</label> <input type="file" id="answer_img_upload_1"> -->
					</div>
				</section>
				<button type="button" class="answer" name="add_answer"
					onclick="addAnswer()">Add answer</button>
				<button type="button" class="answer" name="delete_answer"
					onclick="deleteAnswer()">Delete answer</button>
			</fieldset>
			<input type="submit" id="submit" value="Submit"
				onclick="validateForm()" />
			<input type="reset" value="Reset" />
		</form:form>
	</div>
	</div>
</body>
</html>
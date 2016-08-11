<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@page session="true"%>
<html>
<head>
<spring:url value="/resources/css/main.css" var="mainCss" />
<spring:url value="/resources/css/registration.css"
	var="registrationCss" />

<link href="${mainCss}" rel="stylesheet" />
<link href="${registrationCss}" rel="stylesheet" />

<title>Registration Page</title>
</head>
<body onload='document.registrationForm.username.focus();'>
	<%@ include file="top_menu.jsp"%>
	<div class="form_box_container">
		<div id="registration-box" class="form_box">

			<c:if test="${not empty error}">
				<div class="error">${error}</div>
			</c:if>
			<c:if test="${not empty msg}">
				<div class="msg">${msg}</div>
			</c:if>

			<form:form name='registrationForm'
				action="submit_registration" method='POST'
				modelAttribute="user">

				<table>
					<tr>
						<td>Username:</td>
						<td><form:input type="text" path="username" /> <form:errors
								path="username" cssClass="error" /></td>
					</tr>
					<tr>
						<td>Password:</td>
						<td><form:input type="password" path="password" /> <form:errors
								path="password" cssClass="error" /></td>
					</tr>
					<tr>
						<td>Confirm Password:</td>
						<td><form:input type="password" path="confPassword" /> <form:errors
								path="confPassword" cssClass="error" /></td>
					</tr>
					<tr>
						<td colspan='2'><input name="submit" type="submit"
							value="Sign Up" /></td>
					</tr>
				</table>
			</form:form>
		</div>
	</div>
</body>
</html>
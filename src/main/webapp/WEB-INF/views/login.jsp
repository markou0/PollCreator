<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page session="true"%>
<html>
<head>
<spring:url value="/resources/css/main.css" var="mainCss" />
<spring:url value="/resources/css/login.css" var="loginCss" />

<link href="${mainCss}" rel="stylesheet" />
<link href="${loginCss}" rel="stylesheet" />

<title>Login Page</title>
</head>
<body onload='document.loginForm.username.focus();'>
	<%@ include file="top_menu.jsp"%>
	<div class="form_box_container">
		<div id="login-box" class="form_box">

			<c:if test="${not empty error}">
				<div class="error">${error}</div>
			</c:if>
			<c:if test="${not empty msg}">
				<div class="msg">${msg}</div>
			</c:if>
			<form name='loginForm'
				action="<c:url value='/auth/login_check?targetUrl=${targetUrl}' />"
				method='POST'>

				<table>
					<tr>
						<td>User:</td>
						<td><input type='text' name='username'
							<c:if test="${not empty username}">
						<c:out value="value=${username}"/>
						</c:if> />
						</td>
					</tr>
					<tr>
						<td>Password:</td>
						<td><input type='password' name='password' /></td>
					</tr>

					<!-- if this is login for update, ignore remember me check -->
					<c:if test="${empty loginUpdate}">
						<tr>
							<td></td>
							<td>Remember Me: <input type="checkbox" name="remember-me" /></td>
						</tr>
					</c:if>
					<tr>
						<td colspan='2'><input name="submit" type="submit"
							value="sign in" /><a href="registration"
							style="text-decoration: underline">Sign Up</a></td>
					</tr>
				</table>

				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />

			</form>
		</div>
	</div>
</body>
</html>
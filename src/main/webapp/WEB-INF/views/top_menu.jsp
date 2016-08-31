<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@page session="true"%>

<spring:url value="/resources/css/main.css" var="mainCss" />
<spring:url value="/resources/css/top_menu.css" var="topMenuCss" />
<spring:url value="/resources/images" var="images" />
<c:set var="req" value="${pageContext.request}" />
<c:set var="url">${req.requestURL}</c:set>
<c:set var="uri" value="${req.requestURI}" />
<base
	href="${fn:substring(url, 0, fn:length(url) - fn:length(uri))}${req.contextPath}/">

<c:url value="/j_spring_security_logout" var="logoutUrl" />
<c:url value="/create_poll" var="create_poll">
</c:url>
<c:url value="/" var="main">
</c:url>
<c:url value="/personal_cabinet" var="personal_cabinet">
</c:url>
<c:url value="/login" var="login">
</c:url>
<c:url value="" var="search">
</c:url>
<link href="${mainCss}" rel="stylesheet" />
<link href="${topMenuCss}" rel="stylesheet" />
<form action="${logoutUrl}" method="post" id="logoutForm">
	<input type="hidden" name="${_csrf.parameterName}"
		value="${_csrf.token}" />
</form>
<script>
	function formSubmit() {
		document.getElementById("logoutForm").submit();
	}
</script>
<div id="menu">
	<ul class="hr">
		<a href="${main}"><li><img
				src="${images}/poll_creator_logo.png" height="15em"></li></a>
		<sec:authorize access="isAuthenticated()">
			<a href="${personal_cabinet}"><li id="personal_cabinet">Personal
					Cabinet</li></a>
			<a href="javascript:formSubmit()"><li id="logout">Logout</li></a>
		</sec:authorize>
		<c:if test="${pageContext.request.userPrincipal.name == null}">
			<a href="${login}"><li id="signIn">Sign In</li></a>
		</c:if>
		<%-- <li><input type="text" name="search" id="search"
			placeholder="Search poll/vote by keywords"></li>
		<a href="${search}"><img src="${images}/search.svg"
			width='35px' height='35px'
			style="position: relative; top: 13px; right: 55px;" /></a> --%>
	</ul>
</div>
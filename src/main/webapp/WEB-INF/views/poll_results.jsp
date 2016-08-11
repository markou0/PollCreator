<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page session="true"%>
<html>
<head>
<spring:url value="/resources/css/main.css" var="mainCss" />
<spring:url value="/resources/css/poll_results.css" var="pollResultsCss" />
<spring:url value="/resources/images" var="images" />
<c:set var="req" value="${pageContext.request}" />
<c:set var="url">${req.requestURL}</c:set>
<c:set var="uri" value="${req.requestURI}" />
<base
	href="${fn:substring(url, 0, fn:length(url) - fn:length(uri))}${req.contextPath}/">
<link href="${mainCss}" rel="stylesheet" />
<link href="${pollResultsCss}" rel="stylesheet" />
</head>
<body>
	<%@ include file="top_menu.jsp"%>
	<div class="content">
		<h1>Poll results</h1>
		<table class="table_main result_content">
			<c:forEach var="answer" items="${question.answers}"
				varStatus="status">
				<tr>
					<c:set var="percent" value="${answer.votes/question.totalVotes}" />
					<td>
						<div class="question">
							<c:out value="${answer.answer}" />
						</div>
					</td>
					<td>
						<div class="scale"
							style="width:<fmt:formatNumber type="percent" maxFractionDigits="0"
								value="${percent}" />">${answer.votes}</div>
					</td>
					<td>
						<div>
							<fmt:formatNumber type="percent" minFractionDigits="2"
								value="${percent}" />
						</div>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
</html>
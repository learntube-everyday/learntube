<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Learntube 관리</title>
<link rel="shortcut icon"
	href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
<link rel="icon"
	href="${pageContext.request.contextPath}/resources/img/Learntube.png">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
<meta name="msapplication-tap-highlight" content="no">

<link href="${pageContext.request.contextPath}/resources/css/main.css"
	rel="stylesheet">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/main.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/3daf17ae22.js"
	crossorigin="anonymous"></script>
</head>
</head>
<body>
	<div class="container h-100 d-flex align-items-center">
		<ul
			class="body-tabs body-tabs-layout tabs-animated body-tabs-animated nav">
			<li class="nav-item"><a role="tab" class="nav-link active show"
				id="tab-0" data-toggle="tab" href="#tab-content-0"
				aria-selected="true"> <span>강의실</span>
			</a></li>
			<li class="nav-item"><a role="tab" class="nav-link show"
				id="tab-1" data-toggle="tab" href="#tab-content-1"
				aria-selected="false"> <span>선생님</span>
			</a></li>
			<li class="nav-item"><a role="tab" class="nav-link show"
				id="tab-2" data-toggle="tab" href="#tab-content-2"
				aria-selected="false"> <span>학생</span>
			</a></li>
		</ul>
		<div class="col-md-12">
			<div class="main-card mb-3 card">
				<div class="card-header">강의실 목록</div>
				<div class="table-responsive">
					<table
						class="align-middle mb-0 table table-borderless table-striped table-hover">
						<thead>
							<tr>
								<th class="text-center">Num</th>
								<th>강의실 이름</th>
								<th class="text-center">생성일</th>
								<th class="text-center">Status</th>
							</tr>
						</thead>
						<tbody>
						<c:if test="${!empty class}">
								<c:forEach var="i" varStatus="status" items="${class}">
									<tr>
										<td class="text-center text-muted">${status.count}</td>
										<td>
											<div class="widget-content p-0">
												<div class="widget-content-wrapper">
													<div class="widget-content-left mr-3">
														<div class="widget-content-left">
															<img width="40" class="rounded-circle"
																src="assets/images/avatars/4.jpg" alt="">
														</div>
													</div>
													<div class="widget-content-left flex2">
														<div class="widget-heading">${i.name}</div>
														<div class="widget-subheading opacity-7">${i.email}</div>
													</div>
												</div>
											</div>
										</td>
										<td class="text-center">Madrid</td>
										<td class="text-center">
											<div class="badge badge-warning">Pending</div>
										</td>
										<td class="text-center">
											<button type="button" id="PopoverCustomT-1"
												class="btn btn-danger btn-sm">삭제</button>
										</td>
									</tr>
								</c:forEach>
							</c:if>
						</tbody>
					</table>
				</div>
				<div class="d-block text-center card-footer">
					<button class="mr-2 btn-icon btn-icon-only btn btn-outline-danger">
						<i class="pe-7s-trash btn-icon-wrapper"> </i>
					</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>invitation page</title>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
<link rel="icon" href="favicon-16.png" sizes="16x16">
<link rel="icon" href="favicon-32.png" sizes="32x32">
<link rel="icon" href="favicon-48.png" sizes="48x48">
<link rel="icon" href="favicon-64.png" sizes="64x64">
<link rel="icon" href="favicon-128.png" sizes="128x128">
<!--favicon 설정 -->

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/3daf17ae22.js"
	crossorigin="anonymous"></script>

<style>
.divider:after, .divider:before {
	content: "";
	flex: 1;
	height: 1px;
	background: #eee;
}

.h-custom {
	height: calc(100% - 73px);
}

@media ( max-width : 450px) {
	.h-custom {
		height: 100%;
	}
}
</style>

<script>
	window.onload = function(){
		var flag = ${alreadyEnrolled};
		if(flag == 1){
			alert("이미 수강신청하였거나 참여중인 공간입니다.");
			if('${login.mode }' === 'lms_teacher') window.location.replace('${pageContext.request.contextPath}/dashboard');
			else window.location.replace('${pageContext.request.contextPath}/student/class/dashboard');
		}		
	}
	function showAlert(){
		alert("수강신청이 성공적으로 완료되었습니다!! :) ");
	}
</script>

</head>

<body>
	<section class="vh-100" style="background-color: #F0F0F0;">
		<div class="container py-5 h-100">
			<div
				class="row d-flex justify-content-center align-items-center h-100">
				<div class="col col-xl-10">
					<div class="card" style="border-radius: 1rem;">
						<div class="row g-0">
							<div class="col-md-6 col-lg-5 d-none d-md-block">
								<img src="${pageContext.request.contextPath}/resources/img/Learntube-logos_transparent.png"
									alt="login form" class="img-fluid"
									style="border-radius: 1rem 0 0 1rem;" />
							</div>
							<div class="col-md-6 col-lg-7 d-flex align-items-center">
								<div class="card-body p-4 p-lg-5 text-black">
									<div class="d-flex align-items-center mb-3 pb-1">
										<span class="h1 fw-bold mb-0"> <span class="text-primary"> ${classInfo.className} </span> 강의실에 입장하시겠습니까? </span> 
									</div>
										
										<c:choose>
											<c:when test="${login.name == null}" >
												<form class="needs-validation" action='${pageContext.request.contextPath}/login/google' onsubmit='checkLoginMode();' method='post' novalidate>
													<input name="mode" class="form-check-input" value="stu" style="display:none;">
													<div class="pt-1 mb-4">
														<button class="btn btn-lg btn-block btn-danger" type="submit" >
															<i class="fab fa-google me-2"></i> Google로 로그인
														</button>
													</div>
												</form>
											</c:when>
											<c:otherwise>
												<button class="btn btn-lg btn-block btn-danger" type="submit" onclick="location.href = '${pageContext.request.contextPath}/enroll '" >
													수업 신청하기 
												</button>
											</c:otherwise>
										</c:choose>
											
										
									<p class="small text-muted	">&copy;Everyday</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<script>
        // Example starter JavaScript for disabling form submissions if there are invalid fields
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                // Fetch all the forms we want to apply custom Bootstrap validation styles to
                var forms = document.getElementsByClassName('needs-validation');
                // Loop over them and prevent submission
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        } 
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
	</script>
</body>
</html>
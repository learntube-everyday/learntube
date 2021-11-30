<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Opps...</title>
</head>

<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>

<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="outer_top_stu.jsp" flush="false"/>

		<div class="app-main">	 
			<jsp:include page="outer_left_stu.jsp" flush="false">
				<jsp:param name="className" value="${className}" />
				<jsp:param name="menu" value="calendar" />
			</jsp:include>	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<h3>접근 권한이 없습니다!</h3>
                            </div>
                        </div>
                    </div>            
                    <div class="row">	
                    </div>	
        		</div>
        		<jsp:include page="outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
</body>
</html>
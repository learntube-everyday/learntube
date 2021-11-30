<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>출결/학습 현황</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="msapplication-tap-highlight" content="no">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
</head>

<style>
.name {
  position:sticky;
  left:0px;
  background-color: #dbd7d7;
  min-width: 90px;
}
@media only screen and (min-width: 992px) {
	.attendanceBox{
		width: 100vh;
	}
}

</style>

<script>

$(document).ready(function(){
	$.ajax({
		'url' : "${pageContext.request.contextPath}/attendance/getfileName",
		'processData' : false,
		'contentType' : false,
		'type' : 'POST',
		success: function(data){
			
			for(var i=0; i<data.length; i++){
				if(data[i] != null){
					var element = document.getElementById('download'+(i+1));
					element.innerHTML = '<a href="${pageContext.request.contextPath}/resources/csv/' +data[i].fileName+ '">Download</a>';
				}
				else continue;
			}
		},
		error : function(err){
			alert("CSV 파일을 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!:("); 
		},
	});
	
	var allMyClass = JSON.parse('${realAllMyClass}');
	var weekContents = JSON.parse('${weekContents}');
	var takes = JSON.parse('${takes}');
	var classDays = JSON.parse('${classDays}');
	
	$.ajax({ 
		url : "${pageContext.request.contextPath}/attendance/forDays",
		type : "post",
		async : false,
		success : function(data) {
			daysCount = data;
		},
		error : function() {
			alert("강의실 차시 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!:("); 
		}
	});
	
	$.ajax({ 
		url : "${pageContext.request.contextPath}/attendance/forWatchedCount",
		type : "post",
		async : false,
		success : function(data) {
			watchCount = data; 
		},
		error : function() {
			alert("학생 학습현황 데이터를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!:("); 
		}
	});
			
	for(var j=0; j<${takesNum}; j++){
		for(var i=0; i<classDays; i++){
			
			if(daysCount[j][i] != null ){ //playlist없이 description만 올림
				var element = document.getElementsByClassName('innerAttend'+(j+1)+""+(i+1))[0];
				element.innerHTML = '' ;
				
				if(daysCount[j][i] == "출석"){
					element.innerHTML +=  "<i class='pe-7s-check fa-2x' style='color:dodgerblue'></i>";
				}
				if(daysCount[j][i] == "미확인")
					element.innerHTML +=  "<i class='pe-7s-less fa-2x' style='color:grey'></i>";
				if(daysCount[j][i] == "결석")
					element.innerHTML +=  "<i class='pe-7s-check fa-2x' style='color:red'></i>";
				if(daysCount[j][i] == "지각")
					element.innerHTML +=  "<i class='pe-7s-check fa-2x' style='color:orange'></i>";
					
				if(watchCount[j][i] >= 0)
					document.getElementsByClassName('innerAttendance'+(j+1)+""+(i+1))[0].innerText = watchCount[j][i] + "%";
				else 
					document.getElementsByClassName('innerAttendance'+(j+1)+""+(i+1))[0].innerText = "";
				
			
			
			}
			
		}
	}
	
	$("#button").click(function(event){
		console.log("daySeq :" + $("#inputSeq").val());
		event.preventDefault();
		var form = $("#attendForm");
		var seq = $("#inputSeq").val(); //지우면 안돼 
		var formData = new FormData(form[6]);
		var start_h =  $('#startTimeH').val();
		var start_m = $('#startTimeM').val();
		var end_h = $('#endTimeH').val();
		var end_m = $('#endTimeM').val();

		if(start_h == '' || start_h == null) start_h = "0";
		if(start_m == '' || start_m == null) start_m = "0";
		if(end_h == '' || end_h == null) end_h = "23";
		if(end_m == '' || end_m == null) end_m = "59";

		formData.append("file", $("#exampleFile")[0].files[0]);
		formData.append("daySeq", seq-1);
		formData.append("start_h", start_h);
		formData.append("start_m", start_m);
		formData.append("end_h", end_h);
		formData.append("end_m", end_m);
		var table = document.getElementById('takes');
		
		$.ajax({
			'url' : "${pageContext.request.contextPath}/attendance/uploadCSV",
			'processData' : false,
			'contentType' : false,
			'data' : formData,
			'type' : 'POST',
			success: function(data){
				for(var i=0; i<data[0].length; i++){
					var rows = document.getElementById("stuName").getElementsByTagName("span");
					for( var r=0; r<rows.length; r++ ){
						var name = rows[r];
						console.log("name  :  " +name.innerText);
						  if(name.innerText == data[0][i]){
						  		$(".takeZoom"+seq).eq(r).val(1).prop("selected", true); 
						  		break;
						  }
						  
					}
					
				}
				
				for(var i=0; i<data[1].length; i++){
					var rows = document.getElementById("stuName").getElementsByTagName("span");
					for( var r=0; r<rows.length; r++ ){
						var name = rows[r];
						  if(name.innerText == data[1][i]){
						  		$(".takeZoom"+seq).eq(r).val(3).prop("selected", true);
						  		break;
						  }
						  
					}
					
				}
				$("#showAttendance").empty();
				$("#showAttendance").append('<div> 출석 ' + data[0].length + '명 / 결석 ' + data[1].length + '명 / 미확인 ' + data[2].length + '명 </div>');
				
				
				for(var i=0; i<data[0].length; i++)
					$("#showAttendance").append('<div> 출석 : ' +data[0][i] + '</div>');
				
				for(var i=0; i<data[1].length; i++)
					$("#showAttendance").append('<div> 결석 : ' +data[1][i] + '</div>');
				
				for(var i=0; i<data[2].length; i++)
					$("#showAttendance").append('<div> 미확인 : ' +data[2][i] + '</div>');
				
				$("#showAttendance").show();
				 //idx ++;
				 
			},
			error : function(err){
				alert("파일 업로드에 실패했습니다. 잠시후 다시 시도해주세요:(");
			},
		});
	});
	
	$("#addStudentModal").on("hidden.bs.modal", function () {
		console.log("hi there");
		$('.entryCode').hide();
	});
});
  
function displayEntryCode(){
	$('.entryCode').show();
}
function copyToClipboard(element) {
	 navigator.clipboard.writeText($(element).text());
}
function allowStudent(studentID){
	console.log("studentID ==> " + studentID);	
	console.log("classID ==> " + ${classInfo.id});	
	var classID = ${classInfo.id};
	var objParams = {
		studentID : studentID,
		status : "accepted",
		classID : classID,
	};
	$.ajax({
		'type' : 'POST',
		'url' : '${pageContext.request.contextPath}/member/allowTakes',
		'data' : JSON.stringify(objParams),
		'contentType' : "application/json",
		'dataType' : "text",
		success : function(data){
			alert('학생 강의실 승낙 성공! ');
			showAllStudentInfo();
		}, 
		error:function(request,status,error){
	        alert("학생 등록에 실패했습니다. 잠시후 다시 시도해주세요!:("); 
	    }	
	});
}
function deleteRequest(studentID, option){
	console.log("삭제 버튼 되는지 확인 => ", studentID);
	if(option == 1){
		if(!confirm("해당 학생의 요청을 삭제하시겠습니까? ")){
			return false;
		}
	}
	else {
		if(!confirm("주의!! 해당 학생의 모든 수업 정보는 사라지게 됩니다. 진행하시겠습니까? ")){
			return false;
		}
	}
	var classID = ${classInfo.id};
	var objParams = {
		studentID : studentID,
		classID : classID,
	}
	
	$.ajax({
		'type' : 'POST',
		'url' : '${pageContext.request.contextPath}/member/deleteTakes',
		'data' : JSON.stringify(objParams),
		'contentType' : "application/json",
		success : function(data){
			var result = showAllStudentInfo();
			console.log("삭제 성공!" + result)
		},
		error:function(request,status,error){
			alert("학생 등록 삭제에 실패했습니다. 잠시후 다시 시도해주세요!:("); 
	    }	
	});
}

function showAllStudentInfo(){
	$.ajax({
		'type' : 'GET',
		'url' : '${pageContext.request.contextPath}/member/updateTakesList',
		'data' : {classID : ${classInfo.id}},
		success : function(data) {
			$('.studentList').empty();
			var list = data.studentInfo;
			console.log(list);
			var updatedStudentList = '<p class="text-primary mt-3"> 승인 대기중인 학생 </p>';
			
			$.each(list, function(index, value){
        			if(value.status == "pending"){
        				updatedStudentList +=
        				'<li class="list-group-item d-sm-inline-block" style="padding-top: 5px; padding-bottom: 30px">'
        					+ '<div class="row align-items-center">'
       							+ '<div class="titles col-sm-4 ">'
	       							+ '<div class="row">'
	      								+ '<p class="col-sm-12 mb-0">' + value.name + ' </p>'
	       								+ '<p class="col-sm-12 mb-0">' + value.email + '</p>'
	    							+ '</div>'
    							+ '</div>'
    							+ '<div class="col-sm-5">'
    							+ '<div class="row">'
	    							+ '<p class="col-sm-12 mb-0" style="text-align:center">신청일자  ' + value.regDate + '</p>'
									<%-- <fmt:parseDate var="dateString" value="${person.regDate }" pattern="yyyyMMddHHmmss" />
									<fmt:formatDate value="${dateString }" pattern="yyyy-MM-dd"/> --%>
								+ '</div>'
								+ '</div>' 
    						+ '<div class="col-sm-3"><button class="btn btn-transition btn-primary" onclick="allowStudent('+ value.studentID + ');"> 추가 </button>'
    						+ '<button class="btn btn-danger btn-sm" onclick="deleteRequest( ' + value.studentID + ' ,1)">삭제</button>'
    						+ '</div>'
    						+ '</div>'
    					+ '</li>';
        			}
			});
			
			updatedStudentList += '<p class="text-primary mt-3"> 등록된 학생</p>';
			
			$.each(list, function(index, value){
	    			if(value.status == "accepted"){
	    				updatedStudentList +=
	    				'<li class="list-group-item d-sm-inline-block" >'  // style="padding-top: 5px; padding-bottom: 30px"
	    					+ '<div class="row">'
	   							+ '<div class="titles col-sm-4 ">'
	       							+ '<div class="row">'
	       								+ '<input type="hidden" id="studentID" value="${person.studentID }" />'
	      								+ '<p class="col-sm-12 mb-0">' + value.name + ' </p>'
	       								+ '<p class="col-sm-12 mb-0">' + value.email + '</p>'
	    							+ '</div>'
								+ '</div>'
								+ '<div class="col-sm-5">'
    							+ '<div class="row">'
	    							+ '<p class="col-sm-12 mb-0" style="text-align:center">등록일' + value.modDate + ' </p>'
									<%-- <fmt:parseDate var="dateString" value="${person.regDate }" pattern="yyyyMMddHHmmss" />
									<fmt:formatDate value="${dateString }" pattern="yyyy-MM-dd"/> --%>
								+ '</div>'
								+ '</div>'    
							+ '<div class="col-sm-3"><button class="btn btn-transition btn-danger" onclick="deleteRequest( ' + value.studentID + ' ,1)"> 삭제  </button></div>'
							+ '</div>'
						+ '</li>';
	    			}
			}); 
			
			$('.list-group').append(updatedStudentList);
		},
		error:function(request,status,error){
			alert("학생 명단을 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!:("); 
	    }
	});
}

function setAttendanceModal(daySeq){
	$('#inputSeq').val(daySeq);
	$('.displayDaySeq').text(daySeq + '차시');
}

function setLMSAttendanceModal(seq, name, email, item){
	var innerHTML = item.innerHTML;
	$('input[type=checkbox]').prop('checked', false);
	var status;
	
	if(innerHTML == '<i class="pe-7s-check fa-2x" style="color:dodgerblue"></i>')
		status = 'checkAttend';
	else if(innerHTML == '<i class="pe-7s-check fa-2x" style="color:orange"></i>')
		status = 'checkLate';
	else if(innerHTML == '<i class="pe-7s-check fa-2x" style="color:red"></i>')
		status = 'checkAbsent';
	else
		status = 'checkNon';

	$('.' + status).prop('checked', true);
	$('#inputSeq').val(seq);
	$('.displayDaySeqLMS').text((seq+1) + '차시 ');
	$('.displayStudentInfo').text(name + ' ' + email);
	
}

function updateAttendance(days){
	//attendanceID를 알아야한다. 그러기 위해서는 classID, days, instructorID가 필요하다.
	//days의 $(".takeZoom"+seq).eq(r).val();을 리스트로 만들면되지 않을까  == //takeZoom(days+1)번째의 value들을 array에 저장하기
	var rows = document.getElementById("stuName").getElementsByTagName("span");
	var finalTakes = [];
	var finalInternalTakes = [];
	var days = days + 1;
	
	var attendanceID = 0;
	for(var i=0; i<rows.length; i++){
		console.log(" i " + i + "  " + $(".takeZoom"+days).eq(i).val());
		if($(".takeZoom"+days).eq(i).val() == -1){
			finalTakes.push("미확인"); 
		}
		
		if($(".takeZoom"+days).eq(i).val() == 0)
			finalTakes.push($(".originVal"+days).eq(i).text());
		if($(".takeZoom"+days).eq(i).val() == 1)
			finalTakes.push("출석");
		if($(".takeZoom"+days).eq(i).val() == 2)
			finalTakes.push("지각");
		if($(".takeZoom"+days).eq(i).val() == 3)
			finalTakes.push("결석");
		if($(".takeZoom"+days).eq(i).val() == 4)
			finalTakes.push("미확인");
		
		if($(".innerAttend"+(i+1)+""+days)[0].innerHTML == '<i class="pe-7s-check fa-2x" style="color:dodgerblue"></i>')
			finalInternalTakes.push("출석");
		else if($(".innerAttend"+(i+1)+""+days)[0].innerHTML == '<i class="pe-7s-check fa-2x" style="color:orange"></i>')
			finalInternalTakes.push("지각");
		else if($(".innerAttend"+(i+1)+""+days)[0].innerHTML == '<i class="pe-7s-check fa-2x" style="color:red"></i>')
			finalInternalTakes.push("결석");
		else
			finalInternalTakes.push("미확인");
		
	}

	$.ajax({ //attendaceID를 위해 
		'type' : "post",
		'url' : "${pageContext.request.contextPath}/attendance/forAttendance",
		'data' : { 
			days : days-1,
		},
		success : function(data){
			attendanceID = data;
			
			$.ajax({ 
				'type' : "post",
				'url' : "${pageContext.request.contextPath}/attendance/whichAttendance",
				'data' : { 
					attendanceID : attendanceID,
					days : days-1,
					finalTakes : finalTakes,
					finalInternalTakes : finalInternalTakes
				},
				success : function(data){
					attendanceID = data;
					
				}, 
				error : function(err){
					alert("실패");
				},
				complete : function(){
					location.reload();
				}
			});
			
			
		}, 
		error : function(err){
			alert("파일 업로드를 해주세요 ");
		}
	});
	
}

function clickCheck(target) {
    document.querySelectorAll(`input[type=checkbox]`)
        .forEach(el => el.checked = false);

    target.checked = true;
}

var innerAttendList = new Array();

function setInnerAttendance(takes, idx) { 
	console.log("takes : " + takes + " idx : " + idx);
	var seq = $("#inputSeq").val(); 	
	
	var element = document.getElementsByClassName('innerAttend'+takes+""+idx)[0];
	element.innerHTML = '';
	if($("#forAttendance"+takes+""+idx).is(':checked') == true){
		element.innerHTML += "<i class='pe-7s-check fa-2x' style='color:dodgerblue'></i>";
	}
	
	if($("#forLate"+takes+""+idx).is(':checked') == true){
		element.innerHTML += "<i class='pe-7s-check fa-2x' style='color:orange'></i>";
	}
	
	if($("#forAbsent"+takes+""+idx).is(':checked') == true){
		element.innerHTML += "<i class='pe-7s-check fa-2x' style='color:red'></i>";
	}
	
	if($("#forNoCheck"+takes+""+idx).is(':checked') == true){
		element.innerHTML += "<i class='pe-7s-less fa-2x'> </i>";
	}
	
}
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
		<jsp:include page="../outer_top.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left.jsp" flush="false">
		 		<jsp:param name="className" value="${classInfo.className}"/>	
		 		<jsp:param name="menu" value="notice"/>
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<h4><span class="text-primary">${classInfo.className}</span> - 출석/학습현황</h4>
                                <a href="#" data-toggle="modal" data-target="#addStudentModal" class="nav-link editPlaylistBtn" style="display:inline;">       
	                            	<button class="btn-transition btn btn-outline-secondary"> 
	                                		<i class="pe-7s-add-user fa-lg"> </i>  구성원 관리
	                                </button>
                                </a>
                            </div>
                        </div>
                    </div>  
                    
                    <div class="row">
                    	<div class="col-lg-12 attendanceBox" >
                         	<div class="main-card mb-3 card">
                                    <div class="card-body ">
                                    	<div class="table-responsive" >
                                        <table class="mb-0 table table-striped table-bordered takes">
                                            <thead>   
	                                            <tr>
	                                            	<!-- <th colspan="2"> # </th>-->
	                                            	<th width = "10% " rowspan=2 style="padding-bottom : 20px"> 차시 </th>
		                                            <c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
		                                                <th style="text-align:center" colspan=2>${j} 차시
		                                                	<button type="button" class="btn btn-success btn-sm" onclick="updateAttendance(${j}-1)" >저장</button>
		                                                 </th>
		                                            </c:forEach>
	                                            </tr>
	                                            <tr>
	                                            	<c:forEach  var="j" begin="1" end="${classInfo.days}" varStatus="status">
	                                            		<td class="zoomAttend p-0" style="text-align:center; min-width: 80px">
	                                            			<button class="btn btn-sm btn border-0 btn-transition btn btn-outline-primary" onclick="setAttendanceModal(${j});" 
	                                            								data-toggle="modal" data-target="#editAttendance" class="nav-link p-0" style="display:inline;">
	                                            				<i class="pe-7s-video" style=" color:dodgerblue"> </i>  ZOOM 
	                                            			</button>
	                                            			<!--  <a href="#" onclick="setAttendanceModal(${j});" data-toggle="modal" data-target="#editAttendance" class="nav-link p-0" style="display:inline;">
	                                            				<i class="pe-7s-video" style=" color:dodgerblue"> </i>  ZOOM 
	                                            			</a>
	                                            			-->
	                                            		</td>
					                                    <td  id="lmsAttend text-center" style="font-weight:bold; text-align:center;">LMS</td>
					                                </c:forEach>
	                                            </tr>
                                            </thead>
                                            
                                            <tbody id ="stuName">
												<c:if test="${!empty takes}">
													<c:forEach var="i" begin="0" end="${takesNum-1}" varStatus="status">
			                                            <tr>
			                                                <th class = "row${status.index} name" scope="row${status.index}" rowspan=2><span>${takes[status.index].name}</span> <br>${takes[status.index].email}</th>
			                                            </tr>
														<tr>
			                                             	<c:if test="${!empty file}">
				                                            	 <c:forEach var="i" begin="0" end="${fileNum-1}" varStatus="status2"> <!-- db에 저장되지 않은 부분임으로 똑같이 하지만 반복 횟수만 수정하기  -->
				                                            	 	<td style="text-align:center" > 
								                                        <select  id ="sel" class="takeZoom${status2.index+1} form-select"  aria-label="Default select example" >
																		  <option selected value="0" class="originVal${status2.index+1}">${file[status2.index][status.index]}</option>
																		  <option value="1" class="blue">출석</option>
																		  <option value="2" class="yellow">지각</option>
																		  <option value="3" class="red">결석</option>
																		  <option value="4" class="red">미확인</option>
																		</select>
				                                            	 	</td>
				                                                	
				                                                	<td id = "takeLms${status2.index+1}" class="takeLms${status.index+1}${status2.index+1}" style="text-align:center"> 
				                                                		<div class="innerAttendance${status.index+1}${status2.index+1}"></div>
																		<button class="btn btn-sm btn border-0 btn-transition btn btn-outline-primary innerAttend${status.index+1}${status2.index+1}" 
																					 onclick="setLMSAttendanceModal(${i}, '${takes[status.index].name}', '${takes[status.index].email}', this);" 
		                                            								data-toggle="modal" data-target="#editInnerAttendance${status.index+1}${status2.index+1}" class="nav-link p-0" style="display:inline;">
				                                            				<i class="pe-7s-note"> </i>
				                                            			</button>
																	</td>
				                                                </c:forEach>
			                                                </c:if>
			                                                
			                                                 <c:forEach var="i" begin="${fileNum}" end="${classInfo.days-1}" varStatus="status2"> <!-- db에 저장되지 않은 부분임으로 똑같이 하지만 반복 횟수만 수정하기  -->
			                                            	 	<td style="text-align:center" > 
							                                        <select  id ="sel" class="takeZoom${status2.index+1} form-select"  aria-label="Default select example" >
																	  <option style="backgroudcolor:yellow" selected value="-1" class="originVal${status2.index+1}" >출석체크 </option>
																	  <option value="1" class="blue">출석</option>
																	  <option value="2" class="yellow">지각</option>
																	  <option value="3" class="red">결석</option>
																	  <option value="4" class="red">미확인</option>
																	</select>
			                                            	 	</td>
			                                                	<td id = "takeLms${status2.index+1}" class="takeLms${status.index+1}${status2.index+1}" style="text-align:center"> 
			                                                	<div class="innerAttendance${status.index+1}${status2.index+1}"></div>
			                                                		<button class="btn btn-sm btn border-0 btn-transition btn btn-outline-primary innerAttend${status.index+1}${status2.index+1}"
			                                                						onclick="setLMSAttendanceModal(${i}, '${takes[status.index].name}', '${takes[status.index].email}', this);" 
		                                            								data-toggle="modal" data-target="#editInnerAttendance${status.index+1}${status2.index+1}" class="nav-link p-0" style="display:inline;">
				                                            				<i class="pe-7s-note"> </i>
				                                            			</button>
																</td>
																
																
			                                                </c:forEach>
			                                            </tr>
			                                            
			                                             
	                                            	</c:forEach>
	                                            </c:if>
	                                            <tr>
	                                            	<td style="text-align:center" > 
						                            	업로드한 파일
		                                           </td>
		                                           <c:forEach var="i" begin="0" end="${classInfo.days-1}" varStatus="status2">
		                                           		<td id = "download${status2.index+1}" style="text-align:center" colspan=2> </td>
		                                           </c:forEach>
	                                            </tr>
                                            </tbody>
                                        </table>
                                        </div>
                                    </div>
                        	</div>
                    	</div>
                    </div> 
                    
                    <div>
                    	<div class="main-card mb-3 card">
	                    	<div id="showAttendance" class="card-body" style="display:none"></div>
	                    </div>
                    </div>
        		</div>

        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
	 
	<div class="modal fade" id="addStudentModal" tabindex="-1"role="dialog" aria-labelledby="editContentModal" aria-hidden="true" style="display: none;">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="editContentModalLabel"> <span class="text-primary">${classInfo.className}</span> - 구성원 관리</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">×</span>
					</button>
				</div>
				
				<div class="modal-body">
					<div class="card-body" style="overflow-y: auto; height: 600px;">
						<div class="row align-items-center">
							<div class="col-lg-2 pr-0">
								<button id="modalSubmit" type="button"
								class="btn-transition btn btn-outline-secondary" onclick="displayEntryCode();">초대링크 조회</button>
							</div>
							<div class="entryCode col-md-8 row ml-1 align-items-center" style="display:none;">
								<span id="link" class="mr-4"> learntube.kr/invite/${classInfo.entryCode} </span>
								<div class="entryCode row" style="display:none;">
									<button class="btn btn-transition btn-success btn-sm" onclick="copyToClipboard('#link')" data-container="body" data-toggle="popover" data-placement="bottom" data-content="링크가 복사되었습니다!"> 복사</button>
								</div>
							</div>
						</div>
						

						<ul class="list-group studentList">
							<p class="text-primary mt-3 mb-1"> 승인 대기중인 인원 </p>
							<c:forEach var="person" items="${studentInfo}" varStatus="status">
                            	<c:if test="${person.status == 'pending'}" >
                            		<li class="list-group-item d-sm-inline-block">
										<div class="row align-items-center">
											<!--  
											<div class="thumbnailBox col-sm-1 row ml-1 mr-1">
												<span onclick="deleteRequest(${person.studentID}, 1)">
													<i class="pe-7s-close fa-lg" style="margin-right: 30px; cursor:pointer"> </i>
												</span>
											</div>
											-->
											<div class="titles col-sm-4 ">
												<div class="row">
													<p class="col-sm-12 mb-0">${person.name} </p>
													<p class="col-sm-12 mb-0">${person.email} </p>
												</div>
											</div>
											<div class="col-sm-5">
												<p class="mb-0">신청일 ${person.regDate}</p>
												
													<%-- <fmt:parseDate var="dateString" value="${person.regDate }" pattern="yyyyMMddHHmmss" />
													<fmt:formatDate value="${dateString }" pattern="yyyy-MM-dd"/> --%>
	
											 </div> 
											<div class="col-sm-3">
												<button class="btn btn-primary btn-sm mr-1" onclick="allowStudent(${person.studentID});">등록</button>
												<button class="btn btn-danger btn-sm" onclick="deleteRequest(${person.studentID}, 1);">삭제</button>
											</div>
										</div> 
                            		</li> 
                            	</c:if>
	                        </c:forEach>  							
							
							 <p class="text-primary mt-3 mb-1"> 등록된 인원 </p>
							 <c:forEach var="person" items="${studentInfo}" varStatus="status">
							 	<c:if test="${person.status == 'accepted'}" >
							 		<li class="list-group-item d-sm-inline-block"> 
										<div class="row">
											<!--  <div class="thumbnailBox col-sm-1 row ml-1 mr-1"></div>-->
											<div class="titles col-sm-4 ">
												<div class="row">
													<p class="col-sm-12 mb-0">${person.name} </p>
													<p class="col-sm-12 mb-0">${person.email} </p>
												</div>
											</div>
											<div class="col-sm-5">
												<p class="mb-0">등록일 ${person.modDate}</p>
											 </div> 
											<div class="col-sm-3">
												<button class="btn btn-danger btn-sm" onclick="deleteRequest(${person.studentID}, 2)">삭제</button>
											</div>
										</div>
									</li>
								</c:if>
							</c:forEach>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- upload csv file modal -->
    <div class="modal fade" id="editAttendance" tabindex="-1" role="dialog" aria-labelledby="editAttendance" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="editAttendanceLabel"><span class="text-primary displayDaySeq"></span> ZOOM 출석파일 업로드</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <form id="attendForm">
		            <div class="modal-body">
		            
		            	<input name="seq" id="inputSeq" type="hidden">
				       <div class="form-row">
							<div class="col-3 mt-2">출석인정 시작시간</div>
                           	<input name="start" id="startTimeH" type="number" class="form-control col-2" min="0" max="23">
                           	<div class="col-1 mt-2">시</div>
                           	<input name="start" id="startTimeM" type="number" class="form-control col-2" min="0" max="59">
                           	<div class="col-1 mt-2">분</div>
                       </div>
				       <div class="form-row mt-2">
							<div class="col-3 mt-2">출석인정 마감시간</div>
                           	<input name="end" id="endTimeH" type="number" class="form-control col-2" min="0" max="23">
                           	<div class="col-1 mt-2">시</div>
                           	<input name="end" id="endTimeM" type="number" class="form-control col-2" min="0" max="59">
                           	<div class="col-1 mt-2">분</div>
                       </div>                 
					  <div class="position-relative form-group input-group mt-2">
					       <input name="file" id="exampleFile" type="file" class="form-control-file">
					  </div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		            	<button type="submit" id="button" class="btn btn-primary" data-dismiss="modal">파일등록</button>
		            </div>
	            
	           </form>
	            
	        </div>
	    </div>
	</div>
	
        
	<!-- upload LMS attendance modal -->
	<c:if test="${!empty takes}">
		<c:forEach var="i" begin="0" end="${takesNum-1}" varStatus="status"> 
			<c:forEach var="j" begin="0" end="${classInfo.days-1}" varStatus="status2">
			    <div class="modal fade" id="editInnerAttendance${status.index+1}${status2.index+1}" tabindex="-1" role="dialog" aria-labelledby="editInnerAttendance${status.index+1}${status2.index+1}" aria-hidden="true" style="display: none;">
				    <div class="modal-dialog modal-sm" role="document">
				        <div class="modal-content">
				            <div class="modal-header">
				                <h5 class="modal-title" id="editInnerAttendanceLabel"><span class="text-primary displayDaySeqLMS"></span> LMS 출결관리 </h5>
				                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
				                    <span aria-hidden="true">×</span>
				                </button>
				            </div>
				
					       <div class="modal-body">  
					       		<input name="seq" id="inputSeq" type="hidden">
					       		<div class="card-title displayStudentInfo"></div>
				          		<div class="main-card">
									<div class="card-body">
					              		<form class="needs-validation" id="forInnerAttend" method="post" novalidate>
					                        <div class="position-relative row form-group">
					                        	<div class="col-sm-1 mt-2">
					                           		<div class="position-relative form-check">
					                               		<input id="forAttendance${status.index+1}${status2.index+1}" name="pinAttend" type="checkbox" class="form-check-input checkAttend" onclick="clickCheck(this)">
					                                 </div>
					                             </div>
					                             <label for="checkbox2" class="col-sm-10 col-form-label">출석</label>
					                             
					                       		<div class="col-sm-1 mt-2">
					                           		<div class="position-relative form-check">
					                               		<input id="forLate${status.index+1}${status2.index+1}" name="pinLate" type="checkbox" class="form-check-input checkLate" onclick="clickCheck(this)">
					                                 </div>
					                             </div>
					                             <label for="checkbox2" class="col-sm-10 col-form-label">지각</label>
					                             
					                             <div class="col-sm-1 mt-2">
					                           		<div class="position-relative form-check">
					                               		<input id="forAbsent${status.index+1}${status2.index+1}" name="pinAbsent" type="checkbox" class="form-check-input checkAbsent" onclick="clickCheck(this)">
					                                 </div>
					                             </div>
					                             <label for="checkbox2" class="col-sm-10 col-form-label">결석</label>
					                             
					                             <div class="col-sm-1 mt-2">
					                           		<div class="position-relative form-check">
					                               		<input id="forNoCheck${status.index+1}${status2.index+1}" name="pinNoCheck" type="checkbox" class="form-check-input checkNon" onclick="clickCheck(this)">
					                                 </div>
					                             </div>
					                             <label for="checkbox2" class="col-sm-10 col-form-label">미확인</label>
					                             
					                             
					                        </div> 
					                        
					                                     
					                    </form>
					               	</div>
					            </div>
							</div>
					            <div class="modal-footer">
					                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
					            	<button type="submit" id="setInnerAttendance" class="btn btn-primary" data-dismiss="modal" onclick="setInnerAttendance(${status.index+1}, ${status2.index+1})">확인</button>
					            </div>
				       
				            
				        </div>
				    </div>
				</div>
			</c:forEach>		
		</c:forEach>
	</c:if>
	
   	
</body>

	
</html>
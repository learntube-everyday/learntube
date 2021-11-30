<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Dashboard</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="msapplication-tap-highlight" content="no">

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>

</head>
<style>
	.dashboardClass{
		min-height: 75%;
	}
</style>
<script>
var colors = ["text-primary", "text-warning", "text-success", "text-secondary", "text-info", "text-focus", "text-alternate", "text-shadow"];
var active_colors = ["bg-warning", "bg-success", "bg-info", "bg-strong-bliss", "bg-arielle-smile", "bg-night-fade", "bg-sunny-morning"];
var inactive_colors = ["border-primary", "border-warning", "border-success", "border-secondary", "border-info", "border-focus", "border-alternate", "border-shadow"];				

$(document).ready(function(){
	$('.activeClassList').append('<p class="col text-center">강의실 목록을 가져오는중입니다. 잠시만 기다려주세요:)</p>');
	getAllMyClass();	
	
	$(".close").on( "click", function() {
	    $("#pendingClassroomModal").hide();
	})
	$("#pendingClassroomModal").on("hide",function(){
	    $("#pendingClassroomModal").css("display", "none");
	})
});

function getAllClass(act, order){	//참여중, 종료된 강의실 중 하나만 가져오는 함수 (정렬, 수정 등에 사용!)
	var i = 0;
	var classType;

	if(act == 1) classType = '.activeClassList';
	else classType = '.inactiveClassList';

	$.ajax({
		type: 'post',
		url: "${pageContext.request.contextPath}/student/class/getAllClass",
		data: {
			active: act,
			order: order
			},
		success: function(data){
			$(classType).empty();
			list = data.list;

			if(list.length == 0){
				if(act == 1)
					$(classType).append('<p class="col text-center">수강중인 강의실이 없습니다.</p>');
				else
					$(classType).append('<p class="col text-center">종료된 강의실이 없습니다.</p>');
				return false;
			}

			if(act == 1){
				$.ajax({ 
					url : "${pageContext.request.contextPath}/student/class/competePlaylistCount",
					type : "post",
					async : false,
					success : function(data) {
						completePlaylist = data;
					},
					error : function() {
						alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
					}
				})	
				
				$.ajax({ 
					url : "${pageContext.request.contextPath}/student/class/classTotalPlaylistCount",
					type : "post",
					async : false,
					success : function(data) {
						allPlaylist = data;
					},
					error : function() {
						alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
					}
				})
			}

			$(list).each(function(){
				var classID = this.id;
				var classNoticeURL = "'${pageContext.request.contextPath}/student/notice/" + classID + "'";
				var classCalendarURL = "'${pageContext.request.contextPath}/student/calendar/" + classID + "'";
				var classContentURL = "'${pageContext.request.contextPath}/student/class/contentList/" + classID + "'";
				var classAttendanceURL = "'${pageContext.request.contextPath}/student/attendance/" + classID + "'";
				var newNotice = this.newNotice;
				var html;
				
				if(newNotice == 1)
					newNotice = '<span class="badge badge-primary">NEW</span>';
				else
					newNotice = '';
				
				
				if(act == 1){
					if(completePlaylist[i] == 0 ){
						percentage = 0;
					}
					else{
						percentage = Math.floor(completePlaylist[i] /  allPlaylist[i] *100);
					}
					
					var cardColor = active_colors[i%(active_colors.length)];
					html = '<div class="col-md-6 col-lg-3">'
						+ '<div class="mb-3 card">'
							+ '<div class="card-header ' + cardColor + '">' 
								+ '<div class="col-sm-10">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
								+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn float-right">'
									+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
							+ '</div>'
							+ '<div class="card-body">'
								+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classNoticeURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="공지"></i>공지' 
									+ newNotice
								+ '</button>'
								+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="강의캘린더"></i>강의캘린더</button>'
								+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw fa-th-list mr-1" aria-hidden="true" title="강의컨텐츠"></i>강의컨텐츠</button>'
								+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classAttendanceURL + '"><i class="fa fa-fw" aria-hidden="true" title="출결/학습현황"></i>출결/학습현황</button>'
                       		+ '</div>'
                       		+ '<div class="divider m-0 p-0"></div>'
                       		+ '<div class="card-body">'
                       			+ '<div class="row">'
                        			+ '<div class="widget-subheading col-12">내 학습현황</div>'
									+ '<div class="col-12">'
										+ '<div class="mb-3 progress">'
										+ '<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: ' + percentage + '%;">' + percentage + '%</div>'
                                           + '</div>'
									+ '</div>'
								+ '</div>'
							+ '</div>'
                       	'</div>'
                       + '</div>';
				}
				
				else{
					var cardColor = inactive_colors[i%(inactive_colors.length)]; 
					html = '<div class="col-sm-12 col-md-6 col-lg-3">'
								+ '<div class="mb-3 card">'
									+ '<div class="card-header ' + cardColor + '">' 
										+ '<div class="col-sm-10">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
										+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn float-right">'
											+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
									+ '</div>'
									+ '<div class="card-body">'
										+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="' + classNoticeURL + '"><i class="fa fa-fw pr-3" aria-hidden="true"></i>공지</button>' 
										+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classCalendarURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="강의캘린더"></i>강의캘린더</button>'
										+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw fa-th-list mr-1" aria-hidden="true" title="강의컨텐츠"></i>강의컨텐츠</button>'
										+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classAttendanceURL + '"><i class="fa fa-fw" aria-hidden="true" title="출결/학습현황"></i>출결/학습현황</button>'
					        		+ '</div>'
					        	+ '</div>'
					        + '</div>';
				}
				i++;
				$(classType).append(html);
			});
		},
		error: function(data, status,error){
			alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}

function getAllMyClass(){
	var i=0;
	var active, inactive;
	
	$.ajax({
		type: 'post',
		url: "${pageContext.request.contextPath}/student/class/getAllMyClass",
		success: function(data){
			$.ajax({ 
				url : "${pageContext.request.contextPath}/student/class/competePlaylistCount",
				type : "post",
				async : false,
				success : function(data) {
					completePlaylist = data;
				},
				error : function() {
					alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
				}
			})	
			
			$.ajax({ 
				url : "${pageContext.request.contextPath}/student/class/classTotalPlaylistCount",
				type : "post",
				async : false,
				success : function(data) {
					allPlaylist = data;
				},
				error : function() {
					alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
				}
			})
			
			 $('.activeClassList').empty();
			active = data.active;
			inactive = data.inactive;
	
			if((active.length + inactive.length) == 0){
				$('.dashboardClass').append('<p class="col text-center">저장된 강의실이 없습니다.</p>');
				$('.classActive').hide();
				$('.classInactive').hide();
				return false;
			}

			if(active.length == 0)
				$('.activeClassList').append('<p class="col text-center">참여중인 강의실이 없습니다. </p>');
			else{
				$(active).each(function(){
					if(completePlaylist[i] == 0 || allPlaylist[i] == 0){
						percentage = 0;
					}
					else{
						percentage = Math.floor(completePlaylist[i] /  allPlaylist[i] *100);
					}
					
					var classID = this.id;
					var classNoticeURL = "'${pageContext.request.contextPath}/student/notice/" + classID + "'";
					var classCalendarURL = "'${pageContext.request.contextPath}/student/calendar/" + classID + "'";
					var classContentURL = "'${pageContext.request.contextPath}/student/class/contentList/" + classID + "'";
					var classAttendanceURL = "'${pageContext.request.contextPath}/student/attendance/" + classID + "'";
					var cardColor = active_colors[i%(active_colors.length)];
					var newNotice = this.newNotice;
					
					if(newNotice == 1)
						newNotice = '<span class="badge badge-primary">NEW</span>';
					else
						newNotice = '';
					
					var dashboardCard = '<div class="col-sm-12 col-md-6 col-lg-3">'
											+ '<div class="mb-3 card">'
												+ '<div class="card-header ' + cardColor + '">' 
													+ '<div class="col-sm-10">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
													+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn float-right">'
														+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
												+ '</div>'
												+ '<div class="card-body">'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classNoticeURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="공지"></i>공지' 
														+ newNotice
													+ '</button>'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classCalendarURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="강의캘린더"></i>강의캘린더</button>'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw fa-th-list mr-1" aria-hidden="true" title="강의컨텐츠"></i>강의컨텐츠</button>'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classAttendanceURL + '"><i class="fa fa-fw" aria-hidden="true" title="출결/학습현황"></i>출결/학습현황</button>'
				                        		+ '</div>'
				                        		+ '<div class="divider m-0 p-0"></div>'
				                        		+ '<div class="card-body">'
				                        			+ '<div class="row">'
					                        			+ '<div class="widget-subheading col-12">내 학습현황</div>'
														+ '<div class="col-12">'
															+ '<div class="mb-3 progress">'
				                                            	+ '<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: ' + percentage + '%;">' + percentage + '%</div>'
				                                            + '</div>'
														+ '</div>'
													+ '</div>'
												+ '</div>'
				                        	'</div>'
				                        + '</div>';
				   
					$('.activeClassList').append(dashboardCard);
					i++;
				});
			}

			if(inactive.length == 0)
				$('.inactiveClassList').append('<p class="col text-center">종료된 강의실이 없습니다.</p>');
			else{
				i = 0;
				$(inactive).each(function(){
					var classID = this.id;
					var classNoticeURL = "'${pageContext.request.contextPath}/student/notice/" + classID + "'";
					var classCalendarURL = "'${pageContext.request.contextPath}/student/calendar/" + classID + "'";
					var classContentURL = "'${pageContext.request.contextPath}/student/class/contentList/" + classID + "'";
					var classAttendanceURL = '#';
					var cardColor = inactive_colors[i%(inactive_colors.length)]; 

					var dashboardCard = '<div class="col-sm-12 col-md-6 col-lg-3">'
											+ '<div class="mb-3 card">'
												+ '<div class="card-header ' + cardColor + '">' 
													+ '<div class="col-md-10">' +  this.className + ' (' + this.days + ' 차시)</div>' 
													+ '<a href="void(0);" classID="' + classID + '" data-toggle="modal" data-target="#setClassroomModal" class="nav-link setClassroomBtn float-right">'
														+ '<i class="nav-link-icon pe-7s-more" style="font-weight: bold;"></i></a>'
												+ '</div>'
												+ '<div class="card-body">'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classNoticeURL + '"><i class="fa fa-fw pr-3" aria-hidden="true"></i>공지</button>' 
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classCalendarURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="강의캘린더"></i>강의캘린더</button>'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw fa-th-list mr-1" aria-hidden="true" title="강의컨텐츠"></i>강의컨텐츠</button>'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classAttendanceURL + '"><i class="fa fa-fw" aria-hidden="true" title="출결/학습현황"></i>출결/학습현황</button>'
								        		+ '</div>'
								        	+ '</div>'
								        + '</div>';
										
						$('.inactiveClassList').append(dashboardCard);
						i++;
				});
			}
			
			var pending = '${allPendingClass}';
			if(pending.length > 0){
				$('#pendingClassroomModal').css('display', 'block');
			}
		},
		error: function(data, status,error){
			alert('내 강의실 목록을 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}

function moveToNotice(id){	//post 방식으로 classID를 넘기며 공지사항으로 이동
	var html = '<input type="hidden" name="classID"  value="' + id + '">';

	var goForm = $('<form>', {
			method: 'post',
			action: '${pageContext.request.contextPath}/student/notice/',
			html: html
		}).appendTo('body'); 

	goForm.submit();
}

$(document).on("click", ".setClassroomBtn", function () {	// set classroom btn 눌렀을 때 modal에 데이터 전송
	var classID = $(this).attr('classID');
	$('#setClassID').val(classID);

	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/student/class/getClassInfo',
		data: { 'classID' : classID },
		success: function(data){
			console.log(data);
			$('#displayInstructor').text(data.name);
			$('#displayClassName').text(data.className);
			$('#displayDescription').text(data.description);
			$('#setRegDate').text(data.regDate.split(" ")[0]);
		},
		error: function(data, status,error){
			alert('강의실 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
});

function submitDeleteClassroom(){
	if(confirm('강의실에서 나가시겠습니까? \n다시 복구될 수 없습니다.')){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/class/deleteClassroom',
			data: {'id' : $('#setClassID').val()},
			datatype: 'json',
			success: function(data){
				console.log('강의실 나가기 성공');
			},
			complete: function(data){
				alert('강의실 나가기가 완료되었습니다.');
				location.reload();
			},
			error: function(data, status,error){
				alert('강의실 나가기에 실패했습니다. 잠시후 다시 시도해주세요:(');
			}
		});
	}
}

function deleteRequest(studentID, classID, obj){
	if(!confirm("해당 강의실의 수강대기신청을 삭제하시겠습니까?")){
		return false;
	}
	
	var objParams = {
		studentID : studentID,
		classID : classID,
	}
	
	$.ajax({
		'type' : 'POST',
		'url' : '${pageContext.request.contextPath}/member/cancelEnroll',
		'data' : JSON.stringify(objParams),
		'contentType' : "application/json",
		success : function(data){
			alert('수강대기신청 삭제가 완료되었습니다.');
			deleteRow(obj)
		},
		error:function(request,status,error){
			alert('수강대기신청 삭제가 정상적으로 처리되지 않았습니다. 잠시후 다시 시도해주세요:(');
	    }	
	});
}

function deleteRow(obj){
	$(obj).parent().closest('.row').remove();
}

</script>
<body>
    <div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
       <jsp:include page="../outer_top_stu.jsp" flush="true"/>      
               
       <div class="app-main">  
       		<jsp:include page="../outer_left_stu.jsp" flush="false"></jsp:include>
                <div class="app-main__outer">
                   <div class="app-main__inner">
                       <div class="app-page-title">
                           <div class="page-title-wrapper">
                               <div class="page-title-heading mr-3">
                                 	<h3>내 강의실
                                 		<button type="button" class="btn mr-3 btn-transition btn btn-outline-focus btn-sm" data-toggle="modal" data-target="#pendingClassroomModal">
	                                       수강대기현황 
	                                   </button>
                                 	</h3>
                               </div>
                         </div>
                       </div>          
                      
                       <div class="dashboardClass">
                       	<div class="classActive row">
                       		<div class="col-12 row m-1">
                       			<h4>수강중인 강의실</h4>
                        		<div class="dropdown d-inline-block pl-2">
		                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
		                           <div aria-labelby="dropdownMenuButton" class="dropdown-menu">
		                               <button type="button" class="dropdown-item" onclick="getAllClass(1, 'regDate');">개설일순</button>
		                               <button type="button" class="dropdown-item" onclick="getAllClass(1, 'className');">이름순</button>
		                           </div>
		                        </div>
                       		</div>
                       		<div class="activeClassList col row"></div>
                       	</div>
                       	<div class="classInactive row">
                       		<div class="col-12 row m-1">
                       			<h4>종료된 강의실</h4>
                        		<div class="dropdown d-inline-block pl-2">
		                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
		                           <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
		                               <button type="button" tabindex="0" class="dropdown-item" onclick="getAllClass(0, 'regDate');">개설일순</button>
		                               <button type="button" tabindex="0" class="dropdown-item" onclick="getAllClass(0, 'className');">이름순</button>
		                           </div>
		                       </div>
                       		</div>
                       		<div class="inactiveClassList col row"></div>
                       	</div>
                    </div>
                   <jsp:include page="../outer_bottom.jsp" flush="true"/>
              </div>
        </div>
    </div>
    </div>
    
    <!-- set classroom modal-->
    <div class="modal fade" id="setClassroomModal" tabindex="-1" role="dialog" aria-labelledby="setClassroomModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="setClassroomModalLabel">강의실 정보</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	           
				<div class="modal-body">
					<input type="hidden" id="setClassID" value="">
					<div class="">
						<div class="position-relative form-group">
		               		<label for="editClassName" class="">강의실 이름</label> 
		               		<p id="displayClassName" class="form-control"></p>
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editClassName" class="">강사</label> 
		               		<p id="displayInstructor" class="form-control"></p>
		               </div>
		               <div class="position-relative form-group">
		               		<label for="setRegDate" class="">강의실 생성일</label> 
		               		<p id="setRegDate" class="form-control"></p>
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editClassName" class="">강의실 설명</label> 
		               		<div id="displayDescription" class="form-control" style="height: 100px;"></div>
		               </div>
					</div>
					<div class="divider"></div>
					<div class="row border border-danger m-2 p-4">
						<div class="col-md-8"><h6 class="text-danger">Danger Zone</h6></div>
						<div class=" col-md-4">
							<button type="button" class="btn btn-danger" onclick="submitDeleteClassroom();">강의실 나가기</button>
                     	</div>  
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 강의실 대기 현황 모달 -->
	<div class="modal fade show" id="pendingClassroomModal" tabindex="-1" role="dialog" aria-labelledby="pendingClassroomModalTitle" style="display: none;" aria-modal="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle"> 수강대기현황 </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body" style="text-align:center;">
            	<c:if test="${empty allPendingClass }">
            		<div class="row">
            			<div> 현재 대기중인 강의실이 없습니다!!</div>
            		</div> 
            	</c:if>
                <c:forEach var="v" items="${allPendingClass}">
                	<div class="row col">
	               		<div class="col-sm-4 ml-2" style="text-align:left;" >
	               			<p><b>'${v.className}'</b></p>
	               		</div>
	               		<div class="col-sm-2">
	               			<p>대기중</p>
	               		</div>
	               		<div class="col-sm-4">
	               			<p>요청일시 <span class="text-muted">${v.regDate}</span> </p>
	               		</div>
	               		<div>
	               			<button class="btn btn-danger btn-sm" onclick="deleteRequest(${v.studentID}, ${v.classID}, this);">삭제</button>
	               		</div>
                	</div>
                </c:forEach>
            </div>
        </div>
   	</div>
</div>
   
</body>
</html>

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
	
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> 
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
</head>
<style>
	.dashboardClass{
		min-height: 75%;
	}
</style>
<script>
var colors = ["text-primary", "text-warning", "text-success", "text-secondary", "text-info", "text-focus", "text-alternate", "text-shadow"];
var inactive_colors = ["border-primary", "border-warning", "border-success", "border-secondary", "border-info", "border-focus", "border-alternate", "border-shadow"];				
var active_colors = ["bg-warning", "bg-success", "bg-info", "bg-strong-bliss", "bg-arielle-smile", "bg-night-fade", "bg-sunny-morning"];
$(document).ready(function(){
	$('.activeClassList').append('<p class="col text-center">강의실 목록을 가져오는중입니다. 잠시만 기다려주세요:)</p>');
	getAllMyClass();
});

function getAllClass(act, order){	
	var i = 0;
	var classType;
	if(act == 1) classType = '.activeClassList';
	else classType = '.inactiveClassList';
	$.ajax({
		type: 'post',
		url: "${pageContext.request.contextPath}/getAllClass",
		data: {
			active: act,
			order: order
			},
		success: function(data){
			$(classType).empty();
			list = data.list;
			
			if(list.length == 0)
				$(classType).append('<p class="col text-center">저장된 강의실이 없습니다.</p>');
			else {
				$(list).each(function(){
					var howmanyTake;
					$.ajax({
						url : "${pageContext.request.contextPath}/member/forHowManyTakes",
						type : "post",
						async : false,
						data: {id : this.id},
						success : function(data) {
							howmanyTake = data; 
						},
						error : function() {
							alert("수강생 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요");
						}
					});
					
					var classID = this.id;
					var className = this.className;
					
					var classNoticeURL = "'${pageContext.request.contextPath}/notice/" + classID + "'";
					var classCalendarURL = "'${pageContext.request.contextPath}/calendar/" + classID + "'";
					var classContentURL = "'${pageContext.request.contextPath}/class/contentList/" + classID + "'";
					var classAttendanceURL = "'${pageContext.request.contextPath}/attendance/"+ classID + "'";
					var regDate = this.regDate.split(' ')[0];
					var closeDate = this.closeDate;
					var html;
					if(closeDate == null) closeDate = '';
					
					if(act == 1){
						$.ajax({
							url : "${pageContext.request.contextPath}/forPublished",
							type : "post",
							async : false,
							data : {classID : classID},
							success : function(data) {
								forPublished = data;
							},
							error : function() {
								alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
							}
						});
						
						$.ajax({
							url : "${pageContext.request.contextPath}/forAll",
							type : "post",
							async : false,
							data : {classID : classID},
							success : function(data) {
								forAll = data;
							},
							error : function() {
								alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
							}
						});
						
						var cardColor = active_colors[i%(active_colors.length)]; 

						var width;
						if(forPublished == 0)
							width = 0;
						else
							width = Math.floor(forPublished / forAll * 100);
						
						html = '<div class="col-sm-12 col-md-6 col-lg-3">'
								+ '<div class="mb-3 card classCard">'
								+ '<div class="card-header ' + cardColor + '">' 
									+ '<div class="col-sm-8 pr-1">' +  className + ' (' + this.days + ' 차시)' + '</div>'
									+ '<a class="col-sm-2" classID="' + classID + '" className="' + className + '" href="void(0);" onclick="shareClassroomFn(this);" data-toggle="modal" data-target="#shareClassroomModal" class="nav-link">'
										+ '<i class="nav-link-icon fa fa-share" title="강의실 복제"></i>'
									+ '</a>'
									+ '<a class="col-sm-2" href="void(0)"; onclick="editClassroomFn(' + classID + ');" data-toggle="modal" data-target="#setClassroomModal" class="nav-link">'
										+ '<i class="nav-link-icon fa fa-cog" title="강의실 설정"></i>'
									+ '</a>'
								+ '</div>'
								+ '<div class="card-body">'
									+ '<button class="btn btn-outline-focus col-4 mb-2" onclick="location.href=' + classNoticeURL + '"><i class="fa fa-fw fa-bullhorn pr-2" aria-hidden="true" title="공지"></i>공지</button>'
									+ '<button class="btn btn-outline-focus col-2 mb-2" classID="' + classID + '" className="' + className + '" onclick="setPublishNotice(this)" data-toggle="modal" data-target=".publishNoticeModal">'
											+ '<i class="fa fa-pencil-square-o" aria-hidden="true" title="공지작성"></i></button>'
									+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classCalendarURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="강의캘린더"></i>강의캘린더</button>'
									+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw fa-th-list mr-1" aria-hidden="true" title="강의컨텐츠"></i>강의컨텐츠</button>'
									+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classAttendanceURL + '"><i class="fa fa-fw mr-1" aria-hidden="true" title="출결/학습현황"></i>출결/학습현황</button>'
	                        	+ '</div>'
	                    		+ '<div class="divider m-0 p-0"></div>'
	                        	+ '<div class="card-body">'
									+ '<div class="row">'
										+ '<div class="widget-subheading col-12 pb-2"><b>개설일</b> ' + regDate + ' </div>'
										+ '<div class="widget-subheading col-12 pb-2"><b>종료 설정일</b> ' + closeDate + ' </div>'
										+ '<div class="widget-subheading col pb-2"><b>참여 '+howmanyTake+'명</b></div>'
										+ '<div class="col-12">'
											+ '<div class="mb-3 progress">'
							                	+ '<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: ' + width + '%;">' + forPublished + ' / ' + forAll + ' 차시 공개</div>'
							                + '</div>'
										+ '</div>'
									+ '</div>'
								 + '</div>'
	                    	+ '</div>'
	                    + '</div>';
					}
					else{
						var cardColor = inactive_colors[i%(inactive_colors.length)]; 
						
						html = '<div class="col-sm-12 col-md-6 col-lg-3">'
							+ '<div class="mb-3 card classCard">'
								+ '<div class="card-header ' + cardColor + '">' 
									+ '<div class="col-sm-8 pr-1">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
										+ '<a class="col-sm-2"  classID="' + classID + '" className="' + this.className + '" href="javascript:shareClassroomFn(this);" data-toggle="modal" data-target="#shareClassroomModal" class="nav-link">'
										+ '<i class="nav-link-icon fa fa-share" title="강의실 복제"></i>'
									+ '</a>'
									+ '<a class="col-sm-2" href="void(0);" onclick="editClassroomFn(' + classID + ');"  data-toggle="modal" data-target="#setClassroomModal" class="nav-link">'
										+ '<i class="nav-link-icon fa fa-cog" title="강의실 설정"></i>'
									+ '</a>'
								+ '</div>'
								+ '<div class="card-body">'
									+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classNoticeURL + '"><i class="fa fa-fw fa-bullhorn pr-3" aria-hidden="true"></i>공지</button>'
									+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classCalendarURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="강의캘린더"></i>강의캘린더</button>'
									+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw fa-th-list mr-1" aria-hidden="true" title="강의컨텐츠"></i>강의컨텐츠</button>'
									+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classAttendanceURL + '"><i class="fa fa-fw mr-1" aria-hidden="true" title="출결/학습현황"></i>출결/학습현황</button>'
                        		+ '</div>'
                        		+ '<div class="divider m-0 p-0"></div>'
	                        	+ '<div class="card-body">'
									+ '<div class="row">'
										+ '<div class="widget-subheading col-12 pb-2"><b>개설일</b> ' + regDate + ' </div>'
										+ '<div class="widget-subheading col-12 pb-2"><b>종료일</b> ' + closeDate + ' </div>'
									+ '</div>'
								 + '</div>'
							+ '</div>'
                        	+ '</div>'
                        + '</div>';
						
					}
						$(classType).append(html);
						i++;
				});
			}
		}, 
		error: function(data, status,error){
			alert('내 강의실 목록을 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}
function getAllMyClass(){
	var i=0;
	var active, inactive;
	
	$.ajax({
		type: 'post',
		url: "${pageContext.request.contextPath}/getAllMyClass",
		success: function(data){
			 $('.activeClassList').empty();
			active = data.active;
			inactive = data.inactive;
			
			if((active.length + inactive.length) == 0){
				$('.dashboardClass').append('<p class="col text-center">생성된 강의실이 없습니다.</p>');
				$('.classActive').hide();
				$('.classInactive').hide();
				return false;
			}
			
			if(active == null || active.length == 0)
				$('.activeClassList').append('<p class="col text-center">진행중인 강의실이 없습니다! </p>');
			else {
				$(active).each(function(){
					var classID = this.id;
					var className = this.className;
					var howmanyTake;
					var forPublished;
					$.ajax({
						url : "${pageContext.request.contextPath}/member/forHowManyTakes",
						type : "post",
						async : false,
						data: {id : classID},
						success : function(data) {
							howmanyTake = data; 
						},
						error : function() {
							alert("수강생 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요");
						}
					});
					
					$.ajax({
						url : "${pageContext.request.contextPath}/forPublished",
						type : "post",
						async : false,
						data : {classID : classID},
						success : function(data) {
							forPublished = data;
						},
						error : function() {
							alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
						}
					});
					
					$.ajax({
						url : "${pageContext.request.contextPath}/forAll",
						type : "post",
						async : false,
						data : {classID : classID},
						success : function(data) {
							forAll = data;
						},
						error : function() {
							alert('학습현황 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
						}
					});
					
					var classNoticeURL = "'${pageContext.request.contextPath}/notice/" + classID + "'";
					var classCalendarURL = "'${pageContext.request.contextPath}/calendar/" + classID + "'";
					var classContentURL = "'${pageContext.request.contextPath}/class/contentList/" + classID + "'";
					var classAttendanceURL = "'${pageContext.request.contextPath}/attendance/"+ classID + "'";
					var regDate = this.regDate.split(' ')[0];
					var closeDate = this.closeDate;
					var cardColor = active_colors[i%(active_colors.length)]; 
					if(closeDate == null) closeDate = '';
					
					var width;
					if(forPublished == 0)
						width = 0;
					else
						width = Math.floor(forPublished / forAll * 100);
					
					var dashboardCard = '<div class="col-sm-12 col-md-6 col-lg-3">'
											+ '<div class="mb-3 card classCard">'
												+ '<div class="card-header ' + cardColor + '">' 
													+ '<div class="col-sm-8 pr-1">' +  className + ' (' + this.days + ' 차시)' + '</div>'
													+ '<a class="col-sm-2" classID="' + classID + '" className="' + className + '" href="void(0);" onclick="shareClassroomFn(this);" data-toggle="modal" data-target="#shareClassroomModal" class="nav-link">'
														+ '<i class="nav-link-icon fa fa-share" title="강의실 복제"></i>'
													+ '</a>'
													+ '<a class="col-sm-2" href="void(0)"; onclick="editClassroomFn(' + classID + ');" data-toggle="modal" data-target="#setClassroomModal" class="nav-link">'
														+ '<i class="nav-link-icon fa fa-cog" title="강의실 설정"></i>'
													+ '</a>'
												+ '</div>'
												+ '<div class="card-body">'
													+ '<button class="btn btn-outline-focus col-4 mb-2" onclick="location.href=' + classNoticeURL + '"><i class="fa fa-fw fa-bullhorn pr-2" aria-hidden="true" title="공지"></i>공지</button>'
													+ '<button class="btn btn-outline-focus col-2 mb-2" classID="' + classID + '" className="' + className + '" onclick="setPublishNotice(this)" data-toggle="modal" data-target=".publishNoticeModal">'
															+ '<i class="fa fa-fw" aria-hidden="true" title="공지작성"></i></button>'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classCalendarURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="강의캘린더"></i>강의캘린더</button>'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw fa-th-list mr-1" aria-hidden="true" title="강의컨텐츠"></i>강의컨텐츠</button>'
													+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classAttendanceURL + '"><i class="fa fa-fw mr-1" aria-hidden="true" title="출결/학습현황"></i>출결/학습현황</button>'
					                        	+ '</div>'
				                        		+ '<div class="divider m-0 p-0"></div>'
					                        	+ '<div class="card-body">'
													+ '<div class="row">'
														+ '<div class="widget-subheading col-12 pb-2"><b>개설일</b> ' + regDate + ' </div>'
														+ '<div class="widget-subheading col-12 pb-2"><b>종료 설정일</b> ' + closeDate + ' </div>'
														+ '<div class="widget-subheading col pb-2"><b>참여 '+howmanyTake+'명</b></div>'
														+ '<div class="col-12">'
															+ '<div class="mb-3 progress">'
											                	+ '<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: ' + width + '%;">' + forPublished + ' / ' + forAll + '  차시 공개</div>'
											                + '</div>'
														+ '</div>'
													+ '</div>'
												 + '</div>'
				                        	+ '</div>'
				                        + '</div>';
										
						$('.activeClassList').append(dashboardCard);
						i++;
					});
				}
				if(inactive == null || inactive.length == 0)
					$('.inactiveClassList').append('<p class="col text-center">종료된 강의실이 없습니다! </p>');
				else {
					i=0;
					$(inactive).each(function(){
						var id = this.id;
						var classNoticeURL = "'${pageContext.request.contextPath}/notice/" + id + "'";
						var classContentURL = "'${pageContext.request.contextPath}/class/contentList/" + id + "'";
						var classCalendarURL = "'${pageContext.request.contextPath}/calendar/" + id + "'";
						var classAttendanceURL = "'${pageContext.request.contextPath}/attendance/'";
						var regDate = this.regDate.split(' ')[0];
						var closeDate = this.closeDate;
						var cardColor = inactive_colors[i%(inactive_colors.length)]; 
						if(closeDate == null) closeDate = '';
						
						var dashboardCard = '<div class="col-sm-12 col-md-6 col-lg-3">'
												+ '<div class="mb-3 card classCard">'
													+ '<div class="card-header ' + cardColor + '">' 
														+ '<div class="col-sm-8 pr-1">' +  this.className + ' (' + this.days + ' 차시)' + '</div>'
															+ '<a class="col-sm-2" href="void(0);" onclick="shareClassroomFn(this);" classID="' + id + '" className="' + this.className + '" data-toggle="modal" data-target="#shareClassroomModal" class="nav-link">'
															+ '<i class="nav-link-icon fa fa-share" title="강의실 복제"></i>'
														+ '</a>'
														+ '<a class="col-sm-2" href="void(0);" onclick="editClassroomFn(' + id + ');"  data-toggle="modal" data-target="#setClassroomModal" class="nav-link">'
															+ '<i class="nav-link-icon fa fa-cog" title="강의실 설정"></i>'
														+ '</a>'
													+ '</div>'
													+ '<div class="card-body">'
														+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classNoticeURL + '"><i class="fa fa-fw fa-bullhorn pr-2" aria-hidden="true"></i>공지</button>'
														+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classCalendarURL + '"><i class="fa fa-fw pr-3" aria-hidden="true" title="강의캘린더"></i>강의캘린더</button>'
														+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classContentURL + '"><i class="fa fa-fw fa-th-list mr-1" aria-hidden="true" title="강의컨텐츠"></i>강의컨텐츠</button>'
														+ '<button class="btn btn-outline-focus col-6 mb-2" onclick="location.href=' + classAttendanceURL + '"><i class="fa fa-fw mr-1" aria-hidden="true" title="출결/학습현황"></i>출결/학습현황</button>'
					                        		+ '</div>'
					                        		+ '<div class="divider m-0 p-0"></div>'
						                        	+ '<div class="card-body">'
														+ '<div class="row">'
															+ '<div class="widget-subheading col-12 pb-2"><b>개설일</b> ' + regDate + ' </div>'
															+ '<div class="widget-subheading col-12 pb-2"><b>종료일</b> ' + closeDate + ' </div>'
														+ '</div>'
													 + '</div>'
												+ '</div>'
					                        	+ '</div>'
					                        + '</div>';
							$('.inactiveClassList').append(dashboardCard);
							i++;
					});
				}
			},
			error: function(data, status,error){
				alert('내 강의실 목록을 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
			}
		});
	}
function setPublishNotice(item){	//set add notice modal
	var id = item.getAttribute('classID');
	var name = item.getAttribute('className');
	
	$('#inputNoticeForm')[0].reset();
	$('#setNoticeClassName').text(name);
	$('#setNoticeClassID').val(id);
}
	
$(".addClassroomBtn").click(function () {
	$('#formAddClassroom')[0].reset();
});
function shareClassroomFn(item){	//set the share classroom modal
	var id = item.getAttribute('classID');
	var name = item.getAttribute('className');
	$('#shareClassroomID').val(id);
	$('#setShareClassName').text(name);
}
function editClassroomFn(id){	//set the edit classroom modal
	$('#formEditClassroom')[0].reset();
	$('#formEditClassroom').removeClass('was-validated')
	$('#editClassDays').removeClass('is-invalid');
	
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/getClassInfo',
		data: { 'classID' : id },
		success: function(data){
			var days = data.days;
			var closeDate = data.closeDate;
			
			if(days == null) days = 0;
			if(data.active == 0)
				$('#customSwitch2').removeAttr('checked');
			else
				$('#customSwitch2').attr('checked', "");
			
			$('#setClassID').val(id);
			$('#editClassName').val(data.className);
			$('#editDescription').val(data.description);
			$('#editCloseDate').val(closeDate);
			$('#editClassDays').val(days);
			$('#editClassTag').val(data.tag);
		},
		error: function(data, status,error){
			alert('내 강의실 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}
function submitAddClassroom(){
	if ($('#inputClassName').val() == '') return false;
	
	if($('#inputClassDays').val() == '')
		$('#inputClassDays').val(0);
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/insertClassroom',
		data: $('#formAddClassroom').serialize(),
		datatype: 'json',
		success: function(data){
			if(data == 'ok'){
				location.reload();
			}
			else
				alert('강의실 생성에 실패했습니다. 잠시후 다시 시도해주세요:(');
			
		},
		error: function(data, status,error){
			alert('강의실 생성에 실패했습니다. 잠시후 다시 시도해주세요:(');
			return;
		}
	});	
}

function submitEditClassroom(){
	if ($('#editClassName').val() == '') return false;
	var check;
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/class/getBiggestUsedDay',
		data: { classID : $('#setClassID').val()},
		async: false,
		success: function(data){
			if(data != null && $('#editClassDays').val() < data){
				alert('[강의 회차 설정 오류]\n현재 ' +data + '회차까지 강의 컨텐츠가 존재합니다!\n현재 생성된 강의 컨텐츠의 회차와 같거나 더 큰 숫자를 입력해주세요.');
				$('#editClassDays').addClass('is-invalid');
				check = 1;
			}
			else {
				check = 0;
			}
		
		},
		error: function(data, status,error){
			console.log('생성된 강의컨텐츠 갯수 가져오기 실패! ');
		}
	});
	
	if(check != 0) return false;
	
	var today = new Date();
	var year = today.getFullYear();
    var month = today.getMonth()+1;
    var day = today.getDate();
	
	if ((day + "").length < 2) day = "0" + day;
	today = year + "-" +  month + "-" + day;
	
	var closeDate = $('#editCloseDate').val();
	
	if($('#customSwitch2').is(':checked') && closeDate != '' && (today >= closeDate)){
		if(confirm('강의실 종료일이 오늘 날짜보다 빠르거나 같습니다. 지금 바로 강의실을 종료 하시겠습니까? \n취소 버튼을 누르면 강의실 설정으로 돌아갑니다.')){
			$('#customSwitch2').prop('checked', false);
			$('#customSwitch2').val(0);
			$('#editCloseDate').val(today);
		}	
		else return false;
	}
	
	if($('#editClassDays').val() == '')
		$('#editClassDays').val(0);
	
	if($('#customSwitch2').is(':checked'))
		$('#customSwitch2').val(1);	
	else {
		$('#customSwitch2').val(0);
		if($('#editCloseDate').val() == '')	
			$('#editCloseDate').val(today);
	}
	
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/editClassroom',
		data: $('#formEditClassroom').serialize(),
		datatype: 'json',
		success: function(data){
			if(data == 'ok'){
				alert('강의실 수정이 완료되었습니다.');
			}
			else
				alert('강의실 수정에 실패했습니다. 잠시후 다시 시도해주세요:(');
			location.reload();
		},
		error: function(data, status,error){
			alert('강의실 수정에 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}

function submitDeleteClassroom(){
	var opt = $('input[name=deleteOpt]:checked').val();
	if(opt == null){
		alert('강의실 삭제 옵션을 선택해 주세요.');
		return false;
	}
	if(opt == 'forMe'){
		var today = new Date();
		var year = today.getFullYear();
	    var month = today.getMonth()+1;
	    var day = today.getDate();
		
		if ((day + "").length < 2) day = "0" + day;
	    
		today = year + "-" +  month + "-" + day;
		
		if(confirm('나에게만 강의실이 삭제되고 학생들에게는 종료된 강의실로 전환됩니다. \n삭제된 데이터는 다시 복구될 수 없습니다. \n삭제 하시겠습니까?')){
			$.ajax({
				type: 'post',
				url: '${pageContext.request.contextPath}/deleteForMe',
				data: {
					'id' : $('#setClassID').val(),
					'date' : today
					},
				datatype: 'json',
				success: function(data){
				},
				complete: function(data){
					alert('나에게만 강의실 삭제가 완료되었습니다!');
					location.reload();
				},
				error: function(data, status,error){
					alert('강의실 삭제에 실패했습니다. 잠시후 다시 시도해주세요:(');
				}
			});
		}
	}
	else if(opt == 'forAll'){
		if(confirm('강의실의 모든 데이터가 삭제되어 학생들에게도 강의실이 삭제됩니다. \n삭제된 데이터는 다시 복구될 수 없습니다. \n삭제 하시겠습니까?')){
			$.ajax({
				type: 'post',
				url: '${pageContext.request.contextPath}/deleteForAll',
				data: {'id' : $('#setClassID').val()},
				datatype: 'json',
				success: function(data){
				},
				complete: function(data){
					alert('강의실 삭제가 완료되었습니다!');
					location.reload();
				},
				error: function(data, status,error){
					alert('강의실 삭제에 실패했습니다. 잠시후 다시 시도해주세요:(');
				}
			});
		}
	}
}
function submitShareClassroom(){
	var calendar = $('#copyCalendar').is(":checked");
	var content = $('#copyContent').is(":checked");
	if(calendar != true && content != true){
		alert('최소 하나의 복제 항목을 선택해주세요.')
		return false;
	}
	if(calendar == true) calendar = 1;
	else calendar = 0;
	
	if(content == true) content = 1;
	else content = 0;
	
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/copyClassroom',
		data: {
			'id' : $('#shareClassroomID').val(),
			'calendar' : calendar,
			'content' : content
			},
		datatype: 'json',
		success: function(data){
			if(data == 1)
				console.log('강의실 복사 성공');
		},
		complete: function(data){
			alert('강의실 복제가 완료되었습니다.');
			location.reload();
		},
		error: function(data, status,error){
			alert('강의실 복제애 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}

function publishNotice(){
	if($('#inputTitle').val() == '' ) return false;
	if ($('#inputImportant').val() == 'on')
		$('#inputImportant').val(1);
	else
		$('#inputImportant').val(0);
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/addNotice',
		data: $('#inputNoticeForm').serialize(),
		datatype: 'json',
		success: function(data){
		},
		complete: function(data){
			location.reload();
		},
		error: function(data, status,error){
			alert('공지 작성에 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}
</script>
<body>
    <div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
        <jsp:include page="../outer_top.jsp" flush="true"/>       
             
        <div class="app-main">  
        	<jsp:include page="../outer_left.jsp" flush="false"></jsp:include>
                 <div class="app-main__outer">
                    <div class="app-main__inner">
                        <div class="app-page-title">
                            <div class="page-title-wrapper">
                                <div class="page-title-heading mr-3">
                                  	<h3>내 강의실
                                  		<button class="btn btn-primary mr-3" data-toggle="modal" data-target="#addClassroomModal" id="addClassroomBtn">
		                            		<b>+</b> 강의실 생성
		                               </button>
                                  	</h3> 	
                                </div>
                          	</div>
                        </div>      
                       
                        <div class="dashboardClass">
                        	<div class="classActive row">
                        		<div class="col-12 row m-1">
                        			<h4 class="">진행중인 강의실</h4>
                        			
	                        		<div class="dropdown d-inline-block pl-2">
			                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
			                           <div aria-labelby="dropdownMenuButton" class="dropdown-menu">
			                               <button type="button" class="dropdown-item" onclick="getAllClass(1, 'regDate');">개설일순</button>
			                               <button type="button" class="dropdown-item" onclick="getAllClass(1, 'className');">이름순</button>
			                           </div>
			                       </div>
                        		</div>
                        		<div class="activeClassList row col"></div>
                        	</div>
                            <div class="classInactive row">
                            	<div class="col-12 row m-1">
                        			<h4 class="">종료된 강의실</h4>
	                        		<div class="dropdown d-inline-block pl-2">
			                           <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="mb-2 mr-2 dropdown-toggle btn btn-light">정렬</button>
			                           <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
			                               <button type="button" tabindex="0" class="dropdown-item" onclick="getAllClass(0, 'regDate');">개설일순</button>
			                               <button type="button" tabindex="0" class="dropdown-item" onclick="getAllClass(0, 'className');">이름순</button>
			                           </div>
			                       </div>
                            	</div>
	                            <div class="inactiveClassList row col"></div>
	                        </div>
                    	</div>
                   <jsp:include page="../outer_bottom.jsp" flush="true"/>
              </div>
        </div>
    </div>
   </div>
   
   <!-- copy classroom -->
   <div class="modal fade bd-example-modal-sm" id="shareClassroomModal" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog modal-sm">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle"><span id="setShareClassName" class="text-primary"></span> - 강의실 복제</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">
	               <input id="shareClassroomID" type="hidden" value="">
                        <h6 class="title">복제 데이터 선택</h6>
                        <div class="col">                
                            <div class="form-group">
                                <div class="form-check">
                                    <input id="copyCalendar" type="checkbox" class="form-check-input">
                                    <label class="form-check-label" for="copyCalendar">
                                        강의캘린더
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input id="copyContent" type="checkbox" class="form-check-input">
                                    <label class="form-check-label" for="copyContent">
                                        강의컨텐츠
                                    </label>
                                </div>
                            </div>
                        </div>
                   
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
	                <button type="button" class="btn btn-primary" onclick="submitShareClassroom();">복제</button>
	            </div>
	        </div>
	    </div>
	</div>

	<!-- modal for add classroom -->    
	<div class="modal fade" id="addClassroomModal" tabindex="-1" role="dialog" aria-labelledby="addClassroomModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="setClassroomModalLabel">강의실 생성</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <form class="needs-validation" id="formAddClassroom" method="post" novalidate>
		            <div class="modal-body">
		               <div class="position-relative form-group">
		               		<label for="inputClassName" class="">강의실 이름</label>
		               		<input name="className" id="inputClassName" type="text" class="form-control" required autofocus>
		               		<div class="invalid-feedback">강의실 이름을 입력해주세요</div>	
		               </div>
		               <div class="position-relative form-group">
		               		<label for="inputDescription" class="">강의실 설명</label>
		               		<textarea name="description" id="inputDescription" class="form-control" rows="4"></textarea>
		               </div>
		               <div class="form-row">
		               		<div class="col-md-3">
			                   <div class="position-relative form-group">
			                   		<label for="inputClassDays" class="">강의 횟수</label>
				               		<input name="days" id="inputClassDays" type="number" class="form-control" min="0">
			                   </div>
		                   	</div>
		                   	
							<div class="col-md-9">
			                   <div class="position-relative form-group">
				               		<label for="inputClassTag" class="">태그</label>
				               		<input name="tag" placeholder="21겨울캠프, 공동체" id="inputTag" type="text" class="form-control">
				               </div>
			               	</div>
	                   </div>
	                   <div class="form-group"> 
			        		<label for="inputCloseDate">강의실 종료 설정</label>
			        		<input type="date" name="closeDate" class="form-control" id="inputCloseDate"/>
			        	</div> 
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		                <button type="submit" form="formAddClassroom" class="btn btn-primary" onclick="submitAddClassroom();">생성</button>
		            </div>
	            </form>
	            
	        </div>
	    </div>
	</div>
	
	<!-- edit classroom modal -->
    <div class="modal fade" id="setClassroomModal" tabindex="-1" role="dialog" aria-labelledby="setClassroomModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="setClassroomModalLabel">강의실 설정</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <form class="needs-validation" id="formEditClassroom" method="post" onsubmit="return false;" novalidate>
		            <input id="setClassID" name="id" type="hidden" value="">
		            <div class="modal-body">
		               <div class="position-relative form-group">
		               		<label for="editClassName" class="">강의실 이름</label> 
		               		<input name="className" id="editClassName" type="text" class="form-control" required>
		               		<div class="invalid-feedback">강의실 이름을 입력해주세요</div>	
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editDescription" class="">강의실 설명</label>
		               		<textarea name="description" id="editDescription" class="form-control" rows="4"></textarea>
		               </div>
		               <div class="form-row">
		               		<div class="col-md-3">
			                   <div class="position-relative form-group">
			                   		<label for="editClassDays" class="">강의 횟수</label>
				               		<input name="days" id="editClassDays" type="number" class="form-control" min="0" required>
				               		<div class="invalid-feedback">강의 횟수를 다시 설정해주세요</div>	
			                   </div>
		                   	</div>
		                   	
							<div class="col-md-9">
			                   <div class="position-relative form-group">
				               		<label for="editClassTag" class="">태그</label>
				               		<input name="tag" id="editClassTag" type="text" class="form-control">
				               </div>
			               	</div>
	                   </div>
	                   
	                   <div class="form-group"> 
			        		<label for="inputCloseClassroom">강의실 종료 설정</label>
			        		<input type="date" name="closeDate" class="form-control" id="editCloseDate"/>
			        	</div> 
			        	<div class="custom-control custom-switch">
				            <input type="checkbox" checked="" name="active" class="custom-control-input" id="customSwitch2">
				            <label class="custom-control-label" for="customSwitch2">강의실 진행중</label>
				        </div>
				    </div>
				    <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		                <button type="submit" form="formEditClassroom" class="btn btn-primary" onclick="submitEditClassroom();">수정완료</button>
		            </div>
	            </form>
	            
                   <div class="modal-body">
			        	<div class=""><h6 class="text-danger">Danger Zone - 강의실 나가기</h6></div>
			        	<div class="border border-danger p-3">
				        	<form id="deleteForm" class="needs-validation" novalidate>
					        	<div class="position-relative form-group">
	                                 <div>
	                                     <div class="custom-radio custom-control">
	                                     	<input type="radio" id="exampleCustomRadio" name="deleteOpt" class="custom-control-input" value="forMe" required>
	                                     	<label class="custom-control-label" for="exampleCustomRadio">나에게만 삭제 - 학생들에게는 종료된 강의실로 보여집니다.</label>
	                                     </div>
	                                     <div class="custom-radio custom-control">
	                                     	<input type="radio" id="exampleCustomRadio2" name="deleteOpt" class="custom-control-input" value="forAll">
	                                     	<label class="custom-control-label" for="exampleCustomRadio2">모든 데이터 삭제 - 학생들에게도 강의실이 삭제됩니다.</label>
	                                     </div>
	                                 </div>
	                             </div>
				        	</form>
                             <div class="row">
                             	<div class="col-12">
						        	<button type="submit" form="formEditClassroom" class="btn btn-danger" onclick="submitDeleteClassroom();">강의실 삭제</button>
						        </div>
				        	</div>
                        </div>  
		            </div>
		         </div>
	        </div>
	    </div>
	    
	   <!-- 공지 게시글 작성 modal -->
   	<div class="modal fade publishNoticeModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog modal-lg">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle"><span id="setNoticeClassName" class="text-primary"></span> - 새로운 공지 작성</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">  
	                <div class="main-card">
						<div class="card-body">
                            <form class="needs-validation" id="inputNoticeForm" method="post" novalidate>
                            	<input type="hidden" name="classID" value="" id="setNoticeClassID"/>
                                <div class="position-relative row form-group">
                                	<label for="inputTitle" class="col-sm-2 col-form-label">제목</label>
                                    <div class="col-sm-10">
                                    	<input name="title" id="inputTitle" placeholder="제목을 입력하세요" type="text" class="form-control" required>
                                    	<div class="invalid-feedback">제목을 입력해 주세요</div>
                                    </div>
                                </div>
                                <div class="position-relative row form-group">
                                	<label for="content" class="col-sm-2 col-form-label">내용</label>
                                    <div class="col-sm-10">
                                    	<textarea id="inputContent" name="content" class="form-control" rows="7"></textarea>
                                    </div>
                                </div>
                                <div class="position-relative row form-group"><label for="checkbox2" class="col-sm-2 col-form-label">상단 고정</label>
                                    <div class="col-sm-10 mt-2">
                                        <div class="position-relative form-check">
                                        	<input id="inputImportant" name="pin" type="checkbox" class="form-check-input">
                                        </div>
                                    </div>
                                </div>
                            </form>
                          </div>
                      </div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" form="inputNoticeForm" class="btn btn-primary" onclick="publishNotice();">등록</button>
	            </div>
	        </div>
	    </div>
	</div>

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
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Language" content="en">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>강의 캘린더</title>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
	<meta name="msapplication-tap-highlight" content="no">
	
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css'rel='stylesheet' />
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.37/js/bootstrap-datetimepicker.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
	<script src="https://cdn.jsdelivr.net/npm/@fullcalendar/interaction@4.2.0/main.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<style>
	#addAllday, #setAllday{
		width: 15px;
		margin: auto;
	}
	.fc-col-header, .fc-daygrid-body { width: 100% !important; }
	.fc-daygrid-body {width: 100% !important;}
	.fc-scrollgrid-sync-table {width: 100% !important;}
	
	.fc-daygrid-body { table { width: 100% !important; } }
	
	.fc-today-button .fc-button .fc-button-primary{
		margin: auto;
	}
</style>
<script>
	var calendar;
	var g_arg;

	(function() {
		$(function() {
			var calendarEl = $('#calendar1')[0];
			calendar = new FullCalendar.Calendar(calendarEl, {
				height : '600px', 
				expandRows : true, 
				slotMinTime : '08:00', 
				slotMaxTime : '20:00', 
				headerToolbar : {
					left : 'prev,next today',
					center : 'title',
					right : 'dayGridMonth,timeGridWeek,listWeek'
				},
				initialView : 'dayGridMonth', 
				navLinks : true, 
				editable : true,
				selectable : true, 
				nowIndicator : true, 
				dayMaxEvents : true, 
				locale : 'ko',
				events : function(info, callback, fail) {
					$.ajax({
							url: '${pageContext.request.contextPath}/calendar/getScheduleList/' + '${classID}',
							method: 'get',
							success : function(result){
									var events = [];
									
									if (result != null){
										$.each(result, function(index, element) {	
				                           	var allday = false;
				                           	if(element.allday == 1) allday = true;
				                           	
			                                events.push({
				                                   id: element.id,
			                                       title: element.name,
			                                       start: element.date,
			                                       allDay: allday,
			                                       description: element.memo
			                                       //color:"#6937a1"                                                   
			                                    });  
					                       }); 
									}
									callback(events); 
								}
						});
				},
				eventDrop: function(arg){
					var date = arg.event.startStr.split('+')[0];
					$.ajax({
						type: 'post',
						url: '${pageContext.request.contextPath}/calendar/changeDate',
						data: {
								id : arg.event.id,
								date : date
							},
						datatype: 'json',
						success: function(data){
							console.log('change date 성공!');
						},
						error: function(data, status,error){
							alert('일정 수정 실패<br>잠시후 다시 시도 해주세요:(');
						}
					});	
				 },
				eventClick: function(obj) {
					udpateEventModal(obj);
				},
				select: function (startDate, endDate, jsEvent, view) {	//하나 혹은 드래그 해서 일정을 선택했을 때
					$('#addEventForm')[0].reset();
					$('#addDate').val(startDate.startStr);
					$('#addEventModal').modal('show');
					
				},
			});
			calendar.render();
			
		});
	})();

	function stringFormat(p_val){
		if(p_val == '')
			return '00';
		else if(p_val < 10)
			return p_val = '0'+p_val;
		else
			return p_val;
	  }

	function udpateEventModal(obj){
		g_arg = obj;

		if(obj.event.allDay == true) 
			$('#setAllday').prop('checked', true);
		else
			$('#setAllday').prop('checked', false);
		$('#setID').val(obj.event.id);
		$('#setName').val(obj.event.title);
		$('#setDate').val(obj.event.startStr.split("T")[0]);
		$('#setHour').val(obj.event.start.getHours());
		$('#setMin').val(obj.event.start.getMinutes());
		$('#setMemo').val(obj.event.extendedProps.description);
		$('#eventModal').modal('show');
	}

	function addEvent(){
		if($('#addName').val() == '' || $('#addName').val() == null) return false;
		
		var newDate = $('#addDate').val() + "T" + stringFormat($('#addHour').val()) + ":" + stringFormat($('#addMin').val()) + ":00";
		$('#addHiddenDate').val(newDate);

		var allday = $('input:checkbox[id="addAllday"]').is(":checked");
		if (allday == true) $('#addAllday').val(1);
		else $('#setAllday').val(0);

		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/calendar/insertEvent',
			data: $('#addEventForm').serialize(),
			success: function(newID){
				calendar.addEvent({
				    id: newID,
					title: $('#addName').val(),
					start: newDate + "+09:00",
					allDay: allday
				  });
				$('#addEventForm')[0].reset();
				$('#addEventForm').removeClass('was-validated')
				$('#addEventModal').modal('hide');
			},
			error: function(data, status,error){
				alert('일정 생성 실패<br>잠시후 다시 시도 해주세요:(');
			}
		});
	}

	function updateEvent(arg){
		if($('#setName').val() == '' || $('#setName').val() == null) return;
		
		var newDate = $('#setDate').val() + "T" + stringFormat($('#setHour').val()) + ":" + stringFormat($('#setMin').val()) + ":00";
		$('#hiddenDate').val(newDate);

		var allday = $('input:checkbox[id="setAllday"]').is(":checked");
		if (allday == true) $('#setAllday').val(1);
		else $('#setAllday').val(0);

		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/calendar/updateEvent',
			data: $('#eventForm').serialize(),
			
			success: function(data){
				arg.event.setProp('title', $('#setName').val());
				arg.event.setStart(newDate);
				arg.event.setEnd(null);
				arg.event.setAllDay(allday);
				arg.event.setExtendedProp('description', $('#setMemo').val());
				
			},
			error: function(data, status,error){
				alert('일정 수정 실패<br>잠시후 다시 시도 해주세요:(');
			}
		});
		
	}

	function deleteEvent(arg){
		if(confirm('일정을 삭제하시겠습니까?')){
			$.ajax({
			  url: '${pageContext.request.contextPath}/calendar/deleteEvent',
			  type: 'post',
			  data: { id : arg.event.id},
			  traditional: true,
			  success : function(data, status, xhr){
				  arg.event.remove();
			  },
			  error : function(xhr, status, error){
				  alert('일정 삭제 실패<br>잠시후 다시 시도 해주세요:(');
			  }
			});
		}
	}
</script>
<script>
// Disable form submissions if there are invalid fields
(function() {
  'use strict';
  window.addEventListener('load', function() {
    // Get the forms we want to add validation styles to
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
<style>
.fc-daygrid-event-harness {
	overflow: hidden;
}
</style>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="../outer_top.jsp" flush="false" />

		<div class="app-main">
			<jsp:include page="../outer_left.jsp" flush="false">
				<jsp:param name="className" value="${className}" />
				<jsp:param name="menu" value="calendar" />
			</jsp:include>

			<div class="app-main__outer">
				<div class="app-main__inner">
					<div class="app-page-title">
						<div class="page-title-wrapper">
							<div class="page-title-heading mr-3">
								<h4>
									<span class="text-primary displayClassName">${className}</span>
									- 강의캘린더
								</h4>
							</div>
						</div>
					</div>
					<div class="main-card mb-3 card">
						<div class="card-body">
							<div class="calendar-wrap">
								<div id="calendar1"></div>

							</div>
						</div>
					</div>

					<jsp:include page="../outer_bottom.jsp" flush="false" />
				</div>
			</div>
		</div>
	</div>

<!-- 이벤트 생성 modal -->
<div class="modal fade show" id="addEventModal" tabindex="-1" role="dialog" aria-modal="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">새로운 일정 등록</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <form id="addEventForm" class="needs-validation" onsubmit="return false;" method="post" novalidate>
	            <div class="modal-body">
	            	<input type="hidden" name="classID" id="addClassID" value="${classID}">
	            	
	                <div class="form-group row">
	                	<div class="col-9">
							<div class="position-relative form-group">
								<label>일정명</label> 
								<input type="text" class="form-control" name="name" id="addName" required>
								<div class="invalid-feedback">일정명을 입력해 주세요</div>
							</div>
						</div>
						<div class="col-3">
							<div class="position-relative form-group">
								<label>하루종일</label> 
								<input type="checkbox" class="form-control" name="allday" id="addAllday">
							</div>
						</div>
						
					</div>
					<div class="form-group row">
						<input type="hidden" name="date" id="addHiddenDate">
						<div class="col-6">
							<div class="position-relative form-group">
								<label>날짜</label> 
								<input type="date" class="datetimepicker form-control" id="addDate" required>
							</div>
						</div>
						<div class="col-3">
							<div class="position-relative form-group">
								<label>시</label> 
								<input type="number" class="form-control" id="addHour">
							</div>
						</div>
						<div class="col-3">
							<div class="position-relative form-group">
								<label>분</label> 
								<input type="number" class="form-control" id="addMin">
							</div>
						</div>
					</div>
					<div class="form-group">
						<label>메모</label>
						<textarea class="form-control" name="memo" id="addMemo"></textarea>
					</div>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" class="btn btn-primary" onclick="addEvent();">등록</button>
	            </div>
            </form>
        </div>
    </div>
</div>

<!-- 이벤트 수정 modal -->
<div class="modal fade show" id="eventModal" tabindex="-1" role="dialog" aria-modal="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">일정 수정</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <form id="eventForm" class="needs-validation" onsubmit="return false;" method="post" novalidate>
	            <div class="modal-body">
	            	<input type="hidden" name="id" id="setID">
	            	
	                <div class="form-group row">
	                	<div class="col-sm-10">
							<div class="position-relative form-group">
								<label>일정명</label> 
								<input type="text" class="form-control" name="name" id="setName" required>
								<div class="invalid-feedback">일정명을 입력해 주세요</div>
							</div>
						</div>
						<div class="col-sm-2">
							<div class="position-relative form-group">
								<label>하루종일</label> 
								<input type="checkbox" class="form-control" name="allday" id="setAllday">
							</div>
						</div>
						
					</div>
					<div class="form-group row">
						<input type="hidden" name="date" id="hiddenDate">
						<div class="col-sm-6">
							<div class="position-relative form-group">
								<label>날짜</label> 
								<input type="date" class="datetimepicker form-control" id="setDate" required>
							</div>
						</div>
						<div class="col-sm-3">
							<div class="position-relative form-group">
								<label>시</label> 
								<input type="number" class="form-control" min="0" max="23" id="setHour">
							</div>
						</div>
						<div class="col-sm-3">
							<div class="position-relative form-group">
								<label>분</label> 
								<input type="number" class="form-control" min="0" max="59" id="setMin">
							</div>
						</div>
					</div>
					<div class="form-group">
						<label>메모</label>
						<textarea class="form-control" name="memo" id="setMemo"></textarea>
					</div>
	            </div>
	            <div class="modal-footer">
	            	<button type="button" class="btn btn-danger" data-dismiss="modal" onclick="deleteEvent(g_arg);">삭제</button>
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" class="btn btn-primary" data-dismiss="modal" onclick="updateEvent(g_arg);">업데이트</button>
	            </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
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
	
	.fc-today-button{
		margin: auto;
	}
</style>
<script>
	var calendar;

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
			                                       title: element.name,
			                                       start: element.date,
			                                       allDay: allday,
			                                       description: element.memo
			                                       //color:"#6937a1"                                                   
			                                    });  
					                       }); 
									}
									callback(events); 
								},
								error: function(error){
									alert('강의실 일정 목록을 가져오는데 실패했습니다. 잠시후 다시 시도 해주세요:(');
								}
						});
				},
				eventClick: function(obj) {
					udpateEventModal(obj);
				}
			});
			calendar.render();
		});
	})();

	function udpateEventModal(obj){
		if(obj.event.allDay == true) 
			$('#setAllday').prop('checked', true);
		else
			$('#setAllday').prop('checked', false);
		$('#setName').text(obj.event.title);
		$('#setDate').val(obj.event.startStr.split("T")[0]);
		$('#setHour').text(obj.event.start.getHours());
		$('#setMin').text(obj.event.start.getMinutes());
		$('#setMemo').text(obj.event.extendedProps.description);
		$('#eventModal').modal('show');
	}
</script>
<style>
.fc-daygrid-event-harness {
	overflow: hidden;
}
</style>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="../outer_top_stu.jsp" flush="false" />

		<div class="app-main">
			<jsp:include page="../outer_left_stu.jsp" flush="false">
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

<!-- 이벤트 수정 modal -->
<div class="modal fade show" id="eventModal" tabindex="-1" role="dialog" aria-modal="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">일정 내용</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">
            	<input type="hidden" name="id" id="setID">
            	
                <div class="form-group row">
                	<div class="col-sm-10">
						<div class="position-relative form-group">
							<label>일정명</label> 
							<p class="form-control" id="setName"></p>
						</div>
					</div>
					<div class="col-sm-2">
						<div class="position-relative form-group">
							<label>하루종일</label> 
							<input type="checkbox" class="form-control" id="setAllday" disabled>
						</div>
					</div>
					
				</div>
				<div class="form-group row">
					<input type="hidden" name="date" id="hiddenDate">
					<div class="col-sm-6">
						<div class="position-relative form-group">
							<label>날짜</label> 
							<input type="date" class="datetimepicker form-control" id="setDate" readonly>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="position-relative form-group">
							<label>시</label> 
							<p class="form-control" id="setHour"></p>
						</div>
					</div>
					<div class="col-sm-3">
						<div class="position-relative form-group">
							<label>분</label> 
							<p class="form-control" id="setMin"></p>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label>메모</label>
					<p class="form-control" id="setMemo" style="height: 100px;"></p>
				</div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
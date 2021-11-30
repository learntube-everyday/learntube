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
    <title>강의컨텐츠</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="msapplication-tap-highlight" content="no">
    
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
</head>
<style>
.selectPlaylist{
	overflow-y: scroll; 
	height: 50vh;
}
#client-paginator {
  position: relative;
  overflow-y: hidden;
  overflow-x: scroll;
}
.pagination {
  display: table !important;
}
.pagination>li {
  display: table-cell !important;
}
</style>
<script>
var addContentFormOpened = 0;

$(document).ready(function(){
	setAllContents();	//선택한 class의 학습 컨텐츠 리스트 띄우기
	
	$(document).on("click", "button[name='selectPlaylistBtn']", function () {	//playlist 선택버튼 눌렀을 때 modal창 오픈	
		$.ajax({
			type : 'post',
			url : '${pageContext.request.contextPath}/playlist/getAllMyPlaylist',
			success : function(result){
				playlists = result.allMyPlaylist;
				if (playlists == null)
					$('.myPlaylist').append('저장된 playlist가 없습니다.');

				else{
					$('.myPlaylist').empty();
					var setFormat = '<div class="card">'
										+ '<div class="card-body">'
										+ '<div class="card-title input-group">'
										+ '<form id="searchForm" onsubmit="return search(event);" method="post">'
										+ '<div class="card-title input-group">'
											+ '<input placeholder="검색어를 입력하세요" type="hidden" id="searchType" name="searchType" class="mb-2 form-control" value="0">'
											+ '<input id="keyword" name="keyword" placeholder="검색어를 입력하세요" type="text" class="form-control">'   	
											+ '<div class="input-group-append p-0">'
												+ '<button class="btn btn-secondary" type="submit">검색</button>'
											+ '</div>'
											+ '</div>'                   
										+ '</form>'										
										+ '</div>'
										+ '<form class="selectPlaylist"><fieldset class="allPlaylist position-relative form-group"></fieldset></form>'
									+ '</div>'
								+ '</div>';
								
					$('.myPlaylist').append(setFormat);
							
					$.each(playlists, function( index, value ){
						var contentHtml = '<div class="playlist list-group-item-action list-group-item position-relative form-check">'
											+ '<label class="form-check-label pl-3">' 
												+ '<input name="playlist" type="radio" class="form-check-input" value="' + value.id + '">'
												+ value.playlistName + ' / ' + convertTotalLength(value.totalVideoLength) 
											+ '</label>'
										+ '</div>';

	                	$('.allPlaylist').append(contentHtml);
					});
				}
				//$('#selectPlaylistModal').modal('show');
				
			}, error:function(request,status,error){
				console.log("playlist를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요 :(");
			}
		});
	})
	
});

//tag로 playlist 및 영상 찾기:
var keyword = null;

function search(event) {
	
	event.preventDefault(); // avoid to execute the actual submit of the form.

	/* if (keyword != null) {
		keyword.forEach(function(element) {
			//$("[tag*='"+ element + "']").css("background-color", "#d9edf7;"); 
			$("[playlistName*='" + element + "']").css("background-color", "white");
		});
	}

	keyword = $("#keyword").val();
	keyword = keyword.replace(/ /g, '').split(",");

	keyword.forEach(function(element) {
		//$("[tag*='"+ element + "']").css("background-color", "yellow");
		$("[playlistname*='" + element + "']").css("background-color","#d9edf7;");
	}); */
	

	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/playlist/searchPlaylist',
		data: $("#searchForm").serialize(),
		success: function(data){
			// playlistid 를 가져오면 
			// 그걸로 해당하는 attribute를 가지는 애들만 색갈 변경해주기 .
			console.log('playlist 검색 완료!');
			
			var playlists = data.searched;

			/* $.each(list, function(index, value){
				console.log(list[index].id);
			}); */
			$('.allPlaylist').empty();
			console.log(playlists);
			
			$.each(playlists, function( index, value ){
				var contentHtml = '<div class="playlist list-group-item-action list-group-item position-relative form-check">'
									+ '<label class="form-check-label pl-3">' 
										+ '<input name="playlist" type="radio" class="form-check-input" value="' + value.id + '">'
										+ value.playlistName + ' / ' + convertTotalLength(value.totalVideoLength) 
									+ '</label>'
								+ '</div>';

            	$('.allPlaylist').append(contentHtml);
			});
		},
		error: function(data, status,error){
			alert('playlist 검색 실패! ');
		}
	});
}

	
	function setAllContents(){
		var allContents = JSON.parse('${allContents}'); 
		var allFileContents = JSON.parse('${allFileContents}'); 
		var realAllContents =  JSON.parse('${realAllContents}');
		
		var videoLength;
		var symbol;
		
		$.ajax({ 
			url : "${pageContext.request.contextPath}/member/forHowManyTakes",
			type : "post",
			async : false,
			data: {id : '${classInfo.id}'},
			success : function(data) {
				howmanyTake = data; 
			},
			error : function() {
				console.log("수강중인 학생 수를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요 :(");
			}
		})
		
		var lastDays;
		var daySeq = 1;	//각 차시별 seq
		for(var i=0; i<realAllContents.length; i++){
			if(realAllContents[i].playlistID == 0){
				symbol = '<i class="pe-7s-note2 fa-lg"></i>'
				videoLength = '';
			}
			else{
				symbol = '<i class="pe-7s-film fa-lg" style=" color:dodgerblue"> </i>'
				
				for(var j=0; j<allContents.length; j++){
					if(realAllContents[i].playlistID == allContents[j].playlistID)
						videoLength = " [" + convertTotalLength(allContents[j].totalVideoLength) + "] ";
				}
				
				$.ajax({ 
					url : "${pageContext.request.contextPath}/class/forHowManyWatch",
					type : "post",
					async : false,
					data : {	
						playlistID : realAllContents[i].playlistID
					},
					success : function(data) {
						howmanyCount = data; //data는 video랑 videocheck테이블 join한거 가져온다 => video랑 classContent join한거 
					},
					error : function() {
						console.log("학습한 학생 수를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요 :(");
					}
				});
				
			}
				
			var day = realAllContents[i].days;
			
			if(day != lastDays){
				lastDays = day;
				daySeq = 1;
			}
			else daySeq += 1;
			
			var endDate = realAllContents[i].endDate;
			if(endDate == null || endDate == '')
				endDate = '';
			else {
				endDate = realAllContents[i].endDate.split(":");
				endDate = endDate[0] + ":" + endDate[1];	
				endDate = '<p class="endDate contentInfo"">마감일: ' + endDate + '</p>';
			}

			
			localStorage.setItem("endDate", endDate);
			
			var content = $('.list-group:eq(' + day + ')'); //한번에 contents를 가져왔기 때문에, 각 content를 해당 주차별 차시 순서에 맞게 나타나도록
			var goDetail = 'moveToContentDetail(' + realAllContents[i].id + ',' + i + ');';
			var thumbnail = '<img src="https://img.youtube.com/vi/' + realAllContents[i].thumbnailID + '/0.jpg" class="inline videoPic">';
			var published;
			var percentage = '';
			if (realAllContents[i].published == true){
				published = '<input type="checkbox" checked data-toggle="toggle" data-onstyle="primary" class="custom-control-input" class="switch" name="published">'
								+ '<label class="custom-control-label" for="switch">공개</label>';
			}
			else{
				published = '<label class="custom-control-label" for="switch">비공개</label>'
								+ '<input type="checkbox" checked data-toggle="toggle" data-onstyle="danger" class="custom-control-input" class="switch" name="published" >';
				percentage = '';
			}
			
			if(howmanyTake == null){
				percentage = '% 완료';
			}
			if (realAllContents[i].published == true && realAllContents[i].playlistID != 0)
				percentage = Math.floor(howmanyCount/howmanyTake*100) + '% 완료';
			
			content.append(
				"<div class='content list-group-item-action list-group-item' seq='" + daySeq + "'>"
						+ '<div class="row col d-flex justify-content-between align-items-center">'
							+ '<div class="row col-sm-2">'
								+ '<div class="index col-6 pt-1">' + daySeq + '. </div>'
								+ '<div class="videoIcon col-6" style="font-size:25px;">' + symbol + '</div>' //playlist인지 url인지에 따라 다르게
							+ '</div>'
							+ "<div class='col-sm-6 align-items-center' onclick=" + goDetail + " style='cursor: pointer;'>"
									+ "<div class='col-sm-12 card-title' style='height: 50%; font-size: 15px; padding: 15px 0px 0px;'>"
										+ realAllContents[i].title  + " " + videoLength 
									+ '</div>'		
									+ '<div class="align-items-center" style="padding: 5px 0px 0px;">'
										+ '<div class="contentInfoBorder"></div>'
										+ '<div class="contentInfoBorder"></div>'
										+ endDate
									+ '</div>' 
							+ '</div>'
							+ '<div class="col-sm-2 text-success">' + percentage + '</div>'
								+ '<div class=" col-sm-2 text-center d-flex custom-control custom-switch pl-5 m-2">'
									+ '<input type="checkbox" id="exampleCustomCheckbox'+i+'" name= "exampleCustomCheckbox" class="custom-control-input exampleCustomCheckbox pl-5 m-2" onchange="YNCheck(this, '+realAllContents[i].id +')">'
										+ '<label class="custom-control-label" for="exampleCustomCheckbox' +i+ '"></label>'
								+ '</div>'
						+ '</div>'
				+ "</div>");
			
			var publishedCheck = realAllContents[i].published;
			if(publishedCheck == 1){
				$("input:checkbox[id='exampleCustomCheckbox"+i+"']").prop("checked", true); 
			}
			else{
				$("input:checkbox[id='exampleCustomCheckbox"+i+"']").prop("checked", false);  
			}
		}
	}	
	
	function YNCheck(obj, id){
		console.log("id : "+ id);
		var checked = obj.checked;
		var published;
		if(checked){
			obj.value = "Y";
			published = 1;
			console.log("Y" + published);
		}
		else{
			obj.value = "N";
			published = 0;
			console.log("N" + published);
		}
		
		$.ajax({
			type : 'post',
			url : '../updatePublished',
			data : {id : id, published : published}, //id도 같이 보내야함..
			datatype : 'json',
			success : function(result){
				location.reload();
			}
		});

	}

	function showAddContentForm(day){
		if(addContentFormOpened != 0) return false;
		addContentFormOpened = 1;
		
		day -= 1; //임의로 조절... 
		var htmlGetCurrentTime = "'javascript:getCurrentTime();'";
		
		var addFormHtml = '<div class="addContentForm card-border mb-3 card card-body border-alternate" name="contentForm">'
							+ '<div class="card-header">'
								+ '<h5>강의컨텐츠 생성</h5>'
							+ '</div>'
							+ '<form id="addContent" class="form-group card-body needs-validation" onsubmit="return false;" method="post" novalidate>' 
								+ '<input type="hidden" name="classID" id="inputClassID" value="${classInfo.id}">'
								+ '<input type="hidden" name="published" id="inputPublished">'
								+ '<input type="hidden" name="days" id="inputDays" value="'+ day +'"/>'
								+ '<input type ="hidden" id="inputPlaylistID" name="playlistID">'
								+ '<div class="selectContent m-3 pr-3">'
									+ '<p id="playlistTitle" class="d-sm-inline-block"> Playlist를 선택해주세요 </p>'
									+ '<button type="button" id="selectPlaylistBtn" name="selectPlaylistBtn" class="btn btn-transition btn btn-outline-success btn-sm float-right"'
											+ 'data-toggle="modal" data-target="#selectPlaylistModal">Playlist 가져오기</button>'
									+ '<div id="playlistThumbnail" class="image-area mt-4"></div>'
								+ '</div>'
								+ '<div class="position-relative row form-group col">'
									+ '<label for="inputTitle" class="col-sm-2 col-form-label">제목</label>'
	                                + '<div class="col-sm-10 p-0">' 
	                                	+ '<input type="text" name="title" id="inputTitle" class="form-control" required>'
	                                	+ '<div class="invalid-feedback">제목을 입력해주세요</div>'
	                                + '</div>'
	                            + '</div>'
	                             + '<div class="position-relative row form-group col">'
	                             	+ '<label for="inputDescription" class="col-sm-2 col-form-label">내용</label>'
                               		+ '<div class="col-sm-10 p-0">'
                               			+ '<textarea name="description" id="inputDescription" class="form-control" rows="10" id="comment" placeholder="이곳에 내용을 작성해 주세요."></textarea>'
                            		+ '</div>'
                            	+ '</div>'
                            	+ '<div class="position-relative row col form-group d-flex align-items-center">'
                            		+ '<label class="col-sm-2 col-form-label">마감일</label>'
                                	+ '<input type="hidden" name="endDate" id="endDate">'
									+ '<input type="date" class="form-control col-sm-4" id="setEndDate">'
									+ '<input type="number" class="setTime end_h form-control col-sm-2 mr-1" value="0" min="0" max="23"> 시'
									+ '<input type="number" class="setTime end_m form-control col-sm-2 ml-2 mr-1" value="0" min="0" max="59"> 분' 
                                + '</div>'
                                + '<div class="position-relative row col form-group d-flex align-items-center">'
	                        		+ '<label class="col-sm-2 col-form-label" >공개일</label>'
	                        		+ '<input type="hidden" name="startDate" id="startDate">'
	                        		+ '<input type="date" class="form-control col-sm-4" id="setStartDate" required>'
									+ '<input type="number" class="setTime start_h form-control col-sm-2 mr-1" min="0" max="23">시'
									+ '<input type="number" class="setTime start_m form-control col-sm-2 ml-1 mr-1" min="0" max="59">분'
									+ '<button type="button" class="btn-transition btn btn-outline-focus btn-sm ml-1" onclick="getCurrentTime();">지금</button>'
	                            + '</div>'
								+ '<div class="text-center m-3">'
									+ '<button type="button" class="btn btn-secondary mr-2" onclick="cancelForm();">작성 취소</button>'
									+ '<button type="submit" form="addContent" class="btn btn-primary" onclick="submitAddContentForm();">저장</button>'
								+ '</div>'
							+ '</form>';
									
		$('.day:eq(' + day + ')').append(addFormHtml);

		//아래부분 마감일 설정때 나오도록...?
		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		$('#setStartDate').val(date);

		//페이지 추가 form 영역으로 페이지 스크롤 
		var offset = $('.addContentForm').offset();
		$('html, body').animate({scrollTop : offset.top}, 300);
		
	}

	function getCurrentTime(){
		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		$('#setStartDate').val(date);
		
		var hour = new Date().getHours();
		var min = new Date().getMinutes();
		$('.start_h').val(hour);
		$('.start_m').val(min);
	}

	function cancelForm(){
		if (confirm("작성을 취소하시겠습니까?")) {
			$('.addContentForm').remove();
			addContentFormOpened = 0;
		}
	}

	function popupOpen(){
		if ($('#inputPlaylistID').val() >= 0){
			if(!confirm('이미 선택한 Playlist가 있습니다. 새로 바꾸시겠습니까?'))
				return false;
		}
		
		p.focus();
	} 

	function stringFormat(p_val){
		if(p_val == '')
			return '00';
		else if(p_val < 10)
			return p_val = '0'+p_val;
		else
			return p_val;
	  }

	function submitAddContentForm(){
		if($('#inputTitle').val() == null || $('#inputTitle').val() == ''){
			alert('제목을 입력해주세요');
			 return false;
		}

		//var hour = $('.start_h').val();
       // var min = $('.start_m').val();
		var startDate = $('#setStartDate').val() + "T" + stringFormat($('.start_h').val()) + ":" +stringFormat($('.start_m').val()) + ":00";
		$('#startDate').val(startDate);
        
		var endDate = $('#setEndDate').val();
		if(endDate != null && endDate != ""){
			var e_date = $('#setEndDate').val();
	        var e_hour = $('.end_h').val();
	        var e_min = $('.end_m').val();
			endDate = e_date + "T" + stringFormat(e_hour) + ":" + stringFormat(e_min) + ":00";	

			if(startDate >= endDate) {
	            alert("컨텐츠 공개일이 마감일보다 빨라야 합니다.");
		        $('#startDate').focus();
	            return false;
	        }
		}
		else 
			endDate = "";
		$('#endDate').val(endDate);

		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		var hour = new Date().getHours();
		var min = new Date().getMinutes();
		var now = date + "T" + stringFormat(hour) + ":" + stringFormat(min) + ":00";
		
		if(startDate <= now) $('#inputPublished').val(1);	//현재 시간과 같거나 더 빠르면 자동 publish 설정
		else $('#inputPublished').val(0);

		if($("#inputPlaylistID").val() == null || $("#inputPlaylistID").val() == ''){
			$("#inputPlaylistID").val(0);
		}
        
       $.ajax({
            type: 'post',
            url: '${pageContext.request.contextPath}/class/addContentOK',
            data: $('#addContent').serialize(),
            success: function(data){
    			if(data == 'ok')
    				console.log('컨텐츠 생성 완료!');
    			else
    				console.log('컨텐츠 생성 실패! ');
    			location.reload();
    		},
    		error: function(data, status,error){
    			console.log("days: " + $('#inputDays').val());
    			alert('강의컨텐츠 생성에 실패했습니다! 잠시후 다시 시도해주세요:(');
    		}
        });
	}

	function convertTotalLength(seconds){
		var seconds_hh = Math.floor(seconds / 3600);
		var seconds_mm = Math.floor(seconds % 3600 / 60);
		var seconds_ss = Math.floor(seconds % 3600 % 60);
		var result = "";
		
		if (seconds_hh > 0)
			result = ("00"+seconds_hh .toString()).slice(-2)+ ":";
		result += ("00"+seconds_mm.toString()).slice(-2) + ":" + ("00"+seconds_ss .toString()).slice(-2) ;
		
		return result;
	}

	function selectOK(){	//modal창에서 playlist 선택완료시
		var playlistID = $('input:radio[name="playlist"]:checked').val();
		if(playlistID){
			$.ajax({
				type : 'post',
				url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
				data : {playlistID : playlistID},
				datatype : 'json',
				success : function(result){
					var thumbnailID = result.thumbnailID;	
					var name = result.playlistName;
					var totalVideo = result.totalVideo;

					var thumbnail = '<div class="image-area mt-4"><img id="imageResult" src="https://img.youtube.com/vi/' + thumbnailID 
												+ '/0.jpg" class="img-fluid rounded shadow-sm mx-auto d-block" style="width: 200px;"></div>';
					var playlistInfo = thumbnail + '<p>총 ' + totalVideo + ' 개의 비디오</p>';
					$('#playlistThumbnail').empty();
					$('#playlistThumbnail').append(playlistInfo);
					
					$('#playlistTitle').text('"' + name + '" 선택됨');
					
					$('#inputPlaylistID').val(playlistID); //부모페이지에 선택한 playlistID 설정
					$('#inputThumbnailID').val(thumbnailID);
					$('#selectPlaylistBtn').text('playlist 다시선택');
				}
			});
		}
		else {
			alert('playlist를 선택해주세요');
			return false;
		}
	}
	
	function updateDays(classID){
		$.ajax({
			type : 'post',
			url : '../updateDays',
			data : {classID : classID},
			datatype : 'json',
			success : function(result){
				console.log("성공!");
				location.reload();
			},
			error : function() {
			  	alert("업데이트에 실패했습니다! 잠시후 다시 시도해주세요 :(");
			}
		});
	}
	
	function deleteDay(classID, day){
		var confirm = prompt(day + '차시를 삭제하시려먼 [' + day + '차시]를 입력해주세요.\n차시에 해당하는 강의 컨텐츠와 학생들의 출결 정보도 함께 삭제됩니다.')
		if(confirm == day + '차시'){	//사용자입력받기
			$.ajax({
				type : 'post',
				url : '${pageContext.request.contextPath}/class/deleteDay',
				data : {
					classID : classID,
					days : day
					},
				datatype : 'json',
				success : function(result){
					alert(day + '차시에 해당하는 모든 데이터가 삭제되었습니다!');
					location.reload();
				},
				error : function() {
				  	alert("차시 삭제에 실패했습니다! 잠시후 다시 시도해주세요:(");
				}
			});
		}
	}

	function moveToContentDetail(contentID, daySeq){	//content detail page로 이동
		var html = '<input type="hidden" name="id"  value="' + contentID + '">'
					+ '<input type="hidden" name="daySeq" value="' + daySeq + '">';
	
		var goForm = $('<form>', {
				method: 'post',
				action: '${pageContext.request.contextPath}/class/contentDetail',
				html: html
			}).appendTo('body'); 
	
		goForm.submit();
	}
</script>
<script>
//Example starter JavaScript for disabling form submissions if there are invalid fields
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
<body>
	<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
		<jsp:include page="../outer_top.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left.jsp" flush="false">
		 		<jsp:param name="className" value="${classInfo.className}"/>
		 		<jsp:param name="menu"  value="contentList"/>	
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<h4><span class="text-primary">${classInfo.className}</span> - 강의컨텐츠</h4>
                            </div>
                        </div>
                    </div>    
                    <div class="row justify-content-center">
                    	<div class="col-sm-12">
                           <nav class="" aria-label="Page navigation example">
                           	   <button onclick='updateDays(${classInfo.id})' class="float-right mb-2 mr-2 btn btn-primary btn-sm">차시 추가</button>
								<div id="client-paginator">
									<ul class="pagination">
	                               		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
											<li class="page-item"><a href="#target${j-1}" class="page-link"> ${j} 차시 </a></li>
										</c:forEach>
	                              	</ul>
								</div>
                               
                            </nav>
                       	</div>
                       	
                    	<div class="contents col-sm-12" classID="${classInfo.id}">
							<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
                                <div class="main-card mb-3 card">
                                    <div class="card-body">
                                    	<div class="card-title" style="display: inline;" >
                                    		<a style="display: inline; white-space: nowrap;" name= "target${j}" >
											 <h5 style="display: inline;">${j} 차시</h5>
											</a> 
											 <button onclick='showAddContentForm(${status.index})' class="mb-2 mr-2 btn-transition btn btn-outline-primary btn-sm"> +페이지추가</button>
											 <c:set var="j" value="${j}" />
											 <c:set var="count" value="${classInfo.days}" />
												<c:if test="${j eq count}">
													<button onclick='deleteDay(${classInfo.id}, ${status.index})' 
														class="mb-2 mr-2 btn-transition btn btn-danger float-right btn-sm">차시삭제</button>
												</c:if>
											 
                                    	</div>

	                                    <div class="list-group accordion-wrapper day" day="${status.index}">
	                                        	
	                                    </div>
                                   </div>
                               </div>    
							</c:forEach>
						</div>
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
   	
   	<!-- 강의컨텐츠 생성 중 Playlist 가져오기 modal -->
   	<div class="modal fade" id="selectPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" >
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle">Playlist 선택</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	            </div>
	            
	            <div class="modal-body">
	               Playlist를 선택해주세요
	               <div class="myPlaylist"></div>
	               
	            </div>
	            <div class="modal-footer">
	            	 <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="selectOK();">선택완료</button>
	            </div>
	        </div>
	    </div>
	</div>
</body>
	
</html>





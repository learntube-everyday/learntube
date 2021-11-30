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
    <title>강의 컨텐츠</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="msapplication-tap-highlight" content="no">
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
</head>

<style>
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
var ori_index =0;
var videoIdx = '${daySeq}';
var ccID = '${id}';

$(document).ready(function(){
	$.ajax({ 
		  url : "${pageContext.request.contextPath}/class/forInstructorContentDetail",
		  type : "post",
		  async : false,
		  dataType : "json",
		  success : function(data) {
			weekContents = data;
		  },
		  error : function() {
		  	alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		  }
	});
	
	$.ajax({
		  url : "${pageContext.request.contextPath}/class/forVideoInformation",
		  type : "post",
		  async : false,
		  data : {	
			  playlistID : weekContents[videoIdx].playlistID
		  },
		  success : function(data) {
			 playlist = data; 
		  },
		  error : function() {
			 alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		  }
	});
	
	$.ajax({ 
		url : "${pageContext.request.contextPath}/class/changeID",
		type : "post",
		async : false,
		data : {	
			id: '${id}'
		},
		success : function(data) {
			var element = document.getElementById("contentsTitle");
			if(weekContents[videoIdx].playlistID == 0)
				element.innerHTML = '<i class="fa fa-file-text-o" aria-hidden="true" style="font-size: 20px; margin: 5px 5px;"></i>' + data.title;
			else
				element.innerHTML = '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; margin: 5px 5px; color:dodgerblue;"></i> ' + data.title;
			var elementD = document.getElementById("contentsDescription");
			elementD.innerText = data.description;

			$('#editContentName').val(data.title);
			$('#editContentDescription').val(data.description);
			$('#setContentID').val(data.id);
			
			var endDate = data.endDate;
			var startDate = data.startDate;
			
			if(endDate != null && endDate != ''){
				endDate = endDate.split(" ")[0];
				var hour = data.endDate.split(" ")[1];
				var min = hour.split(":")[1];
				hour = hour.split(":")[0];
				$('#setEndDate').val(endDate);
				$('#endDate_h').val(hour);
				$('#endDate_m').val(min);
			}
			else {
				$('#setEndDate').val('');
				$('#endDate_h').val(hour);
				$('#endDate_m').val(min);
			}

			startDate = startDate.split(" ")[0];
			var hour = data.startDate.split(" ")[1];
			var min = hour.split(":")[1];
			hour = hour.split(":")[0];
			$('#setStartDate').val(startDate);
			$('#startDate_h').val(hour);
			$('#startDate_m').val(min);
				
			
		},
		error : function() {
			alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		}
	});
	
	var urlContent='';
	for(var i=0; i<weekContents.length; i++){
		var symbol;
		if(weekContents[i].playlistID == 0){	//현재 playlist가 없는 학습컨텐츠일 때
			symbol = '<i class="pe-7s-note2 fa-lg" > </i>'
			if(videoIdx == i) {
				document.getElementById("onepageLMS").style.display = "none";
			}
			
			var day = weekContents[i].days;
			
			var endDate = weekContents[i].endDate;
			if(endDate != null && endDate != ''){
				endDate = endDate.split(":");
				endDate = endDate[0] + ":" + endDate[1];	
				endDate =  '<div class="endDate contentInfo" style="padding: 0px 0px 10px;">마감일: ' + endDate + '</div>'
			}
				
			else endDate = '';
			
			//선택한 플레이리스트가 열려있는 상태로 보이도록 하는 코드
			if(i == videoIdx){
				var area_expanded = true;
				var area_labelledby = 'aria-labelledby="heading' + (i+1) + '"';
				var showing = 'class="collapse show"';
			} 
			else{
				var area_expanded = false;
				var area_labelledby = '';
				var showing = 'class="collapse"';
			}
			
			var content = $('.day:eq(' + day + ')');
			content.append("<div id=\'heading" +(i+1)+ "\'>"
				               + '<button type="button" onclick="showLecture(' 
								+ weekContents[i].playlistID + ','   + weekContents[i].id + ',' + weekContents[i].classID + ',' + (i+1) +')"'
				 				+ 'data-toggle="collapse" data-target="#collapse' +(i+1)+ '" aria-expanded='+ area_expanded+' aria-controls="collapse0' +(i+1)+ '"class="text-left m-0 p-0 btn btn-link btn-block">'
					               + "<div class='content card align-items-center list-group-item' seq='" + weekContents[i].daySeq + "' style='padding: 10px 0px 0px;' >"
									+ '<div class="row col d-flex align-items-center">'
										+ "<div class='index col-1 col-sm-1'>" + symbol + "</div>"
											
										+ "<div class='' style='cursor: pointer;'>"
											+ "<div class='col card-title'>"
												+ weekContents[i].title // + '  [' + convertTotalLength(weekContents[k].totalVideoLength) + ']' 
											+ '</div>'
											+ '<div class="col">'
												+ '<div class="contentInfoBorder"></div>'
												+ endDate
											+ '</div>' 
										+ '</div>'
											
									+ '</div>'
								+ '</div>'
				   			+ '</button>'
						+ '</div>'
				
						+ '<div data-parent="#accordion" id="collapse' + (i+1) + '"' + area_labelledby + showing + '>'
			    			+ '<div class="card-body" day="' +(i+1)+ '"> '
						    	+ '<div id="allVideo" class="">'
									+ '<div id="classTitle"></div>'
									+ '<div id="classDescription"> </div>'
									+ '<div id="total_runningtime"></div>'
									+ '<div id="get_view'+ (i+1) +'"></div>'
									 	
						       	+ '</div>'
							+'</div>'
						+ '</div>'
		  			+ '</div>');
		}
		
		else{
			console.log("playlistID 0 아니니까!");
			symbol = '<i class="pe-7s-film fa-lg" style=" color:dodgerblue"> </i>'
				
			var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[i].thumbnailID + '/1.jpg">';
			var day = weekContents[i].days;
			var endDate = weekContents[i].endDate; //timestamp -> actural time
			if(endDate != null && endDate != ''){
				endDate = '<div class="endDate contentInfo pb-2">마감일: ' + endDate + '</div>';
			}
			else endDate = '';
				
				
			//선택한 플레이리스트가 열려있는 상태로 보이도록 하는 코드
			if(i == videoIdx){
				var area_expanded = true;
				var area_labelledby = 'aria-labelledby="heading' + (i+1) + '"';
				var showing = 'class="collapse show"';
			}
			else{
				var area_expanded = false;
				var area_labelledby = '';
				var showing = 'class="collapse"';
			}
							
			var innerText ='';
			
			
			for(var j=0; j<playlist.length; j++){ //classcontent내에 들어있는 비디오 개수
					
				var newTitle = playlist[j].newTitle;
				var title = playlist[j].title;
						
				if (playlist[j].newTitle == null){
					playlist[j].newTitle = playlist[j].title;
					playlist[j].title = '';
				}
					
				if ((playlist[j].newTitle).length > 30){
					playlist[j].newTitle = (playlist[j].newTitle).substring(0, 30) + " ..."; 
				}
						
				var completed ='';
				if(playlist[j].watched == 1 && playlist[j].classContentID == weekContents[i].id){
					completed = '<div class="col-xs-1 col-lg-2"><span class="badge badge-primary"> 완료 </span></div>';
				}
						
						
				var thumbnail = '<img src="https://img.youtube.com/vi/' + playlist[j].youtubeID + '/1.jpg" style="max-width: 100%; height: 100%;">';
				var background = '';
				
				innerText += '<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' 
									+ '<div class="video row post-content single-blog-post style-2 d-flex align-items-center" '+background+'>' 
										+ '<div class="post-thumbnail col-5"> ' 
											+ thumbnail 
											+ '<div class="col-12 p-1" style="text-align : center">'+  convertTotalLength(playlist[j].duration) +'</div>' 
										+ ' </div>' 
										+ '<div class="post-content col-7 p-1 align-items-center myLecture" onclick="viewVideo(\''  //viewVideo호출
											+ playlist[j].youtubeID.toString() + '\'' + ',' + playlist[j].id + ',' 
											+ 	playlist[j].start_s + ',' + playlist[j].end_s +  ',' + j + ',' + i + ', this)" >' 
											+ 	'<div class="post-title videoNewTitle" style="font-weight:800">' + playlist[j].newTitle + '</div>' 
											+	'<div class=""> start : '+  convertTotalLength(playlist[j].start_s) + '</div>' 
											+	'<div class=""> end : '+  convertTotalLength(playlist[j].end_s) + '</div>' 
										+'</div>' 
										+ 	completed 
								+ '</div>'
			}
			
			var content = $('.day:eq(' + day + ')');
			content.append("<div id=\'heading" +(i+1)+ "\'>"
		               + '<button type="button" onclick="showLecture(' //showLecture 현재 index는 어떻게 보내지.. 내가 누를 index말고 
						+ weekContents[i].playlistID + ','   + weekContents[i].id + ',' + weekContents[i].classID + ',' + (i+1) +')"'
		 				+ 'data-toggle="collapse" data-target="#collapse' +(i+1)+ '" aria-expanded='+ area_expanded+' aria-controls="collapse0' +(i+1)+ '"class="text-left m-0 p-0 btn btn-link btn-block">'
			               + "<div class='content card align-items-center list-group-item' seq='" + weekContents[i].daySeq + "'>"
							+ '<div class="row d-flex align-items-center">'
								+ '<div class="index col-sm-1 ">' + symbol + '</div>'
									
								+ "<div class='col-sm-11' style='cursor: pointer;'>"
									+ "<div class='card-title'>"
										+ weekContents[i].title  + '  [' + convertTotalLength(weekContents[i].totalVideoLength) + ']' 
									+ '</div>'
									+ '<div class="">'
										+ '<div class="contentInfoBorder"></div>'
										+ endDate
									+ '</div>' 
								+ '</div>'
									
							+ '</div>'
						+ '</div>'
		   			+ '</button>'
				+ '</div>'
					
					+ '<div data-parent="#accordion" id="collapse' + (i+1) + '"' + area_labelledby + showing + '>'
		    			+ '<div class="card-body" day="' +(i+1)+ '"> '
					
					    	+ '<div id="allVideo" class="">'
								+ '<div id="classTitle"></div>'
								+ '<div id="classDescription"> </div>'
								+ '<div id="total_runningtime"></div>'
								+ '<div id="get_view'+ (i+1) +'" >'
									
									+ innerText
													
								+ '</div>'
								 	
					       	+ '</div>'
					       	+'</div>'
						+ '</div>'
	  			+ '</div>');
		}
	}
		
});

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

var n ;
var playlistVideo;

function showLecture(playlistID, id, classInfo, idx){	//오른쪽 강의컨텐츠 목록에서 하나 클릭했을 때
	ccID = id;
	player.stopVideo();
	if(weekContents[idx-1].playlistID != 0)
		document.getElementById("onepageLMS").style.display = "";
	else 
		document.getElementById("onepageLMS").style.display = "none";
	
	n = idx;
	
	$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
		  url : "${pageContext.request.contextPath}/class/forVideoInformation",
		  type : "post",
		  async : false,
		  data : {	
			  playlistID : playlistID
		  },
		  success : function(data) {
			 playlist = data; //data는 video랑 videocheck테이블 join한거 가져온다
			 playlist_length = Object.keys(playlist).length;
		  },
		  error : function() {
			 alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		  }
	})
	
	 $.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
			  url : "${pageContext.request.contextPath}/class/changeID",
			  type : "post",
			  async : false,
			  data : {	
				  id: id
			  },
			  success : function(data) {

				var element = document.getElementById("contentsTitle");
				if(playlistID == 0)
					element.innerHTML = '<i class="fa fa-file-text-o" aria-hidden="true" style="font-size: 20px; margin: 5px 5px;"></i>' + data.title;
				else
					element.innerHTML = '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; margin: 0px 5px; color:dodgerblue;"></i> ' + data.title;
				var elementD = document.getElementById("contentsDescription");
				elementD.innerText = data.description;
				
				
				$('#editContentName').val(data.title);
				$('#editContentDescription').val(data.description);
				$('#setContentID').val(data.id);
				
				var endDate = data.endDate;
				var startDate = data.startDate;
				
				if(endDate != null && endDate != ''){
					endDate = endDate.split(" ")[0];
					var hour = data.endDate.split(" ")[1];
					var min = hour.split(":")[1];
					hour = hour.split(":")[0];
					$('#setEndDate').val(endDate);
					$('#endDate_h').val(hour);
					$('#endDate_m').val(min);
				}
				else {
					$('#setEndDate').val('');
					$('#endDate_h').val(hour);
					$('#endDate_m').val(min);
				}

				startDate = startDate.split(" ")[0];
				var hour = data.startDate.split(" ")[1];
				var min = hour.split(":")[1];
				hour = hour.split(":")[0];
				$('#setStartDate').val(startDate);
				$('#startDate_h').val(hour);
				$('#startDate_m').val(min);
			  },
			  error : function() {
				alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
			  }
		})
	
	myThumbnail(id, idx);
	ccID = id;
}



function myThumbnail(classContentID, idx){
	if(weekContents[idx-1].playlistID == 0) return;
	var className = '#get_view' + idx;
	$(className).empty();
	
	for(var i=0; i<playlist.length; i++){
	
		var thumbnail = '<img src="https://img.youtube.com/vi/' + playlist[i].youtubeID + '/1.jpg" style="max-width: 100%; height: 100%;">';
		
		var newTitle = playlist[i].newTitle;
		var title = playlist[i].title;
		
		if (playlist[i].newTitle == null){
			playlist[i].newTitle = playlist[i].title;
			playlist[i].title = '';
  		}
		
		if ((playlist[i].newTitle).length > 30){
			playlist[i].newTitle = (playlist[i].newTitle).substring(0, 30) + " ..."; 
		}
	
		var completed ='';
		
		$(className).append( //stu//stu
						'<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' 
						+ '<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' 
							+ '<div class="post-thumbnail col-5"> ' 
								+ thumbnail 
								+ '<div class="col-12 p-1" style="text-align : center">'+  convertTotalLength(playlist[i].duration) +'</div>' 
							+ ' </div>' 
							+ '<div class="post-content col-7 p-1 align-items-center" onclick="viewVideo(\''  //viewVideo호출
								+ playlist[i].youtubeID.toString() + '\'' + ',' + playlist[i].id + ',' 
								+ 	playlist[i].start_s + ',' + playlist[i].end_s +  ',' + i + ',' + (idx-1) + ', this.parentNode)" >' 
								+ 	'<div class="post-title videoNewTitle" style="font-weight:800">' + playlist[i].newTitle + '</div>' 
								+	'<div class=""> start : '+  convertTotalLength(playlist[i].start_s) + '</div>' 
								+	'<div class=""> end : '+  convertTotalLength(playlist[i].end_s) + '</div>' 
							+'</div>' 
							+ 	completed 
					+ '</div>'
					+ '<div class="videoLine"></div>'
		);
		
	}
	
}

var visited ;
function viewVideo(videoID, id, startTime, endTime, index, seq, item) { // 선택한 비디오 아이디를 가지고 플레이어 띄우기
	

	if(weekContents[seq].playlistID != 0)
		document.getElementById("onepageLMS").style.display = "";
	else 
		document.getElementById("onepageLMS").style.display = "none";
		
	start_s = startTime;
	$('.videoTitle').text(playlist[index].newTitle); //비디오 제목 정해두기
	if (confirm("다른 영상으로 변경하시겠습니까? ") == true){    //확인
		flag = 0;
		time = 0;
		
		if(visited){
			visited.style.background = "transparent";
			document.getElementsByClassName('video')[0].style.background = "transparent";
		}
		
		item.style.background = "#F0F0F0";

		
		player.loadVideoById({'videoId': videoID,
             'startSeconds': startTime,
             'endSeconds': endTime,
             'suggestedQuality': 'default'})
             
       visited = item;  
             
	}

	else{   //취소
		return;
	}
	
}


//youtube 영상 띄울것입니다.
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player;

function onYouTubeIframeAPIReady() { 
	//var playerID = 'onepageLMS' + n;
	
	if(weekContents[videoIdx].playlistID == 0) //영상이 아닌 url을 클릭했을 때
		videoId =  '';
	else //영상을 클릭했을 때
		videoId = weekContents[videoIdx].thumbnailID;	
	
	
	player = new YT.Player('onepageLMS', {
	       height: '480',            // <iframe> 태그 지정시 필요없음
	       width: '854',             // <iframe> 태그 지정시 필요없음
	       videoId: videoId,
	       playerVars: {             // <iframe> 태그 지정시 필요없음
	           controls: '2'
	       },
	       events: {
	           'onReady': onPlayerReady               // 플레이어 로드가 완료되고 API 호출을 받을 준비가 될 때마다 실행
	           
	       }
	   });
}


function onPlayerReady(event) { 
	//이거는 플레이리스트의 첫번째 영상이 실행되면서 진행되는 코드 (영상클릭없이 페이지 딱 처음 로딩되었을 )
	if(weekContents[videoIdx].playlistID == 0) return;
	
	console.log('onPlayerReady 실행');
	console.log("playlist[0]" + playlist[0]);
	$.ajax({
		'type' : "post",
		'url' : "${pageContext.request.contextPath}/student/class/videocheck",
		'data' : {
			videoID : playlist[0].id //현재 재생중인 (플레이리스트 첫번째 영상의 ) id
		},
		success : function(data){
			
			player.loadVideoById({
				'videoId' : weekContents[videoIdx].thumbnailID,
				 'startSeconds' : playlist[0].start_s,
				 'endSeconds' : playlist[0].end_s,
				 'suggestedQuality': 'default'})
			
			//player.playVideo();
	        player.pauseVideo();
			
		}, 
		error : function(err){
			alert("플레이리스트 실행이 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		}
	});
  	console.log('onPlayerReady 마감'); 
}

function stringFormat(p_val){
	if(p_val == '')
		return '00';
	else if(p_val < 10)
		return p_val = '0'+p_val;
	else
		return p_val;
  }

function submitContent(){	//update content
	var startDate = $("#setStartDate").val() + " " + stringFormat($("#startDate_h").val()) + ":" + stringFormat($("#startDate_m").val()) + ":00";
	
	var endDate = $("#setEndDate").val();
	if(endDate != '' && endDate != null) {
		endDate = endDate + " " + stringFormat($("#endDate_h").val()) + ":" + stringFormat($("#endDate_m").val()) + ":00";

		if(startDate >= endDate) {
	        alert("컨텐츠 공개일이 마감일보다 빨라야 합니다.");
	        $('#startDate').focus();
	        return false;
	    }
	}
	else endDate = "";

	var timezoneOffset = new Date().getTimezoneOffset() * 60000;
	var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
	var hour = new Date().getHours();
	var min = new Date().getMinutes();
	var now = date + " " + stringFormat(hour) + ":" + stringFormat(min) + ":00";
	if(startDate <= now) $('#setPublished').val(1);
	else $('#setPublished').val(0);

	$('#startDate').val(startDate);
	$('#endDate').val(endDate);
	
	$.ajax({ 
		  url : "${pageContext.request.contextPath}/class/updateClassContents",
		  type : "post",
		  async : false,
		  data : $('#formEditClassContents').serialize(),
		  dataType : "json",
		  success : function(data) {
			console.log("modalSubmit");
		  },
		  complete : function(data) {
		  	location.reload();
		  }
	});
}


function deleteContent(){
	if(confirm("현재 강의 페이지를 정말 삭제하시겠습니까? ") == true){
		$.ajax({ 
			  url : "${pageContext.request.contextPath}/class/deleteClassContent",
			  type : "post",
			  async : false,
			  data : {	
				classContentID : ccID
			  },
			  complete : function(data) {
				  alert('강의 페이지가 삭제되었습니다. 강의컨텐츠 목록 페이지로 이동합니다.');
				 location.replace('${pageContext.request.contextPath}/class/contentList/${classInfo.id}');
			  }
		});
	}
	
	else return;
}

function getCurrentTime(){
	var timezoneOffset = new Date().getTimezoneOffset() * 60000;
	var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
	var hour = new Date().getHours();
	var min = new Date().getMinutes();
	
	$('#setStartDate').val(date);
	$('#startDate_h').val(hour);
	$('#startDate_m').val(min);
}

	
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
        			<h4>
                      	<button class="btn row" onclick="location.href='${pageContext.request.contextPath}/class/contentList/${classInfo.id}'"> 
                			<i class="pe-7s-left-arrow h4 col-12"></i>
                			<p class="col-12 m-0">이전</p>
             			</button>
             			<span class="text-primary">${classInfo.className}</span> - 강의컨텐츠
                    </h4>                     
                    <div class="row">
                    	<div class="main-card mb-3 card col-md-8">
							<div class="card-body p-0">
								<div class="card-header">
									<div id="contentsTitle" style="font-size : 20px; display:inline;" ></div>
									<a href="#" data-toggle="modal" data-target="#editContentModal" class="nav-link editPlaylistBtn" style="display:inline;">
                                        <i class="nav-link-icon fa fa-cog"></i>
									</a>
								</div>
                            	<div id="onepageLMS" class="col-12 col-md-12 col-lg-12" style="margin : 0px; padding:0px;">
								</div>
								<div class="card-footer">
									<div id="contentsDescription" style="font-size : 15px" > </div>
								</div>
                            </div>
                        </div>
						<div class="contents col-md-4" classID="${classInfo.id}">
                           <nav class="">
                           		<div id="client-paginator">
									<ul class="pagination">
	                               		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
											<li class="page-item"><a href="#target${j}" class="page-link">${j}</a></li>
										</c:forEach>
	                              	</ul>
								</div>
                            </nav>
	                       	<div class="main-card mb-3 card">
								<div class="card-body" style="overflow-y:auto; height:750px;">
									<div class="ps--active-y">
										<div id="accordion" class="accordion-wrapper mb-3">
											<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
												<div class="main-card mb-3 card">
													<div class="card-title p-3 m-0">
														<a name= "target${j}">${j} 차시</a> <!-- 이부분 잘 안됨 수정필요!! -->
													</div>
				                                    <div class="list-group day" day="${status.index}"></div>
				                               </div>
											</c:forEach>
										</div>
									</div>   
								</div>
                           	</div>
						</div>
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
   	
   	<!-- edit classContent modal -->
    <div class="modal fade" id="editContentModal" tabindex="-1" role="dialog" aria-labelledby="editContentModal" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="editContentModalLabel">강의컨텐츠 수정</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            
	            <form class="needs-validation" id="formEditClassContents" method="post" onsubmit="return false;" novalidate>
		            <input id="setContentID" name="id" type="hidden">
		            <input id="setPublished" name="published" type="hidden">
		            <div class="modal-body">
		               <div class="position-relative form-group">
		               		<label for="editContentName" class="">이름</label>
		               		<input name="title" id="editContentName" type="text" class="form-control">
		               		<div class="invalid-feedback">강의실 이름을 다시 입력해주세요</div>
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editContentDescription" class="">설명</label>
		               		<textarea name="description" id="editContentDescription" class="form-control"></textarea>
		               </div>
		               <div class="position-relative row form-group d-flex align-items-center">
							<label class="col-sm-2 col-form-label">마감일</label>
							<input type="hidden" name="endDate" id="endDate">
							<input type="date" class="form-control col-sm-4" id="setEndDate">
							<input type="number" class="setTime form-control col-sm-2 mr-1" id="endDate_h" min="0" max="23"> 시
							<input type="number" class="setTime form-control col-sm-2 ml-2 mr-1" id="endDate_m" min="0" max="59"> 분
						</div>
                        <div class="position-relative row form-group d-flex align-items-center">
                      		<label class="col-sm-2 col-form-label" >공개일</label>
                      		<input type="hidden" name="startDate" id="startDate">
                      		<input type="date" class="form-control col-sm-4" id="setStartDate" required>
							<input type="number" class="setTime form-control col-sm-2 mr-1" id="startDate_h" min="0" max="23"> 시
							<input type="number" class="setTime form-control col-sm-2 ml-1 mr-1" id="startDate_m" min="0" max="59"> 분
							<button type="button" class="btn-transition btn btn-outline-focus btn-sm ml-1" onclick="getCurrentTime();">지금</button>
						</div>
		             </div>
		            <div class="modal-footer">
		            	<div style="float: left;"><button class="btn btn-danger" onclick="deleteContent();">컨텐츠 삭제</button></div>
		                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		                <button id="modalSubmit" type="button" class="btn btn-primary" onclick="submitContent();">수정완료</button>
		            </div>
	        	</form>
	        </div>
	    </div>
	</div>
	
</body>
</html>
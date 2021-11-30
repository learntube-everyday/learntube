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
var classContentID = 0;
var videoIdx;
var playlist; 

var ori_index =0;
var ori_videoID;
var ori_playlistID;
var ori_classContentID;

var weekContents;


$(document).ready(function(){ //classID에 맞는 classContents를 보여주기 위함
	$.ajax({ //classID에 맞는 classContents를 보여주기 위함(playlist만 있음)
		  url : "${pageContext.request.contextPath}/student/class/weekContents",
		  type : "post",
		  async : false,
		  success : function(data) {
			  weekContents = data;
			  videoIdx = '${daySeq}';
			  classContent = weekContents[videoIdx]; //없으면 안됩니다 
			  
			  var element = document.getElementById("contentsTitle");
			  if(weekContents[videoIdx].playlistID == 0)
				  	element.innerHTML = '<i class="fa fa-file-text-o" aria-hidden="true" style="font-size: 20px; margin: 5px 5px;"></i>' + weekContents[videoIdx].title;
			  else
					element.innerHTML = '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; margin: 0px 5px; color:dodgerblue;"></i> ' + weekContents[videoIdx].title;

			  var elementD = document.getElementById("contentsDescription");
			  elementD.innerText = weekContents[videoIdx].description;
		  },
		  error : function() {
			  alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		  }
	});
	
	//if(weekContents[videoIdx].playlistID != 0) {
	$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
		url : "${pageContext.request.contextPath}/student/class/forVideoInformation",
		type : "post",
		async : false,
		data : {	
			playlistID : weekContents[videoIdx].playlistID,
		},
		success : function(data) {
			playlist = data; //data는 video랑 videocheck테이블 join한거 가져온다 => video랑 classContent join한거 
			if(data.length > 0){
				ori_videoID = playlist[0].id; //첫 videoID는 선택된 classContent의 Playlist의 첫번째 영상
				ori_playlistID = weekContents[videoIdx].playlistID;
				ori_classContentID = weekContents[videoIdx].id;
			}
		},
		error : function() {
			alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		}
	});
	//}
	
	$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
		url : "${pageContext.request.contextPath}/student/class/forWatched",
		type : "post",
		async : false,
		data : {	
			playlistID : weekContents[videoIdx].playlistID,
			classContentID : weekContents[videoIdx].id
		},
		success : function(data) {
			watch = data; //data는 video랑 videocheck테이블 join한거 가져온다 => video랑 classContent join한거 
		},
		error : function() {
			alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		}
	});
	
	// 초기화면 세팅 시작!!
	for(var i=0; i<weekContents.length; i++){
		var symbol;
		
		if(weekContents[i].playlistID == 0){ //NOT Playlist
			
			symbol = '<i class="pe-7s-note2 fa-lg" > </i>'
			
			var day = weekContents[i].days;
			var endDate = weekContents[i].endDate; //timestamp -> actural time
			
			//선택한 플레이리스트가 열려있는 상태로 보이도록 하는 코드
			if(i == videoIdx){
				document.getElementById("onepageLMS").style.display = "none";
				
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
		               + '<button type="button" onclick="showLecture(' //showLecture 현재 index는 어떻게 보내지.. 내가 누를 index말고 
						+ weekContents[i].playlistID + ','   + weekContents[i].id + ',' + (i+1) +')"'
		 				+ 'data-toggle="collapse" data-target="#collapse' +(i+1)+ '" aria-expanded='+ area_expanded+' aria-controls="collapse0' +(i+1)+ '"class="text-left m-0 p-0 btn btn-link btn-block">'
			               + "<div class='content card align-items-center list-group-item' seq='" + weekContents[i].daySeq + "'>"
							+ '<div class="row col d-flex align-items-center">'
								+ "<div class='index col-sm-1'>" + symbol + "</div>"
								+ "<div class='' style='cursor: pointer;'>"
									+ "<div class='card-title'>"
										+ weekContents[i].title // + '  [' + convertTotalLength(weekContents[k].totalVideoLength) + ']' 
									+ '</div>'
									+ '<div class="">'
										+ '<div class="contentInfoBorder"></div>'
										+ '<div class="endDate contentInfo">' + '마감일: ' + endDate + '</div>'
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
								+ '<div id="get_view'+ (i+1) +'">'
									
								//	+ innerText
													
								+ '</div>'
								 	
					       	+ '</div>'
					       	+'</div>'
						+ '</div>'
	  			+ '</div>');
			
		}
		
		else{ //Playlist 
			symbol = '<i class="pe-7s-film fa-lg" style=" color:dodgerblue"> </i>'
				
				var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[i].thumbnailID + '/1.jpg" style="max-width: 100%; height: 100%;">';
				var day = weekContents[i].days;
				var endDate = weekContents[i].endDate;
				
				if(endDate == null || endDate == '')
					endDate = '';
				else {
					endDate = endDate.split(":");
					endDate = endDate[0] + ":" + endDate[1];	
					endDate =  '<div class="endDate contentInfo" style="padding: 0px 0px 10px;">마감일: ' + endDate + '</div>'
		
				classContentID = weekContents[i].id; // classContent의 id //여기 수정
				
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
				
				var k = 0;
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
					
					if(watch[k] != null || watch[k+1] != null){
						if(watch[k].watched == 1 ){
							completed = '<div class="col-2"><span class="badge badge-primary"> 완료 </span></div>';
						}
						k++;
					}
						
						
					var thumbnail = '<img src="https://img.youtube.com/vi/' + playlist[j].youtubeID + '/1.jpg" style="max-width: 100%; height: 100%;">';
						
					innerText += '<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' 
									+ '<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' 
										+ '<div class="post-thumbnail col-4 p-1"> ' 
											+ thumbnail 
											+ '<div class="col-12 p-1" style="text-align : center">'+  convertTotalLength(playlist[j].duration) +'</div>' 
										+ ' </div>' 
										+ '<div class="post-content col-6 p-1 align-items-center myLecture" onclick="viewVideo(\''  //viewVideo호출
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
		               + '<button type="button" onclick="showLecture(' 
						+ weekContents[i].playlistID + ','   + weekContents[i].id + ',' + (i+1) +')"'
		 				+ 'data-toggle="collapse" data-target="#collapse' +(i+1)+ '" aria-expanded='+ area_expanded+' aria-controls="collapse0' +(i+1)+ '"class="text-left m-0 p-0 btn btn-link btn-block">'
			               + "<div class='content card align-items-center list-group-item' seq='" + weekContents[i].daySeq + "' style='padding: 10px 0px 0px;' >"
							+ '<div class="row col d-flex align-items-center">'
								+ '<div class="index col-sm-1">' + symbol + '</div>'
									
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
					
					    	+ '<div id="allVideo" class="col-12 col-xs-12 col-sm-12 col-md-12 col-lg-12">'
								
								+ '<div id="classTitle"></div>'
								+ '<div id="classDescription"> </div>'
								+ '<div id="total_runningtime"></div>'
								+ '<div id="get_view'+ (i+1) +'">'
									
									+ innerText
													
								+ '</div>'
								 	
					       	+ '</div>'
					       	+'</div>'
						+ '</div>'
	  			+ '</div>');
				
				}	
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
function showLecture(playlistID, id, idx){ //새로운 playlist를 선택했을 때 실행되는 함수
	player.stopVideo();
	if(weekContents[idx-1].playlistID != 0){
		document.getElementById("onepageLMS").style.display = "";
	}
	else 
		document.getElementById("onepageLMS").style.display = "none";
	
	n = idx;
	
	$.ajax({ 
		  url : "${pageContext.request.contextPath}/student/class/forVideoInformation",
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
	
	$.ajax({ 
			  url : "${pageContext.request.contextPath}/student/class/changeID",
			  type : "post",
			  async : false,
			  data : {	
				  id: id
			  },
			  success : function(data) {
				 classContent = data;

				var element = document.getElementById("contentsTitle");
				if(playlistID == 0)
					element.innerHTML = '<i class="fa fa-file-text-o" aria-hidden="true" style="font-size: 20px; margin: 5px 5px;"></i>' + data.title;
				else
					element.innerHTML = '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; margin: 0px 5px; color:dodgerblue;"></i> ' + data.title;
				var elementD = document.getElementById("contentsDescription");
				elementD.innerText = data.description;
			  },
			  error : function() {
				  alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
			  }
	})
	
	$.ajax({ 
		url : "${pageContext.request.contextPath}/student/class/forWatched",
		type : "post",
		async : false,
		data : {	
			playlistID : playlistID,
			classContentID : id
		},
		success : function(data) {
			watch = data; //data는 video랑 videocheck테이블 join한거 가져온다 => video랑 classContent join한거 
		},
		error : function() {
			alert("강의컨텐츠 정보를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요!");
		}
	})
	
	myThumbnail(id, idx);
}

function myThumbnail(classContentID, idx){
	if(weekContents[idx-1].playlistID == 0) return;
	var className = '#get_view' + idx;
	$(className).empty();
	
	var k = 0;
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

		if(watch[k] != null || watch[k+1] != null){
			if(watch[k].watched == 1 ){
				completed = '<div class="col-2"><span class="badge badge-primary">완료</span></div>';
			}
			k++;
		}
		
		$(className).append( //stu//stu
						'<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' 
						+ '<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' 
							+ '<div class="post-thumbnail col-4 p-1"> ' 
								+ thumbnail 
								+ '<div class="col-12 p-1" style="text-align : center">'+  convertTotalLength(playlist[i].duration) +'</div>' 
							+ ' </div>' 
							+ '<div class="post-content col-6 p-1 align-items-center" onclick="viewVideo(\''  //viewVideo호출
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

var visited = 0;
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
		
		if(visited == 0){
			item.style.background = "#F0F0F0";
		}
		else if(visited == 1){
			ori_item.style.background = "transparent";
			item.style.background = "#F0F0F0";
		}
		
		if(ori_playlistID !== 0){
			$.ajax({ 
				'type' : "post",
				'url' : "${pageContext.request.contextPath}/student/class/changevideo",
				'data' : {
							lastTime : player.getCurrentTime(),
							videoID : playlist[ori_index].id, // 원래 비디오 id
							//classID : classID, //classID
							playlistID :playlist[0].playlistID,
							classPlaylistID : classContent.id,
							timer : 0
				},
				success : function(data){
					ori_index = index; // 원래 인덱스에 index를 넣는다.
					ori_videoID = id;
					ori_playlistID = playlist[index].playlistID;
					ori_classContentID = weekContents[seq].id;
					ori_item = item;
					visited = 1;
				}, 
				error : function(err){
					alert("changevideo playlist 추가 실패! : ", err.responseText);
				}
			}); 
		
			if(playlist[index].lastTime > 0.0){ //이미 보던 영상이다.
				startTime = playlist[index].lastTime;
				howmanytime = playlist[index].timer;
				watchedFag = 1;
			}
			
			player.loadVideoById({'videoId': videoID,
	             'startSeconds': startTime,
	             'endSeconds': endTime,
	             'suggestedQuality': 'default'})
		}
		else{ // url -> video
			
			if(playlist[index].lastTime > 0.0){ //이미 보던 영상이다.
				startTime = playlist[index].lastTime;
				howmanytime = playlist[index].timer;
				watchedFag = 1;
			}
			
			player.loadVideoById({'videoId': videoID,
	             'startSeconds': startTime,
	             'endSeconds': endTime,
	             'suggestedQuality': 'default'})
			
		}
		
    
	
	//이 영상을 처음보는 것이 아니라면 이전에 보던 시간부터 startTime을 설정해두기
		
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
	if(weekContents[videoIdx].playlistID == 0) //영상이 아닌 url을 클릭했을 때
	{
		videoId =  '';
		console.log("playlist가 없네요 !" + videoId);
	}
	else //영상을 클릭했을 때
	{	
		videoId = weekContents[videoIdx].thumbnailID; //videoIdx만하면 범위를 넘어선다. => url을 포함할 때 
		
	}
	player = new YT.Player('onepageLMS', {
	       height: '480',            // <iframe> 태그 지정시 필요없음
	       width: '854',             // <iframe> 태그 지정시 필요없음
	       videoId: videoId,
	       playerVars: {             // <iframe> 태그 지정시 필요없음
	           controls: '2'
	       },
	       events: {
	           'onReady': onPlayerReady,               // 플레이어 로드가 완료되고 API 호출을 받을 준비가 될 때마다 실행
	           'onStateChange': onPlayerStateChange    // 플레이어의 상태가 변경될 때마다 실행
	       }
	   });
	    
}


function onPlayerReady(event) { 
	//이거는 플레이리스트의 첫번째 영상이 실행되면서 진행되는 코드 (영상클릭없이 페이지 딱 처음 로딩되었을 )
	if(weekContents[videoIdx].playlistID == 0) return;
	
  $('.videoTitle').text(playlist[ori_index].newTitle);
  $.ajax({
		'type' : "post",
		'url' : "${pageContext.request.contextPath}/student/class/videocheck",
		'data' : {
			videoID : playlist[0].id //현재 재생중인 (플레이리스트 첫번째 영상의 ) id
		},
		success : function(data){
			
			if(data >= 0.0) { //보던 영상이라면 lastTime부터 시작
				player.loadVideoById({'videoId' : weekContents[videoIdx].thumbnailID,
							 	'startSeconds' : data,
							 	'endSeconds' : playlist[0].end_s,
							 	'suggestedQuality': 'default'})
				player.playVideo();
			}
			else{ //처음보는 영상이면 지정된 start_s부터 시작
				player.loadVideoById({'videoId' : weekContents[videoIdx].thumbnailID,
				 	'startSeconds' : playlist[0].start_s,
				 	'endSeconds' : playlist[0].end_s,
				 	'suggestedQuality': 'default'})
				player.playVideo();
			}
			
		}, 
		error : function(err){
			alert(" videocheck playlist 추가 실패! : ", err.responseText);
		}
	});
  
}


function onPlayerStateChange(event) {
	
	/*영상이 종료되었을 때 타이머 멈추도록, 영상을 끝까지 본 경우! (영상의 총 길이가 마지막으로 본 시간으로 들어간다.)*/
	if(event.data == 0){
		watchedFlag = 1;
		
		$.ajax({
			'type' : "post",
			'url' : "${pageContext.request.contextPath}/student/class/changewatch",
			'data' : {
						lastTime : player.getCurrentTime(), //lastTime에 영상의 마지막 시간을 넣어주어야 한다 
						videoID : ori_videoID,
						timer : 0, //timer도 업데이트를 위해 필요하다 
						watch : 1, //영상을 다 보았으니 시청여부는 1로(출석) 업데이트!
						playlistID : playlist[0].playlistID,
						classPlaylistID : classContent.id, //change된 classContentID사용해야한다 
						totalVideo : ori_index+1
			},
			
			success : function(data){
				//영상을 잘 봤다면, 다음 영상으로 자동재생하도록
				
				if(playlist[ori_index] != null)
					$('.videoTitle').text(playlist[ori_index].newTitle);
				
				ori_index++;
				
				if(ori_index < playlist.length){
					
					if(playlist[ori_index].lastTime >= 0.0 ){//보던 영상이라는 의미 //playlist의 마지막 영상일 때는 ori_index+1이 없어서 여기가 null이된다 
						player.loadVideoById({'videoId': playlist[ori_index].youtubeID,
				               'startSeconds': playlist[ori_index].lastTime,
				               'endSeconds': playlist[ori_index].end_s,
				               'suggestedQuality': 'default'})
					}
					else {
						player.loadVideoById({'videoId': playlist[ori_index].youtubeID,
				               'startSeconds': playlist[ori_index].start_s,
				               'endSeconds': playlist[ori_index].end_s,
				               'suggestedQuality': 'default'})
					}
				}
				
				else{
					player.pauseVideo();
				}
				
			}, 
			error : function(err){
				alert(" changewatch playlist 추가 실패! : ", err.responseText );
				
			},
		});
		
		
		
	}

	
  // 재생여부를 통계로 쌓는다.
  collectPlayCount(event.data);
}

var played = false;
function collectPlayCount(data) {
  if (data == YT.PlayerState.PLAYING && played == false) {
      // todo statistics
      played = true;
      console.log('statistics');
  }
}
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
		<jsp:include page="../outer_top_stu.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left_stu.jsp" flush="false"/>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        		 	<h4>
        		   		<button class="btn row" onclick="history.back();"> 
                			<i class="pe-7s-left-arrow h4 col-12"></i>
                			<p class="col-12 m-0">이전</p>
             			</button>
             			<span class="text-primary">${classInfo.className}</span> - 강의컨텐츠
                    </h4>    
                            
                    <div class="row">
                    	<div class="main-card mb-3 card col-md-8">
							<div class="card-body" style="margin : 0px; padding: 0px; height:auto">
								<div class="card-header" style="margin: 10px 0px; " >
									<div id="contentsTitle" style="font-size : 20px" ></div>
								</div>
                            	<div id = "onepageLMS" class="col-12 col-md-12 col-lg-12" style="margin : 0px; padding:0px;">
								</div>
								<div class="card-footer" style="margin: 10px 10px; ">
									<div id="contentsDescription" style="font-size : 15px" > </div>
								</div>
                            </div>
                        </div>
                                    
					        
						<div class="contents col-md-4" classID="${classInfo.id}">
							<div class="col-sm-12" style="max-width: 100%; height: auto;" >
	                           <nav class="" style="max-width: 100%; height: 100%;">
	                               <div id="client-paginator">
									<ul class="pagination">
	                               		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
											<li class="page-item"><a href="#target${j}" class="page-link">${j}</a></li>
										</c:forEach>
	                              	</ul>
								</div>
	                            </nav>
	                       	</div>
	                       	
	                       	<div class="main-card mb-3 card">
                                    <div class="card-body" style="overflow-y:auto; height:750px;">
                                            <div class=" ps--active-y">
                                            	<div id="accordion" class="accordion-wrapper mb-3">
													<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
														<div class="main-card mb-3 card" day="${status.index}">
															<div class="card-title p-3 m-0">
																<a name= "target${j}">${j} 차시</a> 
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
</body>
</html>

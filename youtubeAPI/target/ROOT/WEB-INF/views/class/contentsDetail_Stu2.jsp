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
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
</head>
<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>

<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>

<script>
var studentEmail = 1; //우선 임의로 넣기
//var classPlaylistID = 0;
var classID =  ${classInfo.id};
//var playlistSameCheck = ${playlistSameCheck};
//var classPlaylistID = ${classPlaylistID};
//var classContentID = 1;
var videoIdx;
var playlist; 

var ori_index =0;
var ori_videoID;
var ori_playlistID;
var ori_classContentID;

$(document).ready(function(){ //classID에 맞는 classContents를 보여주기 위함
	
	
	$.ajax({ //classID에 맞는 classContents를 보여주기 위함(playlist만 있음)
		  url : "${pageContext.request.contextPath}/student/class/weekContents",
		  type : "post",
		  async : false,
		  success : function(data) {
			  weekContents = data;
			  videoIdx = ${daySeq};
		  },
		  error : function() {
		  	alert("error");
		  }
	})
	
	
	$.ajax({ //classID에 맞는 classContents를 보여주기 위함 (Playlist가 없는 경우를 위해서)
		  url : "${pageContext.request.contextPath}/student/class/allContents",
		  type : "post",
		  async : false,
		  success : function(data) {
			  allContents = data;
			  
			  var element = document.getElementById("contentsTitle");
			  element.innerHTML = '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; margin: 0px 5px; color:dodgerblue;"></i> ' + allContents[videoIdx].title;

			  var elementD = document.getElementById("contentsDescription");
			  elementD.innerText = allContents[videoIdx].description;
				
		  },
		  error : function() {
		  	alert("error");
		  }
	})
	
	if(allContents[videoIdx].playlistID != 0) {
		$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
			url : "${pageContext.request.contextPath}/student/class/forVideoInformation",
			type : "post",
			async : false,
			data : {	
				playlistID : allContents[videoIdx].playlistID
			},
			success : function(data) {
				playlist = data; //data는 video랑 videocheck테이블 join한거 가져온다 => video랑 classContent join한거 
				console.log("playlist.length : " + playlist.length);
				ori_videoID = playlist[0].id; //첫 videoID는 선택된 classContent의 Playlist의 첫번째 영상
				ori_playlistID = allContents[videoIdx].playlistID;
				ori_classContentID = allContents[videoIdx].id;
			},
			error : function() {
				 alert("error");
			}
		})	
	}
			
	/*$.ajax({ //비디오 영상에 대한 제목과 설명가져오기 //weekContent에서 id만 알면 할 수 있다..
		url : "${pageContext.request.contextPath}/student/class/changeID",
		type : "post",
		async : false,
		success : function(data) {
			var element = document.getElementById("contentsTitle");
			element.innerHTML = '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; margin: 0px 5px; color:dodgerblue;"></i> ' + data.title;

			var elementD = document.getElementById("contentsDescription");
			elementD.innerText = data.description;
		},
		error : function() {
			alert("error");
		}
	})*/
	
	
	// 초기화면 세팅 시작!!
	
	var urlContent='';
	for(var i=0; i<allContents.length; i++){
		
		var symbol;
		
		
		if(allContents[i].playlistID == 0){ //NOT Playlist
			symbol = '<i class="pe-7s-note2 fa-lg" > </i>'
			if(videoIdx == i) {
				document.getElementById("onepageLMS").style.display = "none";
			}
			
			var day = allContents[i].days;
			var endDate = allContents[i].endDate; //timestamp -> actural time
			
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
		               + '<button type="button" onclick="showLecture(' //showLecture 현재 index는 어떻게 보내지.. 내가 누를 index말고 
						+ allContents[i].playlistID + ','   + allContents[i].id + ',' + classID + ',' + (i+1) +')"'
		 				+ 'data-toggle="collapse" data-target="#collapse' +(i+1)+ '" aria-expanded='+ area_expanded+' aria-controls="collapse0' +(i+1)+ '"class="text-left m-0 p-0 btn btn-link btn-block">'
			               + "<div class='content card align-items-center list-group-item' seq='" + allContents[i].daySeq + "' style='padding: 10px 0px 0px;' >"
							+ '<div class="row col d-flex align-items-center">'
								+ "<div class='index col-1 col-sm-1'>" + symbol + "</div>"
									
								+ "<div class='col-11 col-sm-11 col-lg-11' style='cursor: pointer;'>"
									+ "<div class='col-12 col-sm-12 card-title'>"
										+ allContents[i].title // + '  [' + convertTotalLength(weekContents[k].totalVideoLength) + ']' 
									+ '</div>'
									+ '<div class="col-sm-12">'
										+ '<div class="contentInfoBorder"></div>'
										+ '<div class="endDate contentInfo" style="padding: 0px 0px 10px;">' + '마감일: ' + endDate + '</div>'
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
									
								//	+ innerText
													
								+ '</div>'
								 	
					       	+ '</div>'
					       	+'</div>'
						+ '</div>'
	  			+ '</div>');
			
		}
		
		else{ //Playlist 
			symbol = '<i class="pe-7s-film fa-lg" style=" color:dodgerblue"> </i>'
			//document.getElementById("onepageLMS").style.display = "";//
			for(var k=0; k<weekContents.length; k++){
			
			
			if(allContents[i].playlistID == weekContents[k].playlistID){
				
				var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[k].thumbnailID + '/1.jpg">';
				var day = weekContents[k].days;
				var endDate = weekContents[k].endDate; //timestamp -> actural time
		
				classContentID = weekContents[k].id; // classContent의 id //여기 수정
				
				
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
			
			if(allContents[videoIdx].playlistID != 0){
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
					if(playlist[j].watched == 1 ){
						completed = '<div class="col-2 col-xs-2 col-lg-2"><span class="badge badge-primary"> 완료 </span></div>';
					}
						
						
					var thumbnail = '<img src="https://img.youtube.com/vi/' + playlist[j].youtubeID + '/1.jpg" style="max-width: 100%; height: 100%;">';
						
					innerText += '<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' 
									+ '<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' 
										+ '<div class="post-thumbnail col-4 col-xs-4 col-lg-4"> ' 
											+ thumbnail 
											+ '<div class="col-12" style="text-align : center">'+  convertTotalLength(playlist[j].duration) +'</div>' 
										+ ' </div>' 
										+ '<div class="post-content col-6 col-xs-6 col-lg-6 align-items-center myLecture" onclick="viewVideo(\''  //viewVideo호출
											+ playlist[j].youtubeID.toString() + '\'' + ',' + playlist[j].id + ',' 
											+ 	playlist[j].start_s + ',' + playlist[j].end_s +  ',' + j + ',' + i + ', this)" >' 
											+ 	'<div class="post-title videoNewTitle" style="font-weight:800">' + playlist[j].newTitle + '</div>' 
											+	'<div class=""> start : '+  convertTotalLength(playlist[j].start_s) + '</div>' 
											+	'<div class=""> end : '+  convertTotalLength(playlist[j].end_s) + '</div>' 
										+'</div>' 
										+ 	completed 
								+ '</div>'
								
						
								
						//ori_videoID = playlist[0].id;
				}
			}
			
			
			var content = $('.day:eq(' + day + ')');
			content.append("<div id=\'heading" +(i+1)+ "\'>"
		               + '<button type="button" onclick="showLecture(' //showLecture 현재 index는 어떻게 보내지.. 내가 누를 index말고 
						+ weekContents[k].playlistID + ','   + weekContents[k].id + ',' + classID + ',' + (i+1) +')"'
		 				+ 'data-toggle="collapse" data-target="#collapse' +(i+1)+ '" aria-expanded='+ area_expanded+' aria-controls="collapse0' +(i+1)+ '"class="text-left m-0 p-0 btn btn-link btn-block">'
			               + "<div class='content card align-items-center list-group-item' seq='" + weekContents[k].daySeq + "' style='padding: 10px 0px 0px;' >"
							+ '<div class="row col d-flex align-items-center">'
								+ '<div class="index col-1 col-sm-1 ">' + symbol + '</div>'
									
								+ "<div class='col-11 col-sm-11 col-lg-11' style='cursor: pointer;'>"
									+ "<div class='col-12 col-sm-12 card-title'>"
										+ weekContents[k].title  + '  [' + convertTotalLength(weekContents[k].totalVideoLength) + ']' 
									+ '</div>'
									+ '<div class="col-sm-12">'
										+ '<div class="contentInfoBorder"></div>'
										+ '<div class="endDate contentInfo" style="padding: 0px 0px 10px;">' + '마감일: ' + endDate + '</div>'
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
			
			/*else{// allContents[i].playlistID != weekContents[k] 가 다른경우 이렇게 아면 안될거같은데,,
				
				
			}*/
			

		}
	}
		
}	
	
	//content.append(urlContent);
		
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
function showLecture(playlistID, id, classInfo, idx){ //새로운 playlist를 선택했을 때 실행되는 함수
	//console.log("id: " + id + " idx : " + idx);
	
	if(allContents[idx-1].playlistID != 0)
		document.getElementById("onepageLMS").style.display = "";
	else 
		document.getElementById("onepageLMS").style.display = "none";
	
	n = idx;
	
	$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 다른 페이지의 컨텐츠를 시청하면 playlist가 바뀜
		  url : "${pageContext.request.contextPath}/student/class/forVideoInformation",
		  type : "post",
		  async : false,
		  data : {	
			  playlistID : playlistID
		  },
		  success : function(data) {
			 playlist = data; //data는 video랑 videocheck테이블 join한거 가져온다
			 playlist_length = Object.keys(playlist).length;
			 //console.log(ori_playlist[0].)
		  },
		  error : function() {
		  	alert("error");
		  }
	})
	
	$.ajax({ //선택된 playlistID에 맞는 영상들의 정보를 가져오기 위한 ajax // ++여기서 
			  url : "${pageContext.request.contextPath}/student/class/changeID",
			  type : "post",
			  async : false,
			  data : {	
				  id: id
			  },
			  success : function(data) {
				 console.log("changeID 성공!!!!");
				 console.log(data);

				var element = document.getElementById("contentsTitle");
				element.innerHTML = '<i class="fa fa-play-circle-o" aria-hidden="true" style="font-size: 20px; margin: 0px 5px; color:dodgerblue;"></i> ' + data.title;
				var elementD = document.getElementById("contentsDescription");
				elementD.innerText = data.description;
			  },
			  error : function() {
			  	alert("error");
			  }
	})
	
	myThumbnail(id, idx);
}

function myThumbnail(classContentID, idx){
	if(allContents[idx-1].playlistID == 0) return;
	var className = '#get_view' + idx;
	$(className).empty();
	
	console.log("이 강의 컨텐츠 내에 동영상은 " + playlist.length+ " 개 ");
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
		if(playlist[i].watched == 1 /*&& playlist[i].classContentID == classContentID*/){
			completed = '<div class="col-2 col-xs-2 col-lg-2"><span class="badge badge-primary"> 완료 </span></div>';
		}
		
		$(className).append( //stu//stu
						'<a class="nav-link active" id="post-1-tab" data-toggle="pill" role="tab" aria-controls="post-1" aria-selected="true"></a>' 
						+ '<div class="video row post-content single-blog-post style-2 d-flex align-items-center">' 
							+ '<div class="post-thumbnail col-4 col-xs-4 col-lg-4"> ' 
								+ thumbnail 
								+ '<div class="col-12" style="text-align : center">'+  convertTotalLength(playlist[i].duration) +'</div>' 
							+ ' </div>' 
							+ '<div class="post-content col-6 col-xs-6 col-lg-6 align-items-center" onclick="viewVideo(\''  //viewVideo호출
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
		
		//console.log("ori_playlistID가 바뀌는 순간! " + ori_playlistID);
		//ori_playlistID = playlist[i].playlistID ; //아니 왜.. ㅠ
		//console.log("ori_playlistID가 바뀐 후 ! " + ori_playlistID);
		
	}
	
}

var visited = 0;
function viewVideo(videoID, id, startTime, endTime, index, seq, item) { // 선택한 비디오 아이디를 가지고 플레이어 띄우기
	
	if(allContents[seq].playlistID != 0)
		document.getElementById("onepageLMS").style.display = "";
	else 
		document.getElementById("onepageLMS").style.display = "none";
	start_s = startTime;
	//$(".myLecture").css({'background-color' : 'yellow'});
	//var ori_item = item;
	//item.style.background = "lightgrey";
	//ori_item.style.background = "lightgrey";
	$('.videoTitle').text(playlist[index].newTitle); //비디오 제목 정해두기
	
	if (confirm("다른 영상으로 변경하시겠습니까? ") == true){    //확인
		flag = 0;
		time = 0;
		//clearInterval(timer); //현재 재생중인 timer를 중지하지 않고, 새로운 youtube를 실행해서 timer 두개가 실행되는 현상으로, 새로운 유튜브를 실행할 때 타이머 중지!
		
		//if, else if문은 영상을 변경했을 때, 원래 보던 영상에 대한 표시를 지우기 위한 코드
		if(visited == 0){
			item.style.background = "lightgrey";
		}
		else if(visited == 1){
			ori_item.style.background = "transparent";
			item.style.background = "lightgrey";
		}
		
		if(ori_playlistID !== undefined){
			$.ajax({ 
				'type' : "post",
				'url' : "${pageContext.request.contextPath}/student/class/changevideo",
				'data' : {
							lastTime : player.getCurrentTime(),
							studentID : studentEmail, //studentEmail
							videoID : ori_videoID, // 원래 비디오 id
							classID : classID, //classID
							playlistID :ori_playlistID,
							classPlaylistID : ori_classContentID,
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
			}); //보던 영상 정보 저장
			//보던 영상에 대해 start_s, end_s 업데이트 해두기
		
			if(playlist[index].lastTime > 0.0){ //이미 보던 영상이다.
				console.log("보던 영상~ " + playlist[index].lastTime);
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
				console.log("보던 영상~ " + playlist[index].lastTime);
				startTime = playlist[index].lastTime;
				howmanytime = playlist[index].timer;
				watchedFag = 1;
			}
			
			//onYouTubeIframeAPIReady();
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
	//var playerID = 'onepageLMS' + n;
	console.log("videoIdx : " + videoIdx);
	if(allContents[videoIdx].playlistID == 0) //영상이 아닌 url을 클릭했을 때
	{
		videoId =  weekContents[0].thumbnailID;
		console.log("playlist가 없네요 !" + videoId);
	}
	else //영상을 클릭했을 때
	{	
		console.log(weekContents);
		console.log("0 " + weekContents[0]);
		console.log("5 " + weekContents[5]);
		videoId = weekContents[videoIdx].thumbnailID; //videoIdx만하면 범위를 넘어선다. => url을 포함할 때 
		
		//videoId = weekContents[videoIdx].thumbnailID; playlist만 있을 때 
		console.log("playlist가 없네요 !" + videoId);
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
	if(allContents[videoIdx].playlistID == 0) return;
  console.log('onPlayerReady 실행');
  $('.videoTitle').text(playlist[ori_index].newTitle);
  $.ajax({
		'type' : "post",
		'url' : "${pageContext.request.contextPath}/student/class/videocheck",
		'data' : {
			studentID : studentEmail, //학생ID(email)
			videoID : playlist[0].id //현재 재생중인 (플레이리스트 첫번째 영상의 ) id
		},
		success : function(data){
			// 여기 Playlist로 해둬야하는거 아닌가?
			console.log("학생이 봤는지 안봤는지 확인중");
			if(playlist[0].lastTime >= 0.0) { //보던 영상이라면 lastTime부터 시작
				player.seekTo(playlist[0].lastTime, true);
				console.log("처음아님!!");
			}
			else{ //처음보는 영상이면 지정된 start_s부터 시작
				player.seekTo(playlsit[0].start_s, true);
				console.log("처음!");
			}
	        player.pauseVideo();
			
		}, 
		error : function(err){
			alert(" videocheck playlist 추가 실패! : ", err.responseText);
		}
	});
  console.log('onPlayerReady 마감');
  
}


function onPlayerStateChange(event) {
	
	/*영상이 시작하기 전에 이전에 봤던 곳부터 이어봤는지 물어보도록!*/
	/*if(event.data == -1) {
		//console.log("flag : " +flag+ " /watchedFlag : "+watchedFlag);
		if(flag == 0 && watchedFlag != 1){ //아직 끝까지 안봤을 때만 물어보기! //처음볼때는 물어보지 않기
			
			if (confirm("이어서 시청하시겠습니까?") == true){    
				flag = 1;
				player.playVideo();
  		}
  		
  		else{   //취소
  			player.seekTo(playlist[ori_index].start_s, true);
  			flag = 1;
  			player.playVideo();
  			return;
  		}
		}
	}*/
	
	
	/*영상이 실행될 때 타이머 실행하도록!*/
	/*if(event.data == 1) {
		
		//console.log(event.data);
		
		starFlag = false;
		timer = setInterval(function(){
			if(!starFlag){
				
	    		
		       	min = Math.floor(time/60);
		        hour = Math.floor(min/60);
		        sec = time%60;
		        min = min%60;
		
		        var th = hour;
		        var tm = min;
		        var ts = sec;
		        
		        if(th<10){
		        	th = "0" + hour;
		        }
		        if(tm < 10){
		        	tm = "0" + min;
		        }
		        if(ts < 10){
		        	ts = "0" + sec;
		        }
				
		        
		        document.getElementById("time").innerHTML = th + ":" + tm + ":" + ts;
		        db_timer = time;
		        time++;
			}
	      }, 1000);
		
		
	}*/
	
	/*영상이 일시정지될 때 타이머도 멈추도록!*/
	/*
		 if(time != 0){
		  console.log("pause!!! timer : " + timer + " time : " + time);
		      clearInterval(timer);
		      starFlag = true;
		    }
	}*/
	
	/*영상이 종료되었을 때 타이머 멈추도록, 영상을 끝까지 본 경우! (영상의 총 길이가 마지막으로 본 시간으로 들어간다.)*/
	if(event.data == 0){
		watchedFlag = 1;
		
		$.ajax({
			'type' : "post",
			'url' : "${pageContext.request.contextPath}/student/class/changewatch",
			'data' : {
						lastTime : player.getDuration(), //lastTime에 영상의 마지막 시간을 넣어주기
						studentID : studentEmail, //studentID 그대로
						videoID : playlist[ori_index].id, //videoID 그대로
						timer : 0, //timer도 업데이트를 위해 필요
						watch : 1, //영상을 다 보았으니 시청여부는 1로(출석) 업데이트!
						playlistID : playlist[0].playlistID,
						classPlaylistID : classContentID,
						classID : classID
			},
			
			success : function(data){
				//영상을 잘 봤다면, 다음 영상으로 자동재생하도록
				ori_index++;
				$('.videoTitle').text(playlist[ori_index].newTitle);
				
				if(playlist[ori_index].lastTime >= 0.0){//보던 영상이라는 의미
					player.loadVideoById({'videoId': playlist[ori_index].youtubeID,
			               'startSeconds': playlist[ori_index].lastTime,
			               'endSeconds': playlist[ori_index].end_s,
			               'suggestedQuality': 'default'})
				}
				else{
					player.loadVideoById({'videoId': playlist[ori_index].youtubeID,
			               'startSeconds': playlist[ori_index].start_s,
			               'endSeconds': playlist[ori_index].end_s,
			               'suggestedQuality': 'default'})
				}
				//move(); //영상 다 볼 때마다 시간 업데이트 해주기
			}, 
			error : function(err){
				alert(" changewatch playlist 추가 실패! : ", err.responseText );
				//console.log("실패했는데 watch : " + watch);
				
			}
		});
		
		
		
 		 if(time != 0){
 		  	console.log("stop!!");
		    clearInterval(timer);
		    starFlag = true;
		    time = 0;
		    
		  
	  	}
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
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                        		<i class="pe-7s-left-arrow fa-lg" style="margin-right: 10px" onclick="history.back();"> </i>
                            	<span class="text-primary" style="margin-left: 10px">${classInfo.className}</span>  - 강의컨텐츠	<!-- 이부분 이름 바꾸기!! -->
                            </div>
                        </div>
                    </div>    
                            
                    <div class="row">
                    
                    
                    	<div class="main-card mb-3 card card col-8 col-md-8 col-lg-8">
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
                                    
					        
						<div class="contents col-4 col-md-4 col-lg-4" classID="${classInfo.id}">
							<div class="col-sm-12" style="max-width: 100%; height: auto;" >
	                           <nav class="" aria-label="Page navigation example" style="max-width: 100%; height: 100%;">
	                               <ul class="pagination">
	                               		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
											<li class="page-item"><a href="#target${j}" class="page-link"> ${j}차시 </a></li>
										</c:forEach>
	                                   
	                              	</ul>
	                            </nav>
	                       	</div>
	                       	
	                       	<div class="main-card mb-3 card">
                                    <div class="card-body" style="overflow-y:auto; height:750px;">
                                       <!--    <div class="scroll-area-lg">   -->
                                            <div class=" ps--active-y">
                                            	<div id="accordion" class="accordion-wrapper mb-3">
													<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
														<div class="main-card mb-3 card" day="${status.index}">
						                                   <!--<div class="card-body">-->
																<a style="display: inline;" name= "target${j}"><h5> ${j} 차시 </h5></a> 
							                                    <div class="list-group day" day="${status.index}">
							                                        	
							                                    </div>
						                                  <!-- </div>-->
						                               </div>
													</c:forEach>
												</div>
                                            </div>
                                      <!-- </div>--> 
                                    </div>
                           	</div>
	                       	
							
							
						</div>
                    	<!-- 여기 기존 jsp파일 내용 넣기 -->
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
</body>
</html>

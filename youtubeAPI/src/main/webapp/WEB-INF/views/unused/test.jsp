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
    <title>내 컨텐츠</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="msapplication-tap-highlight" content="no">
    
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<link rel="stylesheet" href="/resources/demos/style.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
	
	
	<style>
		.videoPic {
			width: 120px;
			height: 70px;
			padding: 5px;
			display: inline;
		}
		
		.video:hover{
			background-color: #F0F0F0;
		}
		
		#slider-div {
		  display: flex;
		  flex-direction: row;
		  margin-top: 30px;
		}
		
		#slider-div>div {
		  margin: 8px;
		}
		
		.slider-label {
		  position: absolute;
		  background-color: #eee;
		  padding: 4px;
		  font-size: 0.88rem;
		}
	</style>
</head>
<script>
var videoId;
var videoTitle;
var videoDuration;

// player api 사용 변수 
var tag;
var firstScriptTag;
var player;

// player과 비디오 정보 수정 폼에 전달할 변수들
var limit;
var start_s;
var end_s;
var youtubeID;
var title;
var newTitle;
var videoTag;
$(document).ready(function(){
	$('.myplaylistLink').addClass('text-primary');

	getPlaylistInfo();
	getAllVideo();
	showSlider();
	setSlider();
});

function getPlaylistInfo(){
	var playlistID = ${playlistID};
	$.ajax({
		type : 'post',
		url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
		data : {'playlistID' : playlistID},
		datatype : 'json',
		success : function(result){
			var playlistName = result.playlistName;
			var totalVideo = result.totalVideo;
			var totalVideoLength = result.totalVideoLength;

			$('.displayPlaylistName').append(playlistName);

			$('#allVideo').attr('playlistID', playlistID);

			$('.playlistInfo').empty();
			var addVideoURL = "'${pageContext.request.contextPath}/video/youtube'";
			var html = '<div class="numOfVideos row d-flex align-items-center">'
							+ '<div class="col-9 row">'
								+ '<p class="numOfNow mr-1 mb-0"></p>'
								+ ' / '
								+ '<p class="numOfTotal ml-1 mb-0">' + totalVideo + '</p>'
								+ '<p class="totalVideoLength ml-2 mb-0"> [총 길이 ' + convertTotalLength(totalVideoLength) + ']</p>'
							+ '</div>'
							+ '<button type="button" class="col-4 btn btn-transition btn-outline-primary btn-sm float-right"'
							+ 		' onclick="location.href=' + addVideoURL + '" style="max-width:115px;">Youtube영상추가</button>'
						+ '</div>';
						
			$('.playlistInfo').append(html);
		}, error:function(request,status,error){
			console.log(request);
		}
	});
}

function getAllVideo(){ //해당 playlistID에 해당하는 비디오 list를 가져온다
	var playlistID = ${playlistID};
	var defaultVideoID = ${videoID};
	$.ajax({
		type : 'post',
	    url : '${pageContext.request.contextPath}/video/getOnePlaylistVideos',
	    data : {id : playlistID},
	    success : function(result){
		    videos = result.allVideo;
		    
		    $('.videos').empty();
		        
		    $.each(videos, function( index, value ){ 
		    	var tmp_newTitle = value.newTitle;
		    	var tmp_title = value.title;
				var tag = value.tag;
		    	var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg" class="videoPic">';
		    	
		    	if (tmp_title.length > 30)
					tmp_title = tmp_title.substring(0, 30) + " ..."; 
				
		    	if (tmp_newTitle == null || tmp_newTitle == ''){
		    		tmp_newTitle = tmp_title;
		    		tmp_title = '';
			    }

			    if (tag == null) tag = '';

		    	if (value.id == defaultVideoID){ //처음으로 띄울 video player설정
		    		$('.displayVideo').attr('videoID', value.id);
			    	start_s = value.start_s;
			    	end_s = value.end_s;
			    	limit = value.maxLength;
			    	youtubeID = value.youtubeID;
			    	newTitle = value.newTitle;
			    	title = value.title;
			    	videoTag = tag;
			    	
					setYouTubePlayer();
			    	setDisplayVideoInfo(index); //player 제외 선택한 video 표시 설정
				
					var addStyle = ' style="background-color:#F0F0F0; padding:5px;"';
			    }

		    	else 
		    		var addStyle = 'style="padding:5px;"';

		    	var html = '<div class="video list-group-action list-group-item row d-flex justify-content-between"'
		    				+ addStyle
							+ '>'
								+'<div class="col-11 row pr-0" onclick="playVideoFromPlaylist(this); setSlider();" ' 
									+ ' seq="' + index //이부분 seq로 바꿔야할듯?
									+ '" videoID="' + value.id 
									+ '" youtubeID="' + value.youtubeID 
									+ '" start_s="' + value.start_s
									+ '" end_s="' + value.end_s
									+ '" maxLength="' + value.maxLength + '"'
								+ '>'
							//+ '<div class="videoSeq ">' + (index+1) + '</div>'
									+ '<div class="post-thumbnail col-lg-4">'
										+ '<div class="videoSeq row">' 
											+ '<span class="col-1">' + (index+1) + '</span>'
											+ thumbnail 
										+ '</div>'
										+ '<div class="tag" tag="' + tag + '"></div>'
									+ '</div>'
									+ '<div class="col-lg-8 pr-0 d-flex row align-items-center">' 
										+ '<h6 class="post-title list-group-item-heading">' + tmp_newTitle + '</h6>'
										+ '<div class="videoOriTitle" title="' + tmp_title + '"></div>'
										+ '<p class="mb-0">' 
											+ '<span class="mr-2">시작: ' + convertTotalLength(value.start_s) + '</span>'
											+ '<span class="mr-2"> 끝: ' + convertTotalLength(value.end_s) + '</span>'
											+ '<br><span>총 길이: ' + convertTotalLength(value.duration) + '</span>'
										+ '</p>'
									+ '</div>'
								+ '</div>'
									+ '<button type="button" class="videoEditBtn col-1 btn d-sm-inline-block" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown">'
		    							+ '<i class="nav-link-icon fa fa-ellipsis-v" aria-hidden="true"></i>'
			    					+ '</button>'
			    					+ '<div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu dropdown-menu-right" x-placement="bottom-end" style="position: absolute; will-change: transform; top: 0px; left: 0px; transform: translate3d(-411px, 33px, 0px);">' 
			    						+ '<button type="button" class="dropdown-item" onclick="" >비디오 복제</button>' 
			    						+ '<button type="button" onclick="deleteVideo(' + value.id + ')" class="dropdown-item"><p class="text-danger">삭제</p></button>'
			    					+ '</div>'
							+ '</div>';
							
				$('.videos').append(html); 
			});
		}
	});
}

function playVideoFromPlaylist(item){ //오른쪽 playlist에서 비디오 클릭했을 때 실행 (처음 이 페이지가 불러와질때 제외)
	$('.displayVideo').attr('videoID', item.getAttribute('videoID'));
	var seq = item.getAttribute('seq');
	
	$('html, body').animate({scrollTop: 0 }, 'slow'); //화면 상단으로 이동 
	$('.video').css({'background-color' : '#fff'});
	$('.video:eq(' + seq + ')').css("background", "#F0F0F0"); //클릭한 video 표시

	youtubeID = item.getAttribute('youtubeID');
	start_s = item.getAttribute('start_s');
	end_s = item.getAttribute('end_s');
	limit = item.getAttribute('maxLength');

	var childs = item.childNodes;
	
	newTitle = childs[1].childNodes[0].innerText;
	title = childs[1].childNodes[1].getAttribute('title');
	videoTag = childs[0].childNodes[1].attributes[1].value;

	setDisplayVideoInfo(seq);
	
	player.loadVideoById({
		'videoId' : youtubeID,
		'startSeconds' : start_s,
		'endSeconds' : end_s
	});
}

function setDisplayVideoInfo(index){ //	선택한 비디오에 대한 정보 설정하기

	if (newTitle == null || newTitle == '')
		newTitle = title;

	$('#displayVideoTitle').empty();
	$('#displayVideoTitle').append('<b>' + title + '</b>');
	$('#inputNewTitle').val(newTitle);

	$('#inputTag').val(tag);

	$('.numOfNow').text(Number(index)+1); //클릭한 video순서 상단에 표시

	/*	
	var start_hh = Math.floor(start_s / 3600);
	var start_mm = Math.floor(start_s % 3600 / 60);
	var start_ss = start_s % 3600 % 60;

	document.getElementById("start_hh").value = start_hh;
	document.getElementById("start_mm").value = start_mm;
	document.getElementById("start_ss").value = start_ss;

	var end_hh = Math.floor(end_s / 3600);
	var end_mm = Math.floor(end_s % 3600 / 60);
	var end_ss = end_s % 3600 % 60;

	document.getElementById("end_hh").value = end_hh;
	document.getElementById("end_mm").value = end_mm;
	document.getElementById("end_ss").value = end_ss;
	*/
	
	var tmp_videoID = $('.displayVideo').attr('videoID');
	$("#inputVideoID").val( tmp_videoID *= 1 );
	
	if (videoTag != null && videoTag != ''){
		$("#inputTag").val(videoTag);
	}
	else
		$("#inputTag").val('');
}

function setYouTubePlayer() { //한번만 실행되도록 
	tag = document.createElement('script');
	tag.src = "https://www.youtube.com/iframe_api";
	firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
}

// This function creates an <iframe> (and YouTube player)
//    after the API code downloads. 
function onYouTubeIframeAPIReady() {
	player = new YT.Player('player', {
		height : '480',
		width : '854',
		videoId : videoId,
		events : {
			'onReady' : onPlayerReady,
			'onStateChange' : onPlayerStateChange
		}
	});
}
// The API will call this function when the video player is ready.
function onPlayerReady() {
	if (youtubeID == null) {
		player.playVideo();
	}
	// 플레이리스트에서 영상 선택시 player가 바로 뜰 수 있도록 함. 
	else {
		player.loadVideoById({
			'videoId' : youtubeID,
			'startSeconds' : start_s,
			'endSeconds' : end_s
		});
	}
}
// player가 끝시간을 넘지 못하게 만들기 --> 선생님한테는 끝시간을 넘길수있도록 수정해야 함
function onPlayerStateChange(state) {
	if (player.getCurrentTime() >= end_s) {
		player.pauseVideo();
		player.loadVideoById({
			'videoId' : youtubeID,
			'startSeconds' : start_s,
			'endSeconds' : end_s
		});
	}
}

function getCurrentPlayTime(e, obj) {
	e.preventDefault();

	values = $( "#slider-range" ).slider( "option", "values" );
	console.log("check initial values =>> ", values[0], values[1]);
	
	if(!validation()){
		return;
	}
	var h = Math.floor(d / 3600);
	var m = Math.floor(d % 3600 / 60);
	var s = parseFloat(d % 3600 % 60).toFixed(2);

	// 시작 버튼 클릭시: 
	if($(obj).text() == "시작"){
		// Setter 
		$( "#slider-range" ).slider( "option", "values", [ d, values[1] ] );
		start_hour = h;
		start_min = m;
		start_sec = s;

		$( "#amount" ).val( "시작: " + h + "시" + m  + "분" + s + "초" + " - 끝: " + end_hour + "시" + end_min  + "분" + end_sec + "초"  );
		
		start_time = parseFloat(d).toFixed(2);
		start_time *= 1.00;
	}
	
	// 끝 버튼 클릭시: 
	else{
		// Setter 
		$( "#slider-range" ).slider( "option", "values", [ values[0], d ] );
		end_hour = h;
		end_min = m;
		end_sec = s;
		
		$( "#amount" ).val( "시작: " + start_hour + "시" + start_min  + "분" + start_sec + "초" + " - 끝: " + h + "시" + m  + "분" + s + "초"  );

		end_time = parseFloat(d).toFixed(2);
		end_time *= 1.00;
	}

	return false;
}


// 재생 구간 유효성 검사: 
function validation(event) { //video 수정 form 제출하면 실행되는 함수
	
		return updateVideo(event);
}

function convertTotalLength(seconds){
	var seconds_hh = Math.floor(seconds / 3600);
	var seconds_mm = Math.floor(seconds % 3600 / 60);
	var seconds_ss = Math.floor(seconds % 3600 % 60);
	var result = "";
	
	if (seconds_hh > 0)
		result = ("00"+seconds_hh.toString()).slice(-2)+ ":";
	result += ("00"+seconds_mm.toString()).slice(-2) + ":" + ("00"+seconds_ss.toString()).slice(-2) ;
	
	return result;
}

function updateVideo(){ // video 정보 수정		
	alert('clicked!');
	event.preventDefault(); // avoid to execute the actual submit of the form.
	
	var tmp_videoID = $('.displayVideo').attr('videoID');
	var tmp_playlistID = $('#allVideo').attr('playlistID');

	$('#inputPlaylistID').val(tmp_playlistID);

	$.ajax({
		'type': "POST",
		'url': "${pageContext.request.contextPath}/video/updateVideo",
		'data': $("#videoForm").serialize(),
		success: function(data) {
			console.log("ajax video 수정 완료!");
			getPlaylistInfo(tmp_playlistID);
			getAllVideo(tmp_playlistID, tmp_videoID);
		},
		error: function(error) {
			//getAllPlaylist(videoID); 
			console.log("ajax video 수정 실패!" + error);
		}
	});
}

function deleteVideo(videoID){ // video 삭제
	//이부분 수정필요!!! --> 학습자료로 사용중인 비디오 있을때 체크!!!!
	if (confirm("정말 삭제하시겠습니까?")){
		var playlistID = $('.selectedPlaylist').attr('playlistID');
		changeAllVideo(videoID);
		console.log("deleteVideo: " + videoID + ":" + playlistID);
		
		$.ajax({
			'type' : "post",
			'url' : "${pageContext.request.contextPath}/video/deleteVideo",
			'data' : {	videoID : videoID,
						playlistID : playlistID
				},
			success : function(data){
				changeAllVideo(videoID); //삭제한 videoID 넘겨줘야 함.
		
			}, error : function(err){
				alert("video 삭제 실패! : ", err.responseText);
			}

		});
	}
	else false;
}

var start_hour, start_min, start_sec, end_hour, end_min, end_sec;

function showSlider(){
	$( "#slider-range" ).slider({
		range: true,
		min: 0,
		max: 500,
		/* values: [ 75, 300 ], */
		slide: function( event, ui ) {
			//$( "#amount" ).val( "시작: " + ui.values[ 0 ] + " - 끝: " + ui.values[ 1 ] );

			start_hour = Math.floor(ui.values[ 0 ] / 3600);
		    start_min = Math.floor(ui.values[ 0 ] % 3600 / 60);
		    start_sec = ui.values[ 0 ] % 60;

		    end_hour = Math.floor(ui.values[ 1 ] / 3600);
		    end_min = Math.floor(ui.values[ 1 ] % 3600 / 60);
		    end_sec = ui.values[ 1 ] % 60;

		    $( "#amount" ).val( "시작: " + start_hour + "시" + start_min  + "분" + start_sec + "초" + " - 끝: " + end_hour + "시" + end_min  + "분" + end_sec + "초"  );
		}
	});    
}

function setSlider() {
	console.log("limit값 확인 !! ", end_s);
	/* $("#slider-range").slider("destroy"); */
	/*var attributes = {
		max: limit
	}
	// update attributes
	$element.attr(attributes);

	// pass updated attributes to rangeslider.js
	$element.rangeslider('update', true); */
	$('#slider-range').slider( "option", "min", start_s);
	$('#slider-range').slider( "option", "max", end_s);

	$( "#slider-range" ).slider( "option", "values", [ start_s, end_s ] );
	//$( "#amount" ).val( "시작: " + 0 + " - 끝: " + limit );

	start_hour = Math.floor(start_s / 3600);
	start_min = Math.floor(start_s % 3600 / 60);
	start_sec = start_s % 60;

    end_hour = Math.floor(end_s / 3600);
    end_min = Math.floor(end_s % 3600 / 60);
    end_sec = end_s % 60;

	
	$( "#amount" ).val( "시작: " +start_hour+ "시" + start_min  + "분" + start_sec + "초" + " - 끝: " + end_hour + "시" + end_min  + "분" + end_sec + "초"  );
}
</script>
<body>
    <div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
    	<jsp:include page="../outer_top.jsp" flush="true"/>      
              
        <div class="app-main">
        	<jsp:include page="../outer_left.jsp" flush="true"/>
                 
                 <div class="app-main__outer">
                    <div class="app-main__inner">
	                    <h4>
							<button class="btn row" onclick="history.back();"> 
                  				<i class="pe-7s-left-arrow h3 col-12"></i>
                  				<p class="col-12 m-0">이전</p>
               				</button>
                        	<span class="displayPlaylistName text-primary"></span> 
                        </h4>	
                    	
                        <div class="row">
                            <div class="displayVideo col-lg-8 col-md-8">
								<div id="player" class="embed-responsive embed-responsive-4by3 card">
									<div class="tab-content">
					        	 		<div class="tab-pane fade show active" id="post-1" role="tabpanel" aria-labelledby="post-1-tab">
					        	 			 <div class="single-feature-post video-post bg-img"></div>
					        	 		</div>
					        	 	</div>
					        	 </div>
								
								<div class="card main-card">
									<div class="card-header">
										<h4 id="displayVideoTitle" class="m-2"></h4>
									</div>
									<form id="videoForm" onsubmit="return validation(event);">
										<div id="timeSetting">
											<input type="hidden" name="start_s" id="start_s">
											<input type="hidden" name="end_s" id="end_s">
										 	<input type="hidden" name="duration" id="duration">
										 	<input type="hidden" name="id" id="inputVideoID">
										 	<input type="hidden" name="playlistID" id="inputPlaylistID">
										 </div>
										 
										<div class="card-body">
											<div class="form-row">
                                                <div class="col-md-8">
                                                    <div class="position-relative form-group">
                                                    	<label for="inputNewTitle" class="">영상 제목 설정</label>
                                                    	<input name="newTitle" id="inputNewTitle" type="text" class="form-control">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="position-relative form-group">
                                                    	<label for="inputTag" class="">태그</label>
                                                    	<input name="tag" id="inputTag" type="text" class="form-control">
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="form-row">
                                            
	                                            <div class="setTimeRange input-group row">
	                                            	<div class="col-2 input-group-prepend">
	                                            		<button class="btn btn-outline-secondary" onclick="return getCurrentPlayTime(event, this);">시작</button>
	                                            	</div><div class="col-8"> 
	                                            		<div id="slider-range" class="ui-slider ui-corner-all ui-slider-horizontal ui-widget ui-widget-content">
	                                            			<div class="ui-slider-range ui-corner-all ui-widget-header" style="left: 0%; width: 100%;"></div>
	                                            			<span tabindex="0" class="ui-slider-handle ui-corner-all ui-state-default" style="left: 0%;"></span>
	                                            			<span tabindex="0" class="ui-slider-handle ui-corner-all ui-state-default" style="left: 100%;"></span>
	                                            		</div> 
	                                            	</div>
	                                            	<div class="col-2 input-group-append">
	                                            		<button class="btn btn-outline-secondary" onclick="return getCurrentPlayTime(event, this);">끝</button>
	                                            	</div>
	                                            </div>
	                                            <div class="position-relative row col form-group">
	                                            	<label for="amount" class="col-form-label">설정된시간</label>
	                                            	<div class="col-sm-10"> 
	                                            		<input type="text" id="amount" class="text-center col-sm-11 form-control" readonly style="border:0;"> 
	                                            	</div>
	                                            </div>
	                                            <div class="position-relative row form-group" style="display: none;">
	                                            	<div class="col-sm-2">
	                                            		<div class="col-sm-10"> 
	                                            			<div id="warning1"></div> 
	                                            		</div>
	                                            	</div>
	                                            </div>
                                                <!--  
                                                <div class="setTimeRange input-group">
                                                
													<div class="col-md-2 input-group-prepend">
														<button class="btn btn-outline-secondary" onclick="return getCurrentPlayTime(event, this);">시작</button>
													</div>
													<div class="col-md-8">
														<div id="slider-range"></div>
													</div>
													<div class="col-md-2 input-group-append">
														<button class="btn btn-outline-secondary" onclick="return getCurrentPlayTime(event, this);">끝</button>
													</div>
													<div class="col">
														<div class="position-relative row form-group">
															<label for="amount" class="col-sm-2 col-form-label"><b>설정된 시간</b></label>
															<div class="col-sm-10"> 
																<input type="text" id="amount" class="text-center col-sm-11 form-control" readonly style="border:0;"> 
															</div>
														</div>
													</div>
												</div>
												-->
                                            </div>
                                            
											<div class="col">
												<div class="divider"></div>
												<button form="videoForm" type="submit" class="btn btn-sm btn-primary float-right mb-3">업데이트</button>
											</div>
										</div>
									</form>
								</div>
	                        </div>
	                        <div id="allVideo" class="col-lg-4 col-md-4 card">
	                        	<div class="card-body">
	                        		<h5 class="card-title playlistInfo"></h5>
									<div class="videos list-group"></div>
								</div>
							</div>
	                    </div><!-- 대시보드 안 box 끝 !! -->
	                    <jsp:include page="../outer_bottom.jsp" flush="true"/>
	              </div>
              </div>
        </div>
    </div>
</body>
</html>
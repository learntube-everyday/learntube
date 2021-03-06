<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SelectedPlaylist</title>
<meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Playlist 수정</title>
 
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
	<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" /> <!-- jquery for drag&drop list order -->
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<script 
	  src="http://code.jquery.com/jquery-3.5.1.js"
	  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	  crossorigin="anonymous"></script>
	 <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	
<style>
	body {
		padding: 5px;
	}
	
	.container {
  		
  		padding-right: 15px;
		padding-left: 15px;
	    margin-right: auto;
		margin-left: auto;	
	}
	
	.videoTitle{
		margin: 10px 0;
	}
	
	#inputNewTitle{
		width: 860px;
		font-size: 20px;
	}
	
	.originalTitle{
		margin: 5px;
	}
	
	#allVideo{
		display: inline;
		float: right;
		width: 25%;
		padding: 5px;
	}
	
	.playlistInfo{
	
	}
	
	.playlistName {
		margin: 0;
		padding-bottom: 10px;
		font-size: 25px;
	}
	
	.numOfVideos{
		display: inline;
	}
	
	.numOfNow{
		display: inline;
	}
	
	.numOfTotal{
		display: inline;
	}
	
	.totalVideoLength{
		display: inline;
	}
	
	.description {
		background-color: #DCDCDC;
		padding: 5px;
	}
	
	.totalInfo{
		display: inline;
		padding-right: 5%;
	}
	
	.video:hover {
		background-color: lightgrey;
		cursor: pointer;
	}
	
	.videoNewTitle :hover{
		color: #db4437;
	}
	
	.videoSeq{
		display: inline;
	}
	
	.videoPic {
		width: 120px;
		height: 70px;
		padding: 5px;
		display: inline;
	}
	
	
	
	.tag {
		font-size: 13px;
		color: #0033CC;
	}
	
	.videoLine{
		border: 1px solid grey;
		width: 95%;
	}
	
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>

<script>
	//youtube-API 공식 문서에서 iframe 사용방법으로 나온 변수.
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
		getPlaylistInfo(${playlistID});
		getAllVideo(${playlistID}, ${videoID}); //이전 페이지에서 사용자가 선택한 playlistID 및 처음 띄워야 할 비디오ID
	});

	function getPlaylistInfo(playlistID){
		$.ajax({
			type : 'post',
			url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
			data : {playlistID : playlistID},
			datatype : 'json',
			success : function(result){
				var playlistName = result.playlistName;
				var totalVideo = result.totalVideo;
				var totalVideoLength = result.totalVideoLength;

				$('#allVideo').attr('playlistID', playlistID);

				$('.playlistInfo').empty();
				var html = '<p class="playlistName"> "' + playlistName + '" </p>'
							+ '<div class="numOfVideos">'
								+ '<p class="numOfNow"></p>'
								+ ' / '
								+ '<p class="numOfTotal">' + totalVideo + '</p>'
							+ '</div>'
							+ '<p class="totalVideoLength"> [총 길이 ' + convertTotalLength(totalVideoLength) + ']</p>';
				$('.playlistInfo').append(html);
			}
		});
	}
	
	function getAllVideo(playlistID, defaultVideoID){ //해당 playlistID에 해당하는 비디오 list를 가져온다
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
			    	if (tmp_title.length > 30)
						tmp_title = tmp_title.substring(0, 30) + " ..."; 
					
			    	if (tmp_newTitle == null || tmp_newTitle == ''){
			    		tmp_newTitle = tmp_title;
			    		tmp_title = '';
				    }
	
			    	var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg" class="videoPic">';

					var tmp_tags = '';
			    	if (value.tag != null && value.tag.length > 0){
				    	tmp_tags = value.tag.replace(', ', ' #');
			    		tmp_tags = '#'+ tmp_tags;
			    	}

			    	if (value.id == defaultVideoID){ //처음으로 띄울 video player설정
			    		$('.displayVideo').attr('videoID', value.id);
				    	start_s = value.start_s;
				    	end_s = value.end_s;
				    	limit = value.maxLength;
				    	youtubeID = value.youtubeID;
				    	newTitle = value.newTitle;
				    	title = value.title;
				    	videoTag = value.tag;
				    	
						setYouTubePlayer();
				    	setDisplayVideoInfo(index); //player 제외 선택한 video 표시 설정
					
						var addStyle = ' style="background-color:lightgrey;" ';
				    }
			    	else 
			    		var addStyle = '';
				    
			    	var html = '<div class="video row post-content single-blog-post style-2 d-flex align-items-center" onclick="playVideoFromPlaylist(this)"'
									+ ' seq="' + index //이부분 seq로 바꿔야할듯?
									+ '" videoID="' + value.id 
									+ '" youtubeID="' + value.youtubeID 
									+ '" start_s="' + value.start_s
									+ '" end_s="' + value.end_s
									+ '" maxLength="' + value.maxLength + '"'
									+ addStyle
								+ '>'
								//+ '<div class="videoSeq ">' + (index+1) + '</div>'
								+ '<div class="post-thumbnail col-lg-4">'
								+ 	'<div class="videoSeq ">' + (index+1) + thumbnail + '</div>'
								+ 	'<div class="tag" tag="' + value.tag + '">' + tmp_tags + '</div>'
								+'</div>'
								+ '<div class="col-lg-7">' 
								+ 	'<h6 class="post-title ">' + tmp_newTitle + '</h6>'
								+ 	'<div class="videoOriTitle" style = "color :#a6a6a6; font-size: 0.1em;">' + tmp_title + '</div>'
								+ 	'<div class="duration"> ' + convertTotalLength(value.duration) + '</div>'
								+'</div>'
								+ '<a href="#" class="aDeleteVideo col-lg-1 badge badge-primary" onclick="deleteVideo(' + value.id + ')"> 삭제</a>'
							+ '</div>'
							+ '<div class="videoLine"></div>';
					$('.videos').append(html); 
				});
			}
		});
	}
	
	function playVideoFromPlaylist(item){ //오른쪽 playlist에서 비디오 클릭했을 때 실행 (처음 이 페이지가 불러와질때 제외)
	//console.log(item);
		$('.displayVideo').attr('videoID', item.getAttribute('videoID'));
		
		$('html, body').animate({scrollTop: 0 }, 'slow'); //화면 상단으로 이동 
		$('.video').css({'background-color' : 'unset'});
		item.style.background = "lightgrey"; //클릭한 video 표시

		youtubeID = item.getAttribute('youtubeID');
		start_s = item.getAttribute('start_s');
		end_s = item.getAttribute('end_s');
		limit = item.getAttribute('maxLength');

		var childs = item.childNodes;
		
		newTitle = childs[1].childNodes[0].innerText;
		title = childs[1].childNodes[1].innerText;
		videoTag = childs[0].childNodes[1].attributes[1].value;

		setDisplayVideoInfo(item.getAttribute('seq'));
		
		player.loadVideoById({
			'videoId' : youtubeID,
			'startSeconds' : start_s,
			'endSeconds' : end_s
		});
	}

	function setDisplayVideoInfo(index){ //비디오 플레이어가 뜰 때 같이 사용자에게 나타내야 할 부분 설정

		if (newTitle == null || newTitle == '' || newTitle == title){
			newTitle = title;
			title = '';
		}
		$('.videoTitle').empty();
		var html =  '<input type="text" name="newTitle" id="inputNewTitle" value="' + newTitle+ '">'
					+ '<p class="originalTitle">' + title + '</p>';
		$('.videoTitle').append(html);
		
		showForm();

		$('.numOfNow').text(Number(index)+1); //클릭한 video순서 상단에 표시
				
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
		
		var tmp_videoID = $('.displayVideo').attr('videoID');
		$("#inputVideoID").val( tmp_videoID *= 1 );
		
		if (videoTag != null && videoTag != ''){
			$("#inputTag").val(videoTag);
			console.log("not null");
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
	
	// 구간 설정 자바스크립트 
	// 영상 검색과 함께 영상 구간 설정을 위한 form (원래 숨겨있던 것) 보여주기:
	function showForm() {
		var saveForm = document.getElementById("videoForm");
		saveForm.style.display = "block";
	}
	
	// Youtube player 특정 위치로 재생 위치 이동 : 
	function seekTo1() {
		// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
		var start_hh = $('#start_hh').val();
		var start_mm = $('#start_mm').val();
		var start_ss = $('#start_ss').val();
		start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss
				* 1.00;
		player.seekTo(start_time);
	}
	
	function seekTo2() {
		var end_hh = $('#end_hh').val();
		var end_mm = $('#end_mm').val();
		var end_ss = $('#end_ss').val();
		end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
		player.seekTo(end_time);
	}
	
	// 현재 재생위치를 시작,끝 시간에 지정 
	function getCurrentPlayTime1() {
		var d = Number(player.getCurrentTime());
		var h = Math.floor(d / 3600);
		var m = Math.floor(d % 3600 / 60);
		var s = d % 3600 % 60;
		document.getElementById("start_ss").value = parseFloat(s).toFixed(2);
		document.getElementById("start_hh").value = h;/* .toFixed(2); */
		document.getElementById("start_mm").value = m;/* .toFixed(2); */
		document.getElementById("start_s").value = parseFloat(d).toFixed(2);
		start_time = parseFloat(d).toFixed(2);
		start_time *= 1.00;
		//console.log("check:", typeof start_time);
	}
	function getCurrentPlayTime2() {
		var d = Number(player.getCurrentTime());
		var h = Math.floor(d / 3600);
		var m = Math.floor(d % 3600 / 60);
		var s = d % 3600 % 60;
		document.getElementById("end_ss").value = parseFloat(s).toFixed(2);
		document.getElementById("end_hh").value = h;/* .toFixed(2); */
		document.getElementById("end_mm").value = m;/* .toFixed(2); */
		document.getElementById("end_s").value = parseFloat(d).toFixed(2);
		end_time = parseFloat(d).toFixed(2);
		end_time *= 1.00;
		//console.log("check", typeof end_time);
	}
	
	// 재생 구간 유효성 검사: 
	function validation(event) { //video 추가 form 제출하면 실행되는 함수
		event.preventDefault();
		document.getElementById("warning1").innerHTML = "";
		document.getElementById("warning2").innerHTML = "";
		
		// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
		var start_hh = $('#start_hh').val();
		var start_mm = $('#start_mm').val();
		var start_ss = $('#start_ss').val();
		start_time = start_hh * 3600 + start_mm * 60 + start_ss* 1;
		$('#start_s').val(start_time);
		console.log(start_time);
		
		var end_hh = $('#end_hh').val();
		var end_mm = $('#end_mm').val();
		var end_ss = $('#end_ss').val();
		end_time = end_hh * 3600 + end_mm * 60 + end_ss * 1;
		$('#end_s').val(end_time);
		console.log(end_time);
		
		$('#duration').val(parseInt(end_time - start_time));
		
		if (start_time > end_time) {
			document.getElementById("warning1").innerHTML = "시작시간은 끝시간보다 크지 않아야 합니다.";
			document.getElementById("start_ss").focus();
			return false;
		}
		if (end_time > limit) {
			document.getElementById("warning2").innerHTML = "끝시간은 영상 길이보다 크지 않아야 합니다.";
			document.getElementById("end_ss").focus();
			return false;
		} 
		else 
			return updateVideo(event);
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

	function updateVideo(){ // video 정보 수정		
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

</script>
<body>
	<ul class="nav nav-tabs" role="tablist">
			<li class="nav-item">
		      <a class="nav-link active" href="#">내 컨텐츠</a>
		    </li>
		    <li class="nav-item">
		      <a class="nav-link"href='${pageContext.request.contextPath}/youtube'>Youtube영상추가</a>
		    </li>
		    <li class="nav-item">
		      <a class="nav-link" href='${pageContext.request.contextPath}/playlist/searchLms'>LMS 내 컨텐츠</a>
		    </li>
		</ul>
		
	<div class="container">
		<div class = "row ">
			<div class="displayVideo col-lg-8">
				<div id="player" class="embed-responsive embed-responsive-4by3">
					<div class="tab-content">
	        	 		<div class="tab-pane fade show active" id="post-1" role="tabpanel" aria-labelledby="post-1-tab">
	        	 			 <div class="single-feature-post video-post bg-img">
	        	 			 </div>
	        	 		</div>
	        	 	</div>
	        	 </div>
				
				<div id="timeSetting" class="col-12 col-md-12 col-lg-12">
					<form id="videoForm" onsubmit="return validation(event)" style="display: none">
						<input type="hidden" name="start_s" id="start_s">
						<input type="hidden" name="end_s" id="end_s">
					 	<input type="hidden" name="duration" id="duration">
					 	<input type="hidden" name="id" id="inputVideoID">
					 	<input type="hidden" name="playlistID" id="inputPlaylistID">
					 	
					 	
						<div class="col-12 col-md-12 col-lg-12 m-2">
							<button onclick="getCurrentPlayTime1()" type="button" class="btn btn-sm btn-light"> start time </button> : 
							<input type="text" id="start_hh" maxlength="2" size="2" style="border: none; background: transparent;"> 시 
							<input type="text" id="start_mm" maxlength="2" size="2" style="border: none; background: transparent;"> 분 
							<input type="text" id="start_ss" maxlength="5" size="2" style="border: none; background: transparent;"> 초 
							<button onclick="seekTo1()" type="button" class="btn btn-sm btn-light"> <i class="fa fa-share" aria-hidden="true"></i> </button>
							<span id=warning1 style="color:red;"></span> <br>
						</div>
						
						<div class="col-12 col-md-12 col-lg-12 m-2">
							<button onclick="getCurrentPlayTime2()" type="button" class="btn btn-sm btn-light"> end time </button> : 
							<input type="text" id="end_hh" max="" maxlength="2" size="2" style="border: none; background: transparent;"> 시 
							<input type="text" id="end_mm" max="" maxlength="2" size="2" style="border: none; background: transparent;"> 분 
							<input type="text" id="end_ss" maxlength="5" size="2" style="border: none; background: transparent;"> 초     
							<button onclick="seekTo2()" type="button" class="btn btn-sm btn-light"> <i class="fa fa-share" aria-hidden="true"></i> </button> 
							<span id=warning2 style="color:red;"></span> <br>
						</div>
						
						<div class="col-12 col-md-12 col-lg-12">
							태그추가: <input type="text" id="inputTag" name="tag">
							<button form="videoForm" type="submit" class="btn btn-sm btn-primary">업데이트</button>
						</div>
					</form>
				</div>
			
			</div>
		
			<div id="allVideo" class="col-lg-4">
				<div class="playlistInfo"></div>
				<div class="videos"></div>
			</div>
	</div>
</div>

</body>
</html>
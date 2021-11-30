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
	<title>Youtube 영상추가</title>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
	
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
	<meta name="msapplication-tap-highlight" content="no">
	
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
</head>
<style>
.video {
	padding: 7px;
}
.info {
	font-size: 12px;
} 
img {
	width: 128px;
	height: 80px;
	padding: 5px;
}
.playlistSeq {
	background-color: #cecece;
	padding: 10px;
	margin: 5px;
}
.container {
	margin-left: 15px !important;
}
.container-fluid {
	margin: 7px;
	width: 500px;
	float: right;
}
/* 이동 타켓 */
.card-placeholder {
	border: 1px dashed grey;
	margin: 0 1em 1em 0;
	height: 50px;
	margin-left: auto;
	margin-right: auto;
	background-color: #E8E8E8;
}

/* 마우스 포인터을 손가락으로 변경 */
.card:not(.no-move) .card-header {
	cursor: pointer;
}

.card {
	border-radius: 5px;
}

.displayResultList{
	overflow-y: scroll; 
	height: 80vh;
}

</style>
<script>
var email;
$(document).ready(function(){
	//getAllMyPlaylist(email); //나중에는 사용자 로그인정보로 email 가져와야할듯..
	
	//var allMyClass = JSON.parse('${allMyClass}');
	/* for(var i=0; i<allMyClass.length; i++){
		var name = allMyClass[i].className;
		var classContentURL = '${pageContext.request.contextPath}/class/contentList/' + allMyClass[i].id;
		var html = '<li>'
						+ '<a href="#">'
							+ '<i class="metismenu-icon pe-7s-notebook"></i>'
							+ name
							+ ' <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>'
						+ '</a>'
						+ '<ul>'
							+ '<li>'
								+ '<a href="#">'
									+ '<i class="metismenu-icon"></i>'
									+ '공지'
								+ '</a>'
							+ '</li>'
							+ '<li>'
								+ '<a href="' + classContentURL + '">'
									+ '<i class="metismenu-icon"></i>'
									+ '학습 컨텐츠'
								+ '</a>'
							+ '</li>'
							+ '<li>'
								+ '<a href="#">'
									+ '<i class="metismenu-icon"></i>'
									+ '성적'
								+ '</a>'
							+ '</li>'
						+ '</ul>'
					+ '</li>';
				
		$('.sideClassList').append(html);
	} */
	// Playlist 이름 보여지게 하기
	//console.log(JSON.stringify(localStorage.getItem("selectedPlaylist")));
	console.log(localStorage.getItem("selectedPlaylistName"));
	$("#playlistName").before('<h4 class="text-primary" style="display:inline-block">' + localStorage.getItem("selectedPlaylistName") + '</h4>');

	
});
</script>

<script>
	var maxResults = "20";
	var idList = [ maxResults ]; //youtube Search 결과 저장 array
	var titleList = [ maxResults ];
	var dateList = [ maxResults ];
	var viewCount = [ maxResults ];
	var likeCount = [ maxResults ];
	var dislikeCount = [ maxResults ];
	var durationCount = [ maxResults ];
	var count = 0;
	
	function fnGetList(sGetToken) { // youtube api로 검색결과 가져오기 
		count = 0;
		var $getval = $("#search_box").val(); 
		var $getorder = $("#opt").val();
		if ($getval == "") {
			alert("검색어를 입력하세요.");
			$("#search_box").focus();
			return;
		}
		$("#get_view").empty();
		$("#nav_view").empty();
		var key = "AIzaSyC0hiwYHhlDC98F1v9ERNXnziHown0nGjg"; //"AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c"; //
		//var accessToken = "${accessToken}";
		var sTargetUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&order="
				+ $getorder
				+ "&q="
				+ encodeURIComponent($getval) //encoding
				+ "&key=" + key
				//+ "&access_token="
				//+ accessToken
				+ "&maxResults="
				+ maxResults
				+ "&type=video";
		if (sGetToken != null) { //이전 or 다음페이지 이동할때 해당 페이지 token
			sTargetUrl += "&pageToken=" + sGetToken + "";
		}
		$.ajax({
					type : "POST",
					url : sTargetUrl, //youtube-search api 
					dataType : "jsonp",
					async : false,
					success : function(jdata) {
						if (jdata.error) { //api 할당량 끝났을 때 에러메세지
							$("#nav_view").append(
									'<p>검색 일일 한도가 초과되었습니다 나중에 다시 시도해주세요!</p>');
						}
						//console.log(jdata);
						$(jdata.items)
								.each(
								function(i) {
									setAPIResultToList(i, this.id.videoId,
											this.snippet.title,
											this.snippet.publishedAt);
								})
								.promise()
								.done($(jdata.items).each(
									function(i) {
										var id = idList[i];
										var getVideo = "https://www.googleapis.com/youtube/v3/videos?part=statistics,contentDetails&id="
												+ id
												+ "&key=" + key;
												//+ "&access_token="
												//+ accessToken;
	
										$.ajax({
													type : "GET",
													url : getVideo, //youtube-videos api
													dataType : "jsonp",
													success : function(jdata2) {
														//console.log(jdata2);
														setAPIResultDetails(
																i,
																jdata2.items[0].statistics.viewCount,
																jdata2.items[0].statistics.likeCount,
																jdata2.items[0].statistics.dislikeCount,
																jdata2.items[0].contentDetails.duration);
													},
													error : function(xhr, textStatus) {
														console.log(xhr.responseText);
														alert("video detail 에러");
														return;
													}
	
												})
									}));
						if (jdata.prevPageToken) {
							lastAndNext(jdata.prevPageToken, '<p class="page-link" aria-label="Previous" style="display:inline;"><span aria-hidden="true">«</span><span class="sr-only">Previous</span></p>');
						}
						if (jdata.nextPageToken) {
							lastAndNext(jdata.nextPageToken, '<p class="page-link" aria-label="Next" style="display:inline;"><span aria-hidden="true">»</span><span class="sr-only">Next</span></p>');
						}
					},
					error : function(xhr, textStatus) {
						console.log(xhr.responseText);
						alert("an error occured for searching");
						return;
					}
				});
	}
	
	function viewPlayer(){
		$('.playerForm').css({display: "block"});
	}	
	
	function displayResultList() { //페이지별로 video 정보가 다 가져와지면 이 함수를 통해 결과 list 출력
		for (var i = 0; i < maxResults; i++) {
			var id = idList[i];
			var view = viewCount[i];
			var title = titleList[i].replace("'", "’").replace("/\"/g","\\\""); //titleList[i].replace("'", "&apos;").replace("\"","&quot;");
	
			/* title = `${title}`; */
			
			var thumbnail = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg" class="" '
				+ 'style="width: 100%; height:100%; max-width: 300px; max-height: 200px; min-width: 100px; min-height: 80px; cursor: pointer;" onclick="changeCardSize(); viewPlayer(); viewVideo2(\'' + id.toString()
			+ '\'' + ',\'' + `\${title}` + '\''
			+ ',\'' + durationCount[i] + '\'' + ',' + i + '); setSlider();" >';
			//var url = '<a href="https://youtu.be/' + id + '">';
			var link = "'${pageContext.request.contextPath}/player";
			link = link + "?id=" + id.toString();
			link = link + "?title=" + `\${title}`;
			link = link + "?duration=" + durationCount[i] + "'";
			$("#get_view").append(					
					/* '<div class="searchedVideo" onclick="$(#form2).submit();">' */
					
					/* 	'<ul class="list-group">'
                        + '<button class="list-group-item-action list-group-item">Dapibus ac facilisis in</button>'
                        <button class="list-group-item-action list-group-item">Morbi leo risus</button>
                        <button class="list-group-item-action list-group-item">Porta ac consectetur ac</button>
                        <button class="disabled list-group-item-action list-group-item">Vestibulum at eros</button>
                    </ul> */
					
					'<div class="searchedVideo list-group-item-action list-group-item" >'
							+ '<div class="row">'
								+ '<div class="col-sm-4">'
									+ thumbnail
								+ '</div>'
								/* + '<div class="col-sm-1"> </div>' */
								+ '<div class="col-sm-8 " style="display: flex; align-items: center;">'
									+ '<div onclick="changeCardSize(); viewPlayer(); viewVideo2(\'' + id.toString()
									+ '\'' + ',\'' + `\${title}` + '\''
									+ ',\'' + durationCount[i] + '\'' + ',' + i + '); setSlider();" style="cursor: pointer; ">'
										+ '<p class="mb-1"><b>' + `\${title}` + '</b></p>'
										+ '<div>'
											+ '<span class="info m-0"> published: <b>' + dateList[i]
											+ '</b> view: <b>' + view
											+ '</b> like: <b>' + likeCount[i]
											+ '</b> dislike: <b>' + dislikeCount[i]
											+ '</b> </span>'
										+ '</div>'
									+ '</div>'
								+ '</div>'
							+ '</div>'
					+ '</div>');
							/* + '<div style="display:none">'
							+ '<div id="player_info"></div>'
							+ '<div id="player"></div>' 
							+ '</div> </div>'); */
			<!-- <div id="player_info"></div> -->
			<!-- <div id="player"></div> -->
		}
	}
	function lastAndNext(token, direction) { // 검색결과 이전/다음 페이지 이동
		$("#nav_view").append(
				'<a href="javascript:fnGetList(\'' + token + '\');"> '
						+ direction + ' </a>');
	}
	function setAPIResultToList(i, id, title, date) { // search api사용할 때 데이터 저장
		idList[i] = id;
		titleList[i] = title.replace("'", "\\'").replace("\"","\\\""); // 싱글따옴표나 슬래시 들어갼것 따로 처리해줘야함!
		console.log(titleList[i]);
		dateList[i] = date.substring(0, 10);
	}
	function setAPIResultDetails(i, view, like, dislike, duration) { // videos api 사용할 때 디테일 데이터 저장 
		viewCount[i] = convertNotation(view);
		likeCount[i] = convertNotation(like);
		dislikeCount[i] = convertNotation(dislike);
		durationCount[i] = duration;
		count += 1;
		if (count == 20) displayResultList();
	}
	function convertNotation(value) { //조회수 등 단위 변환
		var num = parseInt(value);
		if (num >= 1000000)
			return (parseInt(num / 1000000) + "m");
		else if (num >= 1000)
			return (parseInt(num / 1000) + "k");
		else if (value === undefined)
			return 0;
		else
			return value;
	}
	function moveToMyPlaylist(){
		var myEmail = "yewon.lee@onepage.edu"; //이부분 로그인 구현한뒤 현재 로그인한 사용자 정보로 바꾸기 !!
		location.href = '${pageContext.request.contextPath}/playlist/myPlaylist/' + myEmail;
	}
	
</script>

<body>
	<!-- Youtube video player -->
	<script>
		// 각 video를 클릭했을 때 함수 parameter로 넘어오는 정보들
		var videoId;
		var videoTitle;
		var videoDuration;
		// player api 사용 변수 
		var tag;
		var firstScriptTag;
		var player;
		// (jw) 구간 설정: 유효성 검사시 필요 
		var limit;
		var start_s;
		var end_s;
		var youtubeID;
		var values; // slider handles 
		var d; // var for current playtime
		var d1;

		// 카트 
		var hhmmss; // 카트에서 보여지 시간 
		
		// 이전 index 존재 유무 확인
		var prev_index=null;
	
		//아래는 youtube-API 공식 문서에서 iframe 사용방법으로 나온 코드.
		tag = document.createElement('script');
		tag.src = "https://www.youtube.com/iframe_api";
		firstScriptTag = document.getElementsByTagName('script')[0];
		firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

		//var $element = $('#slider-range');
		
		function showToast(){
			$('.toast').css("display", "block");
			setTimeout("hideToast()", 8000);	
		}	

		function hideToast(){
			$('.toast').css("display", "none");
		}
		
		
		function viewVideo2(id, title, duration, index) { // 유튜브 검색결과에서 영상 아이디를 가지고 플레이어 띄우기
			console.log("여기 확인 => " + id, title, duration, index);

			// (21/10/06) youtube 플레이어 띄워주고, 제목을 띄워준다. 이 부분은 <div> 태그로 감싸져서 초록색이 나타나게 되는데 영상구간 설정 부분까지 태그로 감싸지게 해야 전체가 초록색 배경이 될듯. 
			var $div = $('<div id="playerBox" class="text-center" > <div class="iframe-container" id="player" style="width: 100%;"></div>'
					+ '<form class>'
						+ '<div id="player_info">' 
							+ '<div class="position-relative form-group col row">'
							+ '<label class="col-lg-2 col-form-label">영상제목 설정</label>'
							+ '<div class="col-lg-10"> <input type="text" id="setTitle" class="form-control" value=\''+ `\${title}` +'\'></div>'
						+ '</div>'
						+ '<div class="position-relative form-group row col">' 
							+ '<label class="col-lg-2 col-form-label">태그</label>' 
							+ '<div class="col-lg-10"><input type="text" id="setTag" name="setTag" class="form-control"> </div>'
						+ '</div>' 
						+ '<div id="setVideoInfo"> '
							+ '<div id="delete">'
							+ '<div class="position-relative form-group row col">'
							/* + '<div class="col-sm-2 col-form-label d-flex justify-content-center">' */
							+ '<label for="amount" class="col-lg-2 col-form-label">설정된시간</label>'
							/* + '</div>'  */
							+ '<div class="col-lg-10"> <input type="text" id="amount" class="text-center form-control" readonly style="border:0;"> </div>'
						+ '</div>' 
						+ '<div class="position-relative row form-group" style="display: block;">'
						+ '<div id="warning1"> </div>'
								+ '<div class="setTimeRange input-group col d-flex justify-content-between align-items-center mb-3">'
									+ '<div class="col-2 input-group-prepend pl-0">'
										//+ '<button class="btn btn-outline-secondary" onclick="return getCurrentPlayTime(event, this);">시작</button>'
									+ '</div>'
									+ '<div class="col-8"> <div id="slider-range"></div> </div>'
									+ '<div class="col-2 input-group-append">' 
										//+ '<button class="btn btn-outline-secondary" onclick="return getCurrentPlayTime(event, this);">끝</button>'
									+ '</div>' 
								+ '</div>'
								
								+ '</div>'
							+ '</div>'
							
						+ '</div>'
						+ '<div> <button id="cartButton" class="btn btn-outline-focus col-4 mb-2" onclick="return addToCart(event, \''+id+ '\'' + ',\'' +`\${title}`+'\'); ">' 
							+ '<i class="fas fa-plus-square"></i> 비디오 담기'
						+ '</button> </div>'
					+ '</form>' 
					
				+ '</div>'); 		
			
			
				var regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
				var regex_result = regex.exec(duration); //Can be anything like PT2M23S / PT2M / PT28S / PT5H22M31S / PT3H/ PT1H6M /PT1H6S

				// 영상 총길이 계산 
				// (jw) 만약 Uncaught TypeError: Cannot read properties of null (reading '1') 에러가 뜨면 해당 영상이 실시간 라이브여서 그런거임. 
				var hours = parseInt(regex_result[1] || 0);
				var minutes = parseInt(regex_result[2] || 0);
				var seconds = parseInt(regex_result[3] || 0);

				// 슬라이더 완료되면 지울것 
				$('#end_hh').val(hours);
				$("#end_mm").val(minutes); 
				$("#end_ss").val(seconds);
	
				var total_seconds = hours * 60 * 60 + minutes * 60 + seconds;
	
				// (21/10/06) 영상 총길 계산 + slider에서 validity check 을 위해 
				limit = parseInt(total_seconds);
	
				//이미 다른 영상이 player로 띄워져 있을 때 새로운 id로 띄우기
				//player.loadVideoById(videoId, 0, "large");
				
				//(//지워도 되려나..?)
				/* document.getElementById("start_hh").value = 0;
				document.getElementById("start_mm").value = 0;
				document.getElementById("start_ss").value = 0; */
			
			if(prev_index != null){
				$('#playerBox').remove();
				
			    //$("#get_view").children().eq(prev_index).attr('style', 'display: block');
			    //$("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: none');
			}
			//console.log($("#get_view").children().eq(index).children().eq(2).html());
			
			// 클릭한 영상 밑에 player 띄우기
			//$("#get_view").children().eq(index).after($div);
			
			// 오른쪽 카드 안에 player 띄우기
			console.log("player폼 확인!!=> " , $(".playerForm").children().eq(0));
			$(".playerForm").children().eq(0).append($div);
			showSlider();
			
			
			showYoutubePlayer(id, title, index);	
			prev_index = index;		
		}

		function addToCart(e, id, title){
			e.preventDefault();
			// title 은 원본 title, $('#setTitle').val() 은 사용자 지정 title 
			var thumbnail2 = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg" class="img-fluid" style="width:100%;">';
			if ($('#setTitle').val().length > 40) {
				var shortTitle = $('#setTitle').val().substring(0,40) + " ...";
			}
			else{
				var shortTitle = $('#setTitle').val();
			}
			/* if(!validation()){
				return;
			}; */
			
			//1. 
			//var content = thumbnail2 + title;
			//$("#videosInCart").append(content);
			//2.
	
				//document.getElementById('running_time').innerHTML += hhmmss; 
				//$('#running_time').html("duration: "+ hhmmss);
				//document.getElementById('running_time').innerHTML = "duration: " + hhmmss; 
				// 아직 카트 element가 생성되기 전이라서 이렇게 변수에 저장해놓은 뒤에 사용할 수 밖에 없음. 
				
				//running_time = hhmmss;
				
			// running time 구하기 * (다시 하기 ==> 21/10/07)
			start_time = start_hour*3600.00 + start_min*60.00 + start_sec*1.00;
			end_time = end_hour*3600.00 + end_min*60.00 + end_sec*1.00;
			
			const totalSeconds = end_time - start_time;
			const hours = Math.floor(totalSeconds / 3600);
		    const minutes = Math.floor(totalSeconds % 3600 / 60);
		    const seconds = parseFloat(totalSeconds % 60).toFixed(0);

		    if(hours!=0){
		    	hhmmss = hours + ':' + minutes + ':' + seconds;
		    }
		    else {
		    	hhmmss = minutes + ':' + seconds;
		    }

		  	console.log("check hhmmss ==>" , hhmmss); 
		  	
			$('#duration').val(totalSeconds);
			
			var cart_start_time;
			var cart_end_time;

			if(start_hour == 0) {
				cart_start_time = start_min + ":" + start_sec;
				cart_end_time = end_min + ":" + end_sec;
			}
			else {
				cart_start_time = start_hour + ":" + start_min + ":" + start_sec;
				cart_end_time = end_hour + ":" + end_min + ":" + end_sec;
			}
				
			var html = '<div class="videoSeq col">' 
						+ '<input type="hidden" name="youtubeID" id="inputYoutubeID" value="' + id +'">'
						+ '<input type="hidden" name="start_s" id="start_s" value="' + start_time + '">' 
						+ '<input type="hidden" name="end_s" id="end_s" value="' + end_time + '">' 
						+ '<input type="hidden" name="title" id="inputYoutubeTitle" value="' + title + '">'
						+ '<input type="hidden" name="newName" id="newName" value="'+ $('#setTitle').val() + '">'
						+ '<input type="hidden" name="maxLength" id="maxLength" value="' + limit + '">' 
						+ '<input type="hidden" name="duration" id="duration" value="' + totalSeconds + '">'
						+ '<input type="hidden" name="tag" id="tag" value="' + $('#setTag').val() + '">'
						//+ '<input type="hidden" name="duration" id="duration">'
						+ '<div class="row d-flex align-items-center">' //videoID="' + id + '" videoTitle="' + title + '">' 
						+ '<div class="form-check col-lg-1"> <input type="checkbox" id="selectToSave" name="chk"></div>'
							+ '<div class="col-lg-4">' + thumbnail2 + '</div>'
							+ '<div class="col-lg-7">'
							+ '<div><b>' + shortTitle + '</b></div>'
							+ '<div style="display:inline" value="'+cart_start_time+'"> start ' + cart_start_time + '</div>'
							+ '<div style="display:inline" value="'+cart_end_time+'"> end ' + cart_end_time + '</div>' 
							//+ '<div id="duration" style="display: none"> duration:' + $('#duration').val() + '</div>'
							+ '<div id="running_time" style="display:inline" value="'+hhmmss+'"> duration ' + hhmmss + '</div>'
						+ '</div> </div>'; 
			//3. var html = $('#setVideosInCart').html();
			$("#videosInCart").append(html); 	

			showToast(); 				
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
			console.log("limit값 확인 !! ", limit);
			/* $("#slider-range").slider("destroy"); */
			/*var attributes = {
				max: limit
			}
			// update attributes
			$element.attr(attributes);

			// pass updated attributes to rangeslider.js
			$element.rangeslider('update', true); */
			$('#slider-range').slider( "option", "min", 0);
			$('#slider-range').slider( "option", "max", limit);

			$( "#slider-range" ).slider( "option", "values", [ 0, limit ] );
			//$( "#amount" ).val( "시작: " + 0 + " - 끝: " + limit );
			
			start_hour= start_min = start_sec = 0;

		    end_hour = Math.floor(limit / 3600);
		    end_min = Math.floor(limit % 3600 / 60);
		    end_sec = limit % 60;

			$( "#amount" ).val( "시작: " +start_hour+ "시" + start_min  + "분" + start_sec + "초" + " - 끝: " + end_hour + "시" + end_min  + "분" + end_sec + "초"  );
		}
		
		function showYoutubePlayer(id, title, index){
			//$('html, body').animate({scrollTop: 0 }, 'slow'); //화면 상단으로 이동
			videoId = id;
			videoTitle = title;
			if(prev_index != null){
				/* $("#get_view").children().eq(prev_index).children().eq(0).attr('style', 'display: inline-block');
				$("#get_view").children().eq(prev_index).children().eq(1).attr('style', 'display: inline-block');
				$("#get_view").children().eq(prev_index).children().eq(2).attr('style', 'display: inline-block'); */
				
				$("#get_view").children().eq(prev_index).css("background-color", "white");
				
				console.log("check eq(1) ==> ", $("#get_view").children().eq(prev_index).children().eq(1));
				//$("#get_view").children().eq(prev_index).children().eq(1).attr('style', 'display: inline-block');
			}
			
			/* $("#get_view").children().eq(index).children().eq(0).attr('style', 'display: none');
			$("#get_view").children().eq(index).children().eq(1).attr('style', 'display: none');
			$("#get_view").children().eq(index).children().eq(2).attr('style', 'display: none'); */

			$("#get_view").children().eq(index).css("background-color", "rgb(240, 240, 240)");
			
			console.log("check videoTitle here", videoTitle);
					
			/* <span class="videoTitle bg-white p-1" style="border: 1px solid black"> </span>
			<div>
				<textarea id="newName" name="newName" cols="62" rows="2"> </textarea>
			</div> */
			onYouTubeIframeAPIReady();
			
		}
		// 3. This function creates an <iframe> (and YouTube player)
		//    after the API code downloads. 
		function onYouTubeIframeAPIReady() {
			player = new YT.Player('player', {
				videoId : videoId,
				playerVars: {
					origin: 'https://localhost:8080'
				}, 
				events : {
					'onReady' : onPlayerReady,
					'onStateChange' : onPlayerStateChange
				}
			});
		}
		// 4. The API will call this function when the video player is ready.
		function onPlayerReady() { 
			//player.playVideo();
			
			if(youtubeID == null){
				player.playVideo();
			}
			// 플레이리스트에서 영상 선택시 player가 바로 뜰 수 있도록 함. 
			else { 
				player.loadVideoById({
					'videoId': youtubeID, 
					'startSeconds': start_s, 
					'endSeconds':end_s 
				});
			}
		}
		// (jw) player가 끝시간을 넘지 못하게 만들기 : 일단 임의로 시작 시간으로 되돌리기 했는데, 하영이거에서 마지막 재생 위치에서 부터 다시 재생되게 하면 될듯. 
		function onPlayerStateChange(state) {
		    if (player.getCurrentTime() >= end_s) {
			   player.pauseVideo();
			   //player.seekTo(start_s);
			   player.loadVideoById({
					'videoId': youtubeID, 
					'startSeconds': start_s, 
					'endSeconds':end_s
				});
		    }
		  }
		function selectVideoForm(id, title, duration){
			console.log("check here!!", id);
			
			document.getElementById('playerId').value = id;
			document.getElementById('playerTitle').value = title;
			document.getElementById('playerDuration').value = duration;
			/* $(#videoId).val(id);
			$(#videoTitle).val(title);
			$(#videoDuration).val(duration); */
			
			var playerForm = document.getElementById('form2');
			playerForm.submit();
		}
		// (jw) 여기서 부터 구간 설정 자바스크립트 
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
		function getCurrentPlayTime(e, obj) {

			e.preventDefault();
			

			// Getter for slider handles 
			/* var values = $( "#slider-range" ).slider( "option", "values" );
			
			console.log(values[0]);
			console.log("check here!" , d); */

			values = $( "#slider-range" ).slider( "option", "values" );
			
			console.log("check initial values =>> ", values[0], values[1]);
			console.log("시작 시간 인지 끝 시간 확인 해보기 ==> " + $(obj).text());
			
			/* d = values[0];
			d1 = values[1]; */
			

			// 시작 버튼 클릭시: 
			if($(obj).text() == "시작"){
				d = Number(player.getCurrentTime());
				d = parseFloat(d).toFixed(2);

				console.log("시작 버튼이 클릭되었습니다 확인 ! ==> " + d);

				var h = Math.floor(d / 3600);
				var m = Math.floor(d % 3600 / 60);
				var s = parseFloat(d % 3600 % 60).toFixed(2);

				if(!validation()){ // 시작 시간이 끝시간이 넘어가지 못하게 만들기 
					return;
				} 
				
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
			else if($(obj).text() == "끝"){
				d1 = Number(player.getCurrentTime());
				d1 = parseFloat(d1).toFixed(2);

				console.log("끝버튼이 클릭되었습니다 확인 ! ==> " + d1);

				var h = Math.floor(d1 / 3600);
				var m = Math.floor(d1 % 3600 / 60);
				var s = parseFloat(d1 % 3600 % 60).toFixed(2);

				if(!validation()){ // 시작 시간이 끝시간이 넘어가지 못하게 만들기 
					return false;
				}

				// Setter 
				$( "#slider-range" ).slider( "option", "values", [ values[0], d1 ] );
				end_hour = h;
				end_min = m;
				end_sec = s;
				
				$( "#amount" ).val( "시작: " + start_hour + "시" + start_min  + "분" + start_sec + "초" + " - 끝: " + h + "시" + m  + "분" + s + "초"  );

				end_time = parseFloat(d1).toFixed(2);
				end_time *= 1.00;
			}

			return false;

			/* document.getElementById("start_ss").value = parseFloat(s).toFixed(2);
			document.getElementById("start_hh").value = h;/* .toFixed(2);
			document.getElementById("start_mm").value = m; .toFixed(2); */

			//(jw) start_s, end_s는 addToCart에서 사용되는것 가튼데 잠시 커멘트 처리 (21/10/04)
			//document.getElementById("start_s").value = parseFloat(d).toFixed(2);
			//start_time = parseFloat(d).toFixed(2);
			//start_time *= 1.00;
			//console.log("check:", typeof start_time);
		}
		
		// 재생 구간 유효성 검사: 
		function validation() { //video 추가 form 제출하면 실행되는 함수
			/* document.getElementById("warning1").innerHTML = "";
			document.getElementById("warning2").innerHTML = ""; */
			
			// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
			/* var start_hh = $('#start_hh').val();
			var start_mm = $('#start_mm').val();
			var start_ss = $('#start_ss').val();
			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss* 1.00;
			
			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val();
			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00; */

			document.getElementById("warning1").innerHTML = "";
			/* $('#warning1').text("");
			$('#warning2').text(""); */

			/* d = Number(player.getCurrentTime());
			d = parseFloat(d).toFixed(2); */

			// Getter for slider handles 
			values = $( "#slider-range" ).slider( "option", "values" );

			/* if(d>d1){
				document.getElementById("warning1").innerHTML = "시작시간은 끝시간보다 크지 않아야 합니다.";
				document.getElementById("warning1").style.color = "red";
				//document.getElementById("start_ss").focus();
				return false;
			} */
			
			if(d1<d){
				document.getElementById("warning1").innerHTML = "끝시간은 시작시간보다 크게 설정해주세요."; 
				document.getElementById("warning1").style.color = "red";
				return false;
			}

			return true;
			
		}

		// 원래 addToCart 자리 (21/10/09)
		
		function deleteFromCart(){
			$('input:checkbox:checked').each(function(i){
				console.log($(this).parent().closest('.videoSeq').remove());
			});
			// 전체 선택 체크 해제 
			$("input:checkbox[id='checkAll']").prop("checked", false); /* by ID */  
		}
		
		function selectAll(selectAll) {
			const checkboxes = document.querySelectorAll('input[type="checkbox"]');
			
			// selectAll 버튼이 눌린 순간, 다른 체크박스들도 다 모두 선택체크 박스와 같은 값을 가지도록 만든다.(on/off);  
			checkboxes.forEach((checkbox) => {
				checkbox.checked = selectAll.checked;
			})
		}
		
		function changeCardSize(){
			$("#searchArea").children().eq(0).attr('class', 'selectedPlaylist col-lg-6 card');
		}

		// 오른쪽 sidebar 닫기 버튼 클릭시 (jw) 
		function closeSidebar(){
			$('.ui-theme-settings').attr('class', 'ui-theme-settings');
		}

		// 바깥영역 클릭시 안보이게 하기 
		$('body').on('click', function(e) {
	        if($(e.target).closest('.ui-theme-settings').length == 0) {
	        	$('.ui-theme-settings').attr('class', 'ui-theme-settings');
	        }        
	    });

		function insertVideo(){ 	// video들 저장 		
				event.preventDefault(); // avoid to execute the actual submit of the form.

				var aJsonArray = new Array();
				
				console.log($('input:checkbox#selectToSave:checked'));
				
				var checkBoxArr = []; // 플레이리스트에 추가될 영상들을 저장
				$('input:checkbox[id="selectToSave"]:checked').each(function(i) {
				//$('.chk:checked').each(function(i) {
					//console.log($(this).closest('.videoSeq').children());
					//console.log($(this).closest('.videoSeq').children("#inputYoutubeTitle").val());
					checkBoxArr.push($(this).closest('.videoSeq'));
				});

				if(checkBoxArr.length==0){
					/* $('#addVideoModal').modal("hide"); */
					alert("최소 한개 이상의 동영상을 선택해주세요!"); 
					return false;
				}							

				console.log(checkBoxArr.length);

				for(let i=0; i<checkBoxArr.length; i++){

					var aJson = new Object();

					console.log(checkBoxArr[i].children('#inputYoutubeTitle').val());

					aJson.playlistID = localStorage.getItem("selectedPlaylistID");
					aJson.title = checkBoxArr[i].children('#inputYoutubeTitle').val();
					aJson.newTitle = checkBoxArr[i].children('#newName').val();
					aJson.start_s = checkBoxArr[i].children('#start_s').val();
					aJson.end_s = checkBoxArr[i].children('#end_s').val();
					aJson.youtubeID = checkBoxArr[i].children('#inputYoutubeID').val();
					aJson.maxLength = checkBoxArr[i].children('#maxLength').val();
					aJson.duration = checkBoxArr[i].children('#duration').val();
					aJson.tag = checkBoxArr[i].children('#tag').val();

					aJsonArray.push(aJson);  
				}

				var jsonData = JSON.stringify(aJsonArray);		

				console.log(jsonData);			
				
				$.ajax({
					'type' : "POST", 
					'url' : "${pageContext.request.contextPath}/video/addToPlaylist",
					'data' : jsonData,
					'contentType' : "application/json",
					success : function(data) {
						console.log("ajax video저장 완료!");
						if(!confirm("playlist에 비디오가 추가되었습니다. playlist 화면으로 이동 하시겠습니까?")){
							deleteFromCart();
						}
						else{
							var myEmail = "yewon.lee@onepage.edu"; //이부분 로그인 구현한뒤 현재 로그인한 사용자 정보로 바꾸기 !!
							location.href = '${pageContext.request.contextPath}/playlist/myPlaylist/';
							return false;
						}
					},
					error : function(error) {
						//getAlMyPlaylist();
						console.log("ajax video저장 실패!" + error);
					} 
				});
				//confirmSearch();
				return false;
		}
		
	</script>
	<div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
		<jsp:include page="../outer_top.jsp" flush="false" />
		<div class="ui-theme-settings">
            <button type="button" id="TooltipDemo" class="btn-open-options btn btn-warning">
                <img src="${pageContext.request.contextPath}/resources/img/video-cart.png"
									alt="login form" class="img-fluid"
									style="border-radius: 1rem 0 0 1rem; width: 80%; height:80%; " />
            </button>
            <div class="theme-settings__inner">
                <div class="scrollbar-container ps ps--active-y">
                    <div class="theme-settings__options-wrapper">
	               		<div class="themeoptions-heading">
	                            <!-- <div>
	                               선택된 비디오 플레이리스트
	                            </div>
	                            <button type="button" class="close ml-auto btn" aria-label="Close" onclick="closeSidebar();">
	                            	<span aria-hidden="true">×</span>
	                            </button> -->
	                            <div class="row w-100">
	                            	<div class="col">
			                            <b class="col-11 pl-0">선택된 영상 Playlist</b>
			                            <button type="button" class="close ml-auto btn" aria-label="Close" onclick="closeSidebar();" style="line-height:35px">
			                            	<span aria-hidden="true" style="font-size:18px;">X</span>
			                            </button>
	                            	</div>
	                            	<div class="videoNewTitle col-12 pl-2">
		                            	<input type="checkbox" id="checkAll" onclick="selectAll(this);"> <label class="form-check-label" for="checkAll"> 전체 선택 </label>  
										<button onclick="deleteFromCart();" class="m-0 btn-transition btn btn-danger btn-small float-right">선택 항목 삭제</button>
	                            	</div>
	                            </div>
                        </div>
                        <div id="videosInCart" class="vh-100 scrollbar-container ps--active-y ps" style="overflow-y:auto; height:750px;"></div>
                        <div style="position: fixed; left: 0; bottom: 0; width: 100%;">
					          <div class="app-footer mb-2">
					              <div class="app-footer__inner">
					                  <div class="app-footer-left">
					                  	<a href="javascript:void(0);" style="display:inline;">       
			                            	<button class="btn btn-primary mr-3" onclick="insertVideo();">
			                                  선택한 비디오 playlist에 추가
			                              	</button>
		                                </a>
					                  </div>     
					              </div>
					          </div>
					      </div>                        
                    </div>
                <div class="ps__rail-x" style="left: 0px; bottom: 0px;"><div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px;"></div></div>
                <!-- <div class="ps__rail-y" style="top: 0px; height: 446px; right: 0px;"><div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 151px;"></div></div></div> -->
                <div class="ps__rail-y ps--clicking" style="top: 0px; height: 493px; right: 0px;"><div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 184px;"></div></div></div>
            </div>
        </div>

		<div class="app-main">
			<jsp:include page="../outer_left.jsp" flush="true" />
 
			<div class="app-main__outer">
				<div class="app-main__inner">
					<h4>
						<button class="btn row" onclick="history.back();"> 
                 			<i class="pe-7s-left-arrow h3 col-12"></i>
                  			<p class="col-12 m-0">이전</p>
               			</button>
                        <span id="playlistName" class="text-primary"></span> - Youtube
					</h4>	
					

					<div class="row" id="searchArea">
						<div class="selectedPlaylist col-lg-12 card">
							<!-- <div class="card-header"> -->
							<div class="card-title playlistName m-3">

								<div class="">
									<div class="">
										<form class="form-inline" name="form1" method="post" onsubmit="return false;">
											<div class="row w-100">
												<select name="opt" id="opt" class="col-xs-3 mr-1 dropdown-toggle btn-transition btn btn-outline-secondary btn-small">
													<option value="relevance">관련순</option>
													<option value="date">날짜순</option>
													<option value="viewCount">조회순</option>
													<option value="title">문자순</option>
													<option value="rating">평가순</option>
												</select> 
												<input type="text" id="search_box"
													class="col-6 form-control mr-1">
												<button onclick="fnGetList();"
													class="btn btn-secondary btn-small">검색</button>
											</div>
										</form>
									</div>
								</div>
							</div>
							<div class="card-body displayResultList">
								<div>
									<form action="playlist/player" id="form2" method="post"
										style="display: none">
										<input type="hidden" name="playerId" id="playerId"> <input
											type="hidden" name="playerTitle" id="playerTitle"> <input
											type="hidden" name="playerDuration" id="playerDuration">
									</form>
								</div>
								<div id="get_view" style="margin-bottom: 10px;"></div>
								<div class="container d-flex justify-content-center">
									<div class="row">
										<div id="nav_view"></div>
									</div>
								</div>
							</div> 
						</div>						
						<div class="playerForm col-lg-6 form-class" style="display:none;">
							<div class="main-card card pb-3">
								<!-- form 동적으로 추가(jw) -->
							</div>
						</div>

					</div>

				</div>
				<jsp:include page="../outer_bottom.jsp" flush="false" />
			</div>
		</div>
	</div>
	
	<div id="toast-container" class="toast-top-right">
		<div class="toast toast-success" aria-live="assertive" aria-atomic="true" style="display: none;">
			<div class="toast-message"> 비디오가 담겼습니다. 플레이리스트 추가를 해주세요 ! </div>
		</div>
	</div>
	
	<!-- 동영상 추가시 나타나는 모달창  -->
	<div class="modal fade" id="addVideoModal" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" style="display: none;" aria-modal="true">
	    <div class="modal-dialog modal-sm">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLongTitle">알림창</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">
	                <p>플레이리스트에 저장되었습니다. 동영상을 더 추가하시겠습니까?</p>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">아니오 </button>
	                <button type="button" class="btn btn-primary">네 </button>
	            </div>
	        </div>
	    </div>
	</div>

</body>
</html>
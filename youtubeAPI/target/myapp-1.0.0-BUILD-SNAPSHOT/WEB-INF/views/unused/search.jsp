<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
/* html {
	font-size: 16px;
} */
video {
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
	/* padding: 10px; */
	margin: 5px;
}

/* .container-fluid {
	margin: 7px;
	width: 70%;
} */
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

.card-header {
	color: black;
	background-color: white;
	border-bottom: 1px solid;
	/* margin: 0px -10px; */
	/* padding: 5px 10px; */
	padding: 0px!important;
}

.card-body {
	font-size: 13.5px;
	background-color: white;
	color: black;
	opacity: 90%;
}

/* mouse hover 헀을시에 시각적 효과  */
.videos {
	transition: .2s ease-out; 
}
.videos:hover {
  box-shadow: 0 3px 15px rgba(0,0,0,.2);
  transform: translate3d(0,-2px,0);
}

#popup_bg{
	position: fixed;
	top: 0;
	left: 0;
	background-color: rgba(0,0,0,0.7);
	width: 100%;
	height: 100%;
}

#popup_main_div{
	postion: fixed;
	width: 400px;
	height: 500px;
	border: 2px solid black;
	border-radius: 5px;
	background-color: white;
	left: 50%;
	float: center;
	margin-right: 90px;
	margin-top: 70px;
	top: 50%;
}

#close_popup_div{
	position: absolute;
	width: 25px;
	height: 25px;
	border-radius: 25px;
	border: 2px solid black;
	text-align: center;
	right: 5px;
	top: 5px;
}

/* // 지워도 됨. 그냥 vertical line 그리려고 한거 */
.v1{
	border-left: 1px solid gray;
	height: 1000px;
}

@media only screen and (min-width: 1330px) {
  .col-1 {width: 0%;}
  .col-2 {width: 100%;}
}

</style>

</head>
<script src="https://code.jquery.com/jquery-3.5.1.js"
	integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	crossorigin="anonymous"></script>

<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"
	rel="stylesheet" type="text/css" />
<!-- jquery for drag&drop list order -->
<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<!-- <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<!-- fontawesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<body>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW"
		crossorigin="anonymous"></script>
	
	<script>
		function stopDefaultAction(e) { e.stopPropagation(); }
	</script>
	

	<!-- playlist CRUD -->
	<script>
		$(function() { //페이지 처음 불러올때 playlist 띄우기
			getAllPlaylist();
		});

		function togglePlaylist(index) {
			//if (e.target !== e.currentTarget) return;
			event.stopPropagation();
			var element = $(".card-body")[index], 
			style = window.getComputedStyle(element),
			display = style.getPropertyValue('display');

			if(display == "block"){
				$(".card-body")[index].setAttribute('style', 'display: none');
			}
			else{
				$(".card-body")[index].setAttribute('style', 'display: block');
			}

			var div = $(".card-header:eq(" + index + ")").find(".caret-icon");
			console.log("check for true??", div);

			if(div.hasClass("fa-caret-right")){
				div.addClass("fa-caret-down").removeClass("fa-caret-right");
			} else {
				div.addClass("fa-caret-right").removeClass("fa-caret-down");
			}
		}
		function getAllPlaylist() { //all playlist 출력
			$
					.ajax({
						type : 'post',
						url : '${pageContext.request.contextPath}/playlist/getAllPlaylist',
						async : false,
						success : function(result) {
							if (result.code == "ok") {
								$('#allPlaylist').empty();
								playlists = result.allPlaylist; //order seq desc 로 가져온다.

								$
										.each(
												playlists,
												function(index, value) { //여기서 index는 playlistID가 아님! 
													var playlistID = value.id;
													var num = index;

													var hr = Math.floor(value.totalVideoLength / 3600);
													var min = Math.floor(value.totalVideoLength % 3600 / 60); 
													var sec = value.totalVideoLength % 3600 % 60;
													if(sec % 1 !=0){ 	// 소수점 있을시에는 2자리까지만 표기 하도록. 
														sec = parseFloat(sec).toFixed(2);
													}

													var thumbnail = '<img src="https://img.youtube.com/vi/' + value.thumbnailID + '/0.jpg" style="width: 150px; height: auto;">';

													var html = '<div class = "playlistSeq card text-white bg-info mb-10" >'
															+ '<div class="card-header" listID="' + playlistID + '"playlistName="' + value.playlistName + '"onclick="togglePlaylist(\'' + num + '\')" >'
															+ '<input type="checkbox" value="' + playlistID + '" class="selectPlaylists custom-control-input" style="margin:2px 4px; display:none;" onclick="stopDefaultAction(event);">'
															+ '<div style="display:inline-block">'
															+ '<i class="caret-icon fa fa-caret-right fa-lg" style="margin:5px;"></i>'
															+ (index + 1)
															+ ' : '
															+ thumbnail
															+ '</div>'
															+ '<div style="margin: 10px; display:inline-block;">'
															+ value.playlistName
															+ '<br>  ('
															+ value.totalVideo
															+ '개: '
															+ hr + '시간 ' + min + '분 ' + sec + '초 )'
															+ '<a href="#" class="aUpdatePlaylist" onclick="updatePlaylist(\''
															+ playlistID
															+ '\')" style="display:none;"> 수정 </a>'
															+ '<a href="#" class="aDeletePlaylist" onclick="deletePlaylist(\''
															+ playlistID
															+ '\')" style="display:none;"> 삭제 </a></div>'
															+ '<div class="card-body"></div>'
															+ '</div>'
															+ '</div>';

													$('#allPlaylist').append(
															html);
													getAllVideo(index);

												});
								if ($("#createVideoForm").css('display') === 'block') //video 추가할 Playlist 선택칸 보여주기
									$(".selectPlaylists").css("display",
											"inline");
							} else
								alert('playlist 불러오기 실패! ');

						},
						error : function(json) {
							console.log("ajax로 youtube api 부르기 실패 ");
						}
					});
		}

		function getAllVideo(playlistSeq) { //해당 playlistID에 해당하는 비디오들을 가져온다
			var playlistID = $(".card-header:eq(" + playlistSeq + ")").attr('listID');
		
			$(".card-body:eq(" + playlistSeq + ")").attr('style', 'display: none');

			$.ajax({
				type : 'post',
				url : '${pageContext.request.contextPath}/video/getOnePlaylistVideos',
				data : {
					id : playlistID
				},
				success : function(result) {
					videos = result.allVideo;
					$('.card-body:eq(' + playlistSeq + ')').empty();
							$.each(
									videos,
									function(index, value) {
										var title = value.title;
										if (title.length > 40) {
											title = title.substring(0,
													40)
													+ " ...";
										}
										
										if(value.newTitle == null){
											//console.log(value.newTitle);
											value.newTitle = title;
											console.log(value.newTitle);
										}

										if (value.tag != null && value.tag.length > 0){
									    	var tags = value.tag.replace(', ', ' #');
								    		tags = '#'+ tags;
								    	}
								    	else 
									    	var tags = ' ';

										var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg">';
			
										var html2 = '<div class="videos"'
												+ ' playlistSeq="'
												+ playlistSeq
												+ '" videoID="'
												+ value.id
												+ '" youtubeID="'
												+ value.youtubeID
												+ '" title="'
												+ value.title
												+ '" newTitle="'
												+ value.newTitle
												+ '" start_s="'
												+ value.start_s
												+ '" end_s="'
												+ value.end_s
												+ '" maxLength="'
												+ value.maxLength
												+ '" tag="'
												+ value.tag
												+ '" > '
												+ thumbnail
												+ '<div style="display:inline-block">'
												+ (value.seq+1)
												+ ". "
												+ value.newTitle
												+ '<br>'
												+ '<div style="text-align: right; color: blue; display:inline-block;">'
												+ tags
												+ '</div>'
												+ '</div>'
												+ '<a href="#" class="aDeleteVideo" onclick="deleteVideo('
												+ playlistSeq
												+ ','
												+ value.id
												+ ')" style="display:none;"> 삭제</a>'
												+ '</div>';

										$(
											'.card-body:eq('
													+ playlistSeq
													+ ')').append(
											html2);
									});

							if ($("#createVideoForm").css('display') === 'block') //video 추가할 Playlist 선택칸 보여주기
								$(".selectPlaylists").css("display", "inline");
						}
					});
		}

		// tag로 playlist 및 영상 찾기:
		var playlistSearch = null;

		function searchPlaylist() {

			if (playlistSearch != null) {
				playlistSearch.forEach(function(element) {
					$("[tag*='"+ element + "']").css("background-color", "#d9edf7;"); 
					$("[playlistname*='" + element + "']").css("background-color", "#17a2b8;");
				});
			}

			playlistSearch = $("#playlistSearch").val();
			playlistSearch = playlistSearch.replace(/ /g, '').split(",");

			playlistSearch.forEach(function(element) {
				$("[tag*='"+ element + "']").css("background-color", "yellow");
				$("[playlistname*='" + element + "']").css("background-color",
						"green");
			});
		}

		/* function moveToMyPlaylist(){
			var myEmail = "yewon.lee@onepage.edu"; //이부분 로그인 구현한뒤 현재 로그인한 사용자 정보로 바꾸기 !!
			location.href = '${pageContext.request.contextPath}/playlist/myPlaylist/' + myEmail;
		} */
	</script>
	
	<ul class="nav nav-tabs" role="tablist">
		<li class="nav-item"> <!-- 이부분 로그인 구현한뒤 현재 로그인한 사용자 정보로 바꾸기 !! -->
	      <a class="nav-link" href='${pageContext.request.contextPath}/playlist/myPlaylist/yewon.lee@onepage.edu'>내 컨텐츠</a> 
	    </li>
	    <li class="nav-item">
	      <a class="nav-link"href='${pageContext.request.contextPath}/youtube'>Youtube영상추가</a>
	    </li>
	    <li class="nav-item">
	      <a class="nav-link active" href="#">LMS 내 컨텐츠</a>
	    </li>
	</ul>
	
	<div class="container-fluid playlist">
		<div class="row">
			<div class="col-1 col-sm-2">
			</div>
			
			<div class="v1"></div>
			
			<div class="col-2 col-sm-8">
				<h3>LMS내 컨텐츠 검색</h3>	
	
				<!-- <div id="addPlaylist">
					<button onclick="createPlaylist()" style="width: 200px;">생 성</button>
				</div> -->
				
				<div>
					<input type="text" id="playlistSearch" placeholder="플레이리스트/ 태그 / 영상이름으로 검색 " size="40"/>
					<button onclick="searchPlaylist()">검색</button>
				</div>
				<div id="allPlaylist" class="">
					<!-- 각 카드 리스트 박스 추가되는 공간-->
				</div>
			</div>
			
			<div class="col-1 col-sm-2">
			</div>
			
		</div>
	</div>

</body>
</html>


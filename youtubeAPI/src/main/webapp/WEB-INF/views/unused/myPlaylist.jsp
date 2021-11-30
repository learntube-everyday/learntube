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
    <title>MyPlaylist</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="description" content="This is an example dashboard created using build-in elements and components.">
    <meta name="msapplication-tap-highlight" content="no">
    <!--
    =========================================================
    * ArchitectUI HTML Theme Dashboard - v1.0.0
    =========================================================
    * Product Page: https://dashboardpack.com
    * Copyright 2019 DashboardPack (https://dashboardpack.com)
    * Licensed under MIT (https://github.com/DashboardPack/architectui-html-theme-free/blob/master/LICENSE)
    =========================================================
    * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    -->
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	
	<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	 <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	 <link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" /> <!-- jquery for drag&drop list order -->
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
	
	<style>
		.playlistPic {
			width: -webkit-fill-available;
		}
		
		.playlist:hover{
			background-color: #F0F0F0;
			cursor: pointer;
		}
		
		.videoIndex {
			cursor: grab;
		}
		
		/*sortable 이동 타켓 */
		.video-placeholder {
			border: 1px dashed grey;
			margin: 0 1em 1em 0;
			height: 150px;
			margin-left:auto;
			margin-right:auto;
			background-color: #E8E8E8;
		}
		
		.videoContent:hover{
			cursor: pointer;
		}
		
		.duration{
			text-align: center;
			margin: 3px;
		}
		
		.videoNewTitle{
			font-size: 16px;
			margin: 3px 0;
			font-weight: bold;
		}
		
		.videoOriTitle {
			font-size: 13px;
			margin: 0;
		}
		
	</style>
</head>

<script>
var instructorID;

$(document).ready(function(){
	getAllMyPlaylist(); 

	$('.myplaylistLink').addClass('text-primary');	//outer_top.jsp에서 '학습컨텐츠보관함' nav-link 색깔 변경
	
});

//왼쪽 내 playlist 목록 가져오기
function getAllMyPlaylist(){
	$.ajax({
		type : 'post',
		url : '${pageContext.request.contextPath}/playlist/getAllMyPlaylist',
		success : function(result){
			playlists = result.allMyPlaylist;

			$('.myPlaylist').empty();

			if (playlists == null)
				$('.myPlaylist').append('저장된 playlist가 없습니다.');

			else{
				var setFormat = '<div class="card">'
									+ '<div class="card-body" style="min-height: 600px; overflow:auto;">'
									+ '<div class="card-title input-group">'
										+ '<div class="input-group-prepend">'
											+ '<button class="btn btn-outline-secondary">전체</button>'
											+ '<button type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="dropdown-toggle dropdown-toggle-split btn btn-outline-secondary"><span class="sr-only">Toggle Dropdown</span></button>'
											+ '<div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu" x-placement="top-start" style="position: absolute; transform: translate3d(95px, -128px, 0px); top: 0px; left: 0px; will-change: transform;"><h6 tabindex="-1" class="dropdown-header">Header</h6>'
												+ '<button type="button" tabindex="-1" class="dropdown-item">Playlist 이름</button>'
												+ '<button type="button" tabindex="0" class="dropdown-item">Video 제목</button>'
												+ '<button type="button" tabindex="0" class="dropdown-item">태그</button>'
											+ '</div>'
										+ '</div>'
										+ '<input placeholder="검색어를 입력하세요" type="text" class="form-control">'
										+ ' <div class="input-group-append">'
											+ '<button class="btn btn-secondary">검색</button>'
										+ '</div>'
									+ '</div>'
									+ '<button class="btn btn-primary col-12 mb-2" data-toggle="modal" data-target="#addPlaylistModal">+ Playlist 생성</button>'
									+ '<div><ul class="allPlaylist list-group"></div></div>'
								+ '</div>'
							+ '</div>';
				$('.myPlaylist').append(setFormat);

				$.each(playlists, function( index, value ){
					var exposed = '';
					if(value.exposed == 0)
						exposed = '<i class="pe-7s-lock float-right" margin-right: 5px;"></i>';
						
					var contentHtml = '<button class="playlist list-group-item-action list-group-item" onclick="getPlaylistInfo(' 
												+ value.id + ', ' + index + ');" playlistID="' + value.id + '" thumbnailID="' + value.thumbnailID + '">'
										+ value.playlistName + ' <i class="pe-7s-stopwatch"></i>' + convertTotalLength(value.totalVideoLength)
										+ exposed
										+ '</button>'

                	$('.allPlaylist').append(contentHtml);
				});
			}
		}, error:function(request,status,error){
			console.log(error);
		}
		
	});
}

// 왼쪽에서 플레이리스트 선택시에 영상추가 버튼 보여지게 하기 
function showAddVideoButton(playlistID, playlistName){
	$('#addVideoButton').attr('style', 'display: block');
	
}

// (jw) 여기서 얻은 playlistName, playlistID를 영상 추가 버튼에 넘겨주게 하기..? (21/09/06) 
function getPlaylistInfo(playlistID, displayIdx){ //선택한 playlist 정보 가져오기
	$.ajax({
		type : 'post',
		url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
		data : {playlistID : playlistID},
		datatype : 'json',
		success : function(result){
			var lastIdx = $('#playlistInfo').attr('displayIdx'); //새로운 결과 출력 위해 이전 저장된 정보 비우기
		    $('.playlist:eq(' + lastIdx + ')').css("background-color", "#fff");
		    $(".playlist:eq(" + displayIdx + ")").css("background-color", "#F0F0F0;"); //클릭한 playlist 표시
		    $('#playlistInfo').empty(); 
		    $('.playlistName').empty();

		    $('.selectedPlaylist').attr('playlistID', playlistID);
		    
		    var thumbnail = '<div class="row">'
			    				+ '<div class="col-sm-12">'
				    				+ '<img src="https://img.youtube.com/vi/' + result.thumbnailID + '/0.jpg" class="playlistPic">'
				    			+ '</div>'
				    			+ '<div class="col-sm-12 text-center">'
				    				+ '<button id="playAllVideo" onclick="" class="btn btn-transition btn-outline-success btn-sm mt-1 mb-2 ">playlist 전체재생</button>'
				    			+ '</div>'
			    			+ '</div>';
		    $('#playlistInfo').append(thumbnail);

			if(result.exposed == 0)
				var displayExposed = '<i class="pe-7s-lock text-focus" style="display:inline; margin-right: 5px; font-size: 13px;"><p id="displayExposed" style="display: inline;">비공개</p></i>';
			else
				var displayExposed = '<i class="fa fa-eye text-primary" style="display:inline; margin-right: 5px; font-size: 13px;"><p id="displayExposed" style="display: inline;">공개</p></i>';
					
			var name = '<h4>'
							+ displayExposed
							+ '<p id="displayPlaylistName" style="display:inline";>' + result.playlistName + '</p>'
							+ '<a href="javascript:void(0);" data-toggle="modal" data-target="#editPlaylistModal" class="nav-link editPlaylistBtn" style="display:inline;"><i class="nav-link-icon fa fa-cog"></i></a>'
					+ '</h4>';
		    $('.playlistName').append(name); //중간영역 
		    
			//var modDate = convertTime(result.modDate);
			var totalVideoLength = convertTotalLength(result.totalVideoLength);
			var description = result.description;
			if (result.description == null)
				description = "설명 없음";
			if (result.tag != null && result.tag.length > 0){
		    	var tags = result.tag.replace(', ', ' #');
	    		tags = '#'+ tags;
	    	}
	    	else 
		    	var tags = ' ';

			var info = '<div class="info">' 
							+ '<div>'
								+ '<p class="totalInfo"> 총 영상 <b>' + result.totalVideo + '개</b></p>'
								+ '<p class="totalInfo"> 총 재생시간 <b>' + totalVideoLength + '</b></p>'
							+ '</div>'
							+ '<p> 업데이트 <b>' + result.modDate + '</b> </p>'
							+ '<p id="displayTag" class="text-primary">' + tags + '</p>'
							+ '<div class="description card-border card card-body border-secondary">'
								+ '<p id="displayDescription">' + description + '</p>'
							+ '</div>'
						+ '</div>';
						
			$('#playlistInfo').append(info);
		    $('#playlistInfo').attr('displayIdx', displayIdx); //현재 오른쪽에 가져와진 playlistID 저장

			getAllVideo(playlistID); //먼저 playlist info 먼저 셋팅하고 videolist 가져오기

			showAddVideoButton(playlistID, result.playlistName); 

			// (jw) playlistID를 설정해서 
			console.log(result.playlistName);
			localStorage.setItem("selectedPlaylistName", result.playlistName);
			localStorage.setItem("selectedPlaylistID", playlistID);
		}
	});
	
}

function getAllVideo(playlistID){ //해당 playlistID에 해당하는 비디오들을 가져온다
	$.ajax({
		type : 'post',
	    url : '${pageContext.request.contextPath}/video/getOnePlaylistVideos',
	    data : {id : playlistID},
	    success : function(result){
		    videos = result.allVideo;
		    
		    $('#allVideo').empty();
			
		   	if(videos.length == 0)
				$('#allVideo').append('<div><p>현재 저장된 영상이 없습니다. 영상을 추가해주세요!</p></div>');
			
		   	else {
			    $.each(videos, function( index, value ){
			    	var newTitle = value.newTitle;
			    	var title = value.title;
			    	//if (title.length > 45
						//title = title.substring(0, 45) + " ..."; 
					
			    	if (newTitle == null || newTitle == ''){
			    		newTitle = title;
						title = '';
				    }
	
			    	var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg" class="videoPic img-fluid">';
	
			    	if (value.tag != null && value.tag.length > 0){
				    	var tags = value.tag.replace(', ', ' #');
			    		tags = '#'+ tags;
			    	}
			    	else 
				    	var tags = ' ';
	
			    	var address = "'${pageContext.request.contextPath}/video/" + value.playlistID + '/' + value.id + "'";
			    	var passData = 'moveToVideoDetail(' + value.playlistID + ', ' + value.id + ');';
			    	
			    	if (index == 0){
				    	var forButton = 'location.href=' + address + '';
						$("#playAllVideo").attr("onclick", forButton);
					} 
					
					var html = '<div class="row list-group-item-action list-group-item">'
									+ '<div class="video col row d-flex justify-content-between align-items-center" videoID="' + value.id + '">'
										+ '<div class="videoIndex col-sm-1 d-sm-inline-block"> <i class="fa fa-fw" aria-hidden="true"></i></p></div>'
										+ '<div class="videoContent col-sm-10 p-0 d-sm-inline-block" onclick="' + passData + '" videoID="' + value.id + '" youtubeID="' + value.youtubeID + '" >'
											+ '<div class="row">'
												+ '<div class="thumbnailBox col-sm-3 row">' 
													+ thumbnail 
													+ '<p class="duration col-sm-12"> ' + convertTotalLength(value.duration) + '</p>'
												+ '</div>'
												+ '<div class="titles col-sm-9">'
													+ '<div class="row">'
														+ '<p class="col-sm-12 text-primary">' + tags + '</p>'
														+ '<p class="videoNewTitle col-sm-12">' + newTitle + '</p>'
														+ '<p class="videoOriTitle col-sm-12">' + title + '</p>'
													+ '</div>'
												+ '</div>'
											+ '</div>'
										+ '</div>'
										+ '<div class="videoEditBtn col-sm-1 d-sm-inline-block">'
											+ '<a href="#" class="aDeleteVideo badge badge-danger" onclick="deleteVideo(' + value.id + ')"> 삭제</a>'
										+ '</div>'
										+ '</div>'
								+ '</div>';
	
					$('#allVideo').append(html); 
				});
		   	}
		}
	});
}

function moveToVideoDetail(playlistID, videoID){	//playlist의 비디오 detail page로 이동
	var html = '<input type="hidden" name="playlistID"  value="' + playlistID + '">'
				+ '<input type="hidden" name="videoID" value="' + videoID + '">';

	var goForm = $('<form>', {
			method: 'post',
			action: '${pageContext.request.contextPath}/video/detail',
			html: html
		}).appendTo('body'); 

	goForm.submit();
}

$(function() { // video 순서 drag&drop으로 순서변경
	$("#allVideo").sortable({
		connectWith: "#allVideo", // 드래그 앤 드롭 단위 css 선택자
		handle: ".videoIndex", // 움직이는 css 선택자
		cancel: ".no-move", // 움직이지 못하는 css 선택자
		placeholder: "video-placeholder", // 이동하려는 location에 추가 되는 클래스
		cursor: "grab",

		update : function(e, ui){ // 이동 완료 후, 새로운 순서로 db update
			changeAllVideo();
		}
	});
		$( "#allVideo" ).disableSelection(); //해당 클래스 하위의 텍스트는 변경x

});

function changeAllVideo(deletedID){ // video 추가, 삭제, 순서변경 뒤 해당 playlist의 전체 video order 재정렬
	var playlistID = $('.selectedPlaylist').attr('playlistID');
	var idList = new Array();

	$('.video').each(function(){
		var tmp = $(this)[0];
		var tmp_videoID = tmp.getAttribute('videoID');

		if (deletedID != null){ // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬 (db에서 삭제하는것보다 list가 더 빨리 불러와져서 이렇게 해줘야함)
			if (deletedID != tmp_videoID)
				idList.unshift(tmp_videoID); //자꾸 마지막 video부터 가져와져서 배열앞에 push 
		}
		else
			idList.unshift(tmp_videoID);
	});
	
	$.ajax({
	      type: "post",
	      url: "${pageContext.request.contextPath}/video/changeVideosOrder", //새로 바뀐 순서대로 db update
	      data : { changedList : idList },
	      dataType  : "json", 
	      success  : function(data) {
		     	getPlaylistInfo(playlistID, $('#playlistInfo').attr('displayIdx'));
	  	  		getAllVideo(playlistID); //새로 정렬한 뒤 video 새로 불러와서 출력하기
	  	  		getAllMyPlaylist(instructorID);
	    	  
	      }, error:function(request,status,error){
	    	  	getPlaylistInfo(playlistID, $('#playlistInfo').attr('displayIdx'));
	  	  		getAllVideo(playlistID);
	  	  		getAllMyPlaylist(instructorID);
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

function convertTotalLength(seconds){ //duration 변환
	var seconds_hh = Math.floor(seconds / 3600);
	var seconds_mm = Math.floor(seconds % 3600 / 60);
	var seconds_ss = parseInt(seconds % 3600 % 60); //소숫점단위 안보여주기
	var result = "";
	
	if (seconds_hh > 0)
		result = seconds_hh + ":";
	result += seconds_mm + ":" + seconds_ss;
	
	return result;
}

$(document).on("click", ".editPlaylistBtn", function () {	// edit playlist btn 눌렀을 때 modal에 데이터 전송
	var playlistID = $('.selectedPlaylist').attr('playlistID');

	//아래 내용은 이미 화면에 표시되어있기 때문에 db에서 다시 가져오지 않는다.
	var playlistName = $('#displayPlaylistName').text();
	var description = $('#displayDescription').text();
	var tags = $('#displayTag').text();
	var exposed = $('#displayExposed').text();

	while(tags){
		if (tags.indexOf('#') == -1) break;
		tags = tags.replace('#', '');
		//tags = tags.replace(' ', ', ');
	}
	
	$('#setPlaylistID').val(playlistID);
	$('#editPlaylistName').val(playlistName);
	$('#editTag').val(tags);
	$('#editPlaylistDescription').val(description);

	if(exposed == '비공개')
		$('#customSwitch2').removeAttr('checked');
	else
		$('#customSwitch2').attr('checked', "");

});

function submitAddPlaylist(){	//submit the add playlist form
	if($('#inputPlaylistName').val() == '') return false;
	
	if($('#customSwitch1').is(':checked'))
		$('#customSwitch1').val(1);
	else
		$('#customSwitch1').val(0);

	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/playlist/addPlaylist',
		data: $('#formAddPlaylist').serialize(),
		datatype: 'json',
		success: function(data){
			console.log('playlist 생성 완료!');
			location.reload();
		},
		error: function(data, status,error){
			alert('playlist 생성 실패! ');
		}
	});
}

function submitEditPlaylist(){
	if($('#editPlaylistName').val() == '') return false;
	
	if($('#customSwitch2').is(':checked'))
		$('#customSwitch2').val(1);
	else
		$('#customSwitch2').val(0);

	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/playlist/updatePlaylist',
		data: $('#formEditPlaylist').serialize(),
		datatype: 'json',
		success: function(data){
			console.log('playlist 수정 완료!');
			location.reload();
		},
		error: function(data, status,error){
			alert('playlist 수정 실패! ');
		}
	});
}

</script>
<body>
    <div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
        <jsp:include page="../outer_top.jsp" flush="true"/>      
              
        <div class="app-main">
	    	<jsp:include page="../outer_left.jsp" flush="true"/>
	    	 
             <div class="app-main__outer">                         
                <div class="app-main__inner">
					<div class="app-page-title">
		 				<div class="page-title-wrapper">
                            <div class="page-title-heading">
                            	<h4 style="padding-bottom: 2%;">내 학습컨텐츠</h4>
                            </div>
                            
                		</div>

                    	<div class="row">
			                <div class="col-md-4 col-lg-3">
								<div class="myPlaylist"></div>
							</div>
			
							<div class="selectedPlaylist col-md-8 col-lg-9 card" style="min-height: 600px;">
								<div class="card-body">
									<div class="row">
										<div class="col-lg-9 card-title playlistName">										
										</div>
										 <!-- 영상 추가 버튼 (21/09/06) -->	
									 	<div class="col-lg-3">
											 <button type="button" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown" class="float-right text-right mb-2 mr-2 dropdown-toggle btn btn-primary" id="addVideoButton" style="display: none" >영상 추가하기</button>
				                             <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu">
					                             	<%-- <form name="${pageContext.request.contextPath}/youtube" method="post" style="display:none">
					                             		<input type="hidden" name="playlistID" id="playlistID">
					                             		<input type="hidden" name="playlistName" id="playlistName">
					                             		<button type="submit" tabindex="0" class="dropdown-item">Youtube 영상검색 </button>
					                             	</form> --%>
					                             	<a role="tab" class="nav-link show" id="tab-1" href="${pageContext.request.contextPath}/video/youtube" data-target="#" aria-selected="false">
					                                   	<button type="button" tabindex="0" class="dropdown-item">Youtube 영상검색 </button>
					                               	</a>	                   
					                                	<a role="tab" class="nav-link show" id="tab-2" href="${pageContext.request.contextPath}/playlist/searchLms" data-target="#" aria-selected="false">
							                            <button type="button" tabindex="0" class="dropdown-item">LMS 영상검색 </button>
							                        </a>
				                           		</div>
									 	 </div>
									</div>
									<div class="row">
										<div class="col-lg-3">
											<div id="playlistInfo"></div>
										</div>
										<div class="divider"> </div>
										<div class="col-lg-9">
											<div id="allVideo" class="list-group list-group-flush"></div>
										</div>
									</div>
								</div>
							</div>
                    	</div>	<!-- 대시보드 안 box 끝 !! -->
                	</div>
             		<jsp:include page="../outer_bottom.jsp" flush="true"/>
          		</div>
    		</div>
    	</div>
    </div>
   
    <!-- add playlist modal -->
    <div class="modal fade" id="addPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="addPlaylistModal" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="addPlaylistModalLabel">Playlist 생성</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">
            		<form class="needs-validation" id="formAddPlaylist" method="post" novalidate>
		               	<div class="position-relative form-group">
		               		<label for="inputPlaylistName" class="">Playlist 이름</label>
		               		<input name="playlistName" id="inputPlaylistName" type="text" class="form-control" required>
		               		<div class="invalid-feedback">Playlist 이름을 입력해주세요</div>	
		               	</div>
		               	<div class="position-relative form-group">
		               		<label for="inputPlaylistDescription" class="">설명</label>
		               		<textarea name="description" id="inputPlaylistDescription" class="form-control"></textarea>
		               	</div>
	                   	<div class="position-relative form-group">
		               		<label for="inputPlaylistTag" class="">태그</label>
		               		<input name="tag" id="inputPlaylistTag" placeholder="ex) spring, 웹개발초보" type="text" class="form-control">
		               	</div>
	                   	<div class="custom-control custom-switch">
				            <input type="checkbox" checked="" name="exposed" class="custom-control-input" id="customSwitch1">
				            <label class="custom-control-label" for="customSwitch1">LMS내 공개</label>
				       	</div>
					</form>
				</div>
				<div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" form="formAddPlaylist" class="btn btn-primary" onclick="submitAddPlaylist();">생성</button>
            	</div>
	        </div>
	    </div>
	</div>
	
	<!-- edit playlist modal -->
    <div class="modal fade" id="editPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="editPlaylistModal" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="editPlaylistModalLabel">Playlist 수정</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">×</span>
	                </button>
	            </div>
	            <div class="modal-body">
	            	<form class="needs-validation" id="formEditPlaylist" method="post" novalidate>
	            		<input name="id" type="hidden" id="setPlaylistID">
		               <div class="position-relative form-group">
		               		<label for="editPlaylistName" class="">Playlist 이름</label>
		               		<input name="playlistName" id="editPlaylistName" type="text" class="form-control" required>
		               		<div class="invalid-feedback">Playlist 이름을 입력해주세요</div>
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editPlaylistDescription" class="">설명</label>
		               		<textarea name="description" id="editPlaylistDescription" class="form-control"></textarea>
		               </div>
	                   <div class="position-relative form-group">
		               		<label for="editTag" class="">태그</label>
		               		<input name="tag" id="editTag" type="text" class="form-control">
		               </div>
	                   <div class="custom-control custom-switch">
				            <input type="checkbox" checked="" name="exposed" class="custom-control-input" id="customSwitch2">
				            <label class="custom-control-label" for="customSwitch2">LMS내 공개</label>
				       </div>
			       </form>
	            </div>
	            <div class="modal-footer">
	            	<button type="button" class="btn btn-danger" data-dismiss="modal">Playlist 삭제</button>
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
	                <button type="submit" form="formEditPlaylist" class="btn btn-primary" onclick="submitEditPlaylist();">수정완료</button>
	            </div>
	        </div>
	    </div>
	</div>
	<script>
        // Example starter JavaScript for disabling form submissions if there are invalid fields
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
</body>
</html>

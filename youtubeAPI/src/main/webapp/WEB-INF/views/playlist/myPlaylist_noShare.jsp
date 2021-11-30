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
    <title>Learntube Studio</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="msapplication-tap-highlight" content="no">
	<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	 <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	 <link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" /> <!-- jquery for drag&drop list order -->
	<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
	
	<style>
	@media only screen and (max-width: 768px) {
	  /* For mobile phones: */
	  [class*="videoPic"] {
	    width: 100px;
	  }
	}
	.playlistPic {
		width: inherit;
		max-width: 300px;
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
	
	.displayPlaylist{
		overflow-y: scroll; 
		height: 64vh;
	}
		
</style>
</head>

<script>
var limit;
var start_s;
var end_s;
var youtubeID;
var values; // slider handles 
var d; // var for current playtime

$(document).ready(function(){
	getAllMyPlaylist(); 
	$('.myplaylistLink').addClass('text-primary');

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
	checkIfPlaylistIsChosen();
});

function checkIfPlaylistIsChosen(){
	var request = new Request();
	request.getParameter("playlistID");
}

function getAllMyPlaylist(){
	$.ajax({
		type : 'post',
		url : '${pageContext.request.contextPath}/playlist/getAllMyPlaylist',
		success : function(result){
			playlists = result.allMyPlaylist;
			$('.allPlaylist').empty();
		
			if(playlists.length == 0){
				$('.allPlaylist').append('<p class="text-center">저장된 playlist가 없습니다.</p>');
			}
			else{
				$.each(playlists, function( index, value ){	
					var contentHtml = '<button class="playlist list-group-item-action list-group-item" onclick="getPlaylistInfo(' 
												+ value.id + ', ' + index + ');" playlistID="' + value.id + '" thumbnailID="' + value.thumbnailID + '">'
											+ value.playlistName 
											+ '<span class="float-right"><i class="pe-7s-stopwatch"></i>' + convertTotalLength(value.totalVideoLength) + '</span>'
										+ '</button>'
                	$('.allPlaylist').append(contentHtml);
				});
			}
		}, error:function(request,status,error){
			alert('내 playliser 목록을 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}

// 왼쪽에서 플레이리스트 선택시에 영상추가 버튼 보여지게 하기 
function showAddVideoButton(playlistID, playlistName){
	$('#addVideoButton').attr('style', 'display: inline');
}

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
			var name = '<h4>'
							+ '<p id="displayPlaylistName" style="display:inline";><b>' + result.playlistName + '</b></p>'
							+ '<a href="javascript:void(0);" data-toggle="modal" data-target="#editPlaylistModal" class="nav-link editPlaylistBtn p-2" style="display:inline;"><i class="nav-link-icon fa fa-cog"></i></a>'
					+ '</h4>';
		    $('.playlistName').append(name); //중간영역 
		    
			var totalVideoLength = convertTotalLength(result.totalVideoLength);
			var description = result.description;
			var tags = result.tag;
			if (result.description == null || result.description == '') description = "설명 없음";
			if (tags != null && tags != ""){
				tags = tags.split(", ");
				if(tags.length > 1){
		    		tags = "#" + tags.join(" #");
				}
				else tags = "#" + tags;
	    	}
	    	else 
		    	tags = '';
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
			
			localStorage.setItem("selectedPlaylistName", result.playlistName);
			localStorage.setItem("selectedPlaylistID", playlistID);
		},
		error: function(error){
			alert('선택한 Playlist 정보를 가져오는데 실패했습니다! 잠시후 다시 시도해주세요:(');
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
					
			    	if (newTitle == null || newTitle == '') newTitle = value.title;
	
			    	var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg" class="videoPic img-fluid">';
	
			    	if (value.tag != null && value.tag.length > 0){
			    		var tags = value.tag.split(" ");
			    		tags = "#" + tags.join(" #");
			    	}
			    	else 
				    	var tags = ' ';
	
			    	var passData = 'moveToVideoDetail(' + value.playlistID + ', ' + value.id + ');';
			    	
			    	if (index == 0)
						$("#playAllVideo").attr("onclick", passData); 
					
					var html = '<div class="list-group-item-action list-group-item">'
									+ '<div class="video row d-flex justify-content-between align-items-center" videoID="' + value.id + '">'
										+ '<div class="videoIndex col-1 pl-2"> <i class="fa fa-fw" aria-hidden="true"></i></p></div>'
										+ '<div class="videoContent col-10 p-0 d-sm-inline-block" onclick="' + passData + '" videoID="' + value.id + '" youtubeID="' + value.youtubeID + '" >'
											+ '<div class="row">'
												+ '<div class="thumbnailBox col-sm-3 pl-0">' 
													+ thumbnail 
												+ '</div>'
												+ '<div class="titles col-md-9 d-flex align-items-center" style="text-align: left;">'
													+ '<div class="row">'
														+ '<p class="col-sm-12 text-primary mb-0">' + tags + '</p>'
														+ '<p class="videoNewTitle col-sm-12">' + newTitle + '</p>'
														+ '<p class="videoOriTitle col-sm-12 row">' 
															+ '<b>시작</b> ' + convertTotalLength(value.start_s) + ' <b class="ml-2">끝</b> ' + convertTotalLength(value.end_s) + ' <b class="ml-2">총 길이</b> ' + convertTotalLength(value.duration)
														+ '</p>'
													+ '</div>'
												+ '</div>'
											+ '</div>'
										+ '</div>'
										+ '<button type="button" class="videoEditBtn col-1 btn d-sm-inline-block" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown">'
											+ '<i class="nav-link-icon fa fa-ellipsis-v" aria-hidden="true"></i>'
										+ '</button>'
										+ '<div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu" x-placement="bottom-start" style="position: absolute; will-change: transform; top: 0px; left: 0px; transform: translate3d(218px, 96px, 0px);">' 
											//+ '<button type="button" class="dropdown-item" onclick="" >비디오 복제</button>' 
											+ '<button type="button" onclick="deleteVideo(' + value.id + ',' + value.seq + ')" class="dropdown-item"><p class="text-danger">삭제</p></button></div>'
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

function changeAllVideo(deletedID){ // video 추가, 삭제, 순서변경 뒤 해당 playlist의 전체 video order 재정렬
	var playlistID = $('.selectedPlaylist').attr('playlistID');
	var idList = new Array();
	$('.video').each(function(){
		var tmp = $(this)[0];
		var tmp_videoID = tmp.getAttribute('videoID');
		if (deletedID != null){ // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬
			if (deletedID != tmp_videoID)
				idList.unshift(tmp_videoID);
		}
		else
			idList.unshift(tmp_videoID);
	});
	
	$.ajax({
	      type: "post",
	      url: "${pageContext.request.contextPath}/video/changeVideosOrder",
	      data : { changedList : idList,
		      		playlistID : playlistID 
		      },
	      dataType  : "json", 
	      success  : function(data) {
		     	getPlaylistInfo(playlistID, $('#playlistInfo').attr('displayIdx'));
	  	  		getAllVideo(playlistID); //새로 정렬한 뒤 video 새로 불러와서 출력하기
	  	  		getAllMyPlaylist();
	    	  
	      }, error:function(request,status,error){
	    	  	getPlaylistInfo(playlistID, $('#playlistInfo').attr('displayIdx'));
	  	  		getAllVideo(playlistID);
	  	  		getAllMyPlaylist();
	       }
	    });
}

function deleteVideo(videoID, seq){ // video 삭제
	if (confirm("비디오를 정말 삭제하시겠습니까?")){
		var playlistID = $('.selectedPlaylist').attr('playlistID');
		changeAllVideo(videoID);
		
		$.ajax({
			'type' : "post",
			'url' : "${pageContext.request.contextPath}/video/deleteVideo",
			'data' : {	videoID : videoID,
						playlistID : playlistID,
						seq : seq
				},
			success : function(data){
				changeAllVideo(videoID); //삭제한 videoID 넘겨줘야 함.
			}, error : function(err){
				alert("video 삭제가 정상적으로 완료되지 않았습니다. 잠시후 다시 시도해주세요:(");
			}
		});
	}
	else false;
}

function convertTotalLength(seconds){ //시분초로 시간 변환
	var seconds_hh = Math.floor(seconds / 3600);
	var seconds_mm = Math.floor(seconds % 3600 / 60);
	var seconds_ss = parseInt(seconds % 3600 % 60); //소숫점단위 안보여주기
	var result = "";
	if((seconds_hh + '').length < 2) seconds_hh = '0'+seconds_hh;
	if((seconds_mm + '').length < 2) seconds_mm = '0'+seconds_mm;
	if((seconds_ss + '').length < 2) seconds_ss = '0'+seconds_ss;
	
	if (seconds_hh > 0)
		result = seconds_hh + ":";
	result += seconds_mm + ":" + seconds_ss;
	
	return result;
}

$(document).on("click", ".editPlaylistBtn", function () {	
	var playlistID = $('.selectedPlaylist').attr('playlistID');
	var playlistName = $('#displayPlaylistName').text();
	var description = $('#displayDescription').text();
	var tags = $('#displayTag').text();
	
	while(tags){
		if (tags.indexOf('#') == -1) break;
		tags = tags.replace('#', '');
		//tags = tags.replace(' ', ', ');
	}
	if(description == '설명 없음')	 description = null;
	
	$('#setPlaylistID').val(playlistID);
	$('#editPlaylistName').val(playlistName);
	$('#editTag').val(tags);
	$('#editPlaylistDescription').val(description);
});

function submitAddPlaylist(){
	if($('#inputPlaylistName').val() == '') return false;
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/playlist/addPlaylist',
		data: $('#formAddPlaylist').serialize(),
		datatype: 'json',
		success: function(data){
			location.reload();
		},
		error: function(data, status,error){
			alert('playlist 생성 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}

function submitEditPlaylist(){
	if($('#editPlaylistName').val() == '') return false;
	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/playlist/updatePlaylist',
		data: $('#formEditPlaylist').serialize(),
		datatype: 'json',
		success: function(data){
			location.reload();
		},
		error: function(data, status,error){
			alert('playlist 수정에 실패했습니다. 잠시후 다시 시도해주세요:(');
		}
	});
}

function submitDeletePlaylist(){
	if(confirm("Playlist를 삭제하시겠습니까? 플레이리스트의 비디오도 모두 삭제됩니다.")){
		var playlistID = $('#setPlaylistID').val();
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/playlist/deletePlaylist',
			data: {playlistID : playlistID},
			datatype: 'json',
			success: function(data){
				alert('Playlist 삭제가 완료되었습니다.');
				location.reload();
				},
			error: function(error){
				alert('Playlist 삭제에 실패했습니다. 잠시후 다시 시도해주세요:(');
				}
			});
	}
}

var keyword = null;
function search(event) {
	event.preventDefault(); // avoid to execute the actual submit of the form.

	$.ajax({
		type: 'post',
		url: '${pageContext.request.contextPath}/playlist/searchPlaylist',
		data: $("#searchForm").serialize(),
		success: function(data){
			var list = data.searched;
			$('.allPlaylist').empty();
			
			$.each(list, function( index, value ){	
				var contentHtml = '<button class="playlist list-group-item-action list-group-item" onclick="getPlaylistInfo(' 
											+ value.id + ', ' + index + ');" playlistID="' + value.id + '" thumbnailID="' + value.thumbnailID + '">'
										+ value.playlistName 
										+ '<span class="float-right"><i class="pe-7s-stopwatch"></i>' + convertTotalLength(value.totalVideoLength) + '</span>'
									+ '</button>';
            	$('.allPlaylist').append(contentHtml);
			});
		},
		error: function(data, status,error){
			alert('playlist 검색에 실패했습니다. 잠시후 다시 시도해주세요:(');
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
					<div class="app-page-title mb-0">
		 				<div class="page-title-wrapper">
                            <div class="page-title-heading">
                            	<h4 class="p-2">Learntube Studio</h4>
                            </div>
                		</div>
                    	<div class="row">
			                <div class="col-md-4 col-lg-3">
								<div class="myPlaylist">
									<div class="card">
										<div class="card-body">						
												<form id="searchForm" onsubmit="return search(event);" method="post">
													<div class="card-title input-group">
	                                                	<input placeholder="검색어를 입력하세요" type="hidden" id="searchType" name="searchType" class="mb-2 form-control" value="0">
	                                                		
	                                                	<input id="keyword" name="keyword" placeholder="검색어를 입력하세요" type="text" class="form-control">
	                                                			                                                	
	                                                	<div class="input-group-append p-0">
															<button class="btn btn-secondary" type="submit">검색</button>
														</div>    
														</div>                        

												</form>	

										<button class="btn btn-primary col-12 mb-2" data-toggle="modal" data-target="#addPlaylistModal">+ Playlist 생성</button>
										<div class="displayPlaylist">
											<ul class="allPlaylist list-group"></ul>
										</div>
									</div>
								</div>
								
								</div>
							</div>
			
							<div class="selectedPlaylist col-md-8 col-lg-9 card">
								<div class="card-body">
									<div class="row">
										<div class="col-7 card-title playlistName pr-0" style="text-align: left;">										
										</div>

									 	<div class="col-5 pl-0">
									 		<button type="button" id="addVideoButton" class="btn btn-transition btn-outline-primary float-right" 
									 				onclick="location.href='${pageContext.request.contextPath}/video/youtube'" style="display: none">Youtube 영상추가</button>
									 	 </div>
									</div>
									<div class="row">
										<div class="col-lg-3">
											<div id="playlistInfo"></div>
										</div>
										<div class="divider"> </div>
										<div class="col-lg-9">
											<div id="allVideo" class="list-group list-group-flush row"></div>
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
		               		<input name="tag" id="inputPlaylistTag" placeholder="" type="text" class="form-control">
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
			       </form>
	            </div>
	            <div class="modal-footer">
	            	<button type="button" class="btn btn-danger" onclick="submitDeletePlaylist();">Playlist 삭제</button>
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
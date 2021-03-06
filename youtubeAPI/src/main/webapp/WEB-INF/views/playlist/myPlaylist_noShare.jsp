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
	
	/*sortable μ΄λ νμΌ */
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
		connectWith: "#allVideo", // λλκ·Έ μ€ λλ‘­ λ¨μ css μ νμ
		handle: ".videoIndex", // μμ§μ΄λ css μ νμ
		cancel: ".no-move", // μμ§μ΄μ§ λͺ»νλ css μ νμ
		placeholder: "video-placeholder", // μ΄λνλ €λ locationμ μΆκ° λλ ν΄λμ€
		cursor: "grab",
		update : function(e, ui){ // μ΄λ μλ£ ν, μλ‘μ΄ μμλ‘ db update
			changeAllVideo();
		}
	});
		$( "#allVideo" ).disableSelection(); //ν΄λΉ ν΄λμ€ νμμ νμ€νΈλ λ³κ²½x
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
				$('.allPlaylist').append('<p class="text-center">μ μ₯λ playlistκ° μμ΅λλ€.</p>');
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
			alert('λ΄ playliser λͺ©λ‘μ κ°μ Έμ€λλ° μ€ν¨νμ΅λλ€. μ μν λ€μ μλν΄μ£ΌμΈμ:(');
		}
	});
}

// μΌμͺ½μμ νλ μ΄λ¦¬μ€νΈ μ νμμ μμμΆκ° λ²νΌ λ³΄μ¬μ§κ² νκΈ° 
function showAddVideoButton(playlistID, playlistName){
	$('#addVideoButton').attr('style', 'display: inline');
}

function getPlaylistInfo(playlistID, displayIdx){ //μ νν playlist μ λ³΄ κ°μ Έμ€κΈ°
	$.ajax({
		type : 'post',
		url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
		data : {playlistID : playlistID},
		datatype : 'json',
		success : function(result){
			var lastIdx = $('#playlistInfo').attr('displayIdx'); //μλ‘μ΄ κ²°κ³Ό μΆλ ₯ μν΄ μ΄μ  μ μ₯λ μ λ³΄ λΉμ°κΈ°
		    $('.playlist:eq(' + lastIdx + ')').css("background-color", "#fff");
		    $(".playlist:eq(" + displayIdx + ")").css("background-color", "#F0F0F0;"); //ν΄λ¦­ν playlist νμ
		    $('#playlistInfo').empty(); 
		    $('.playlistName').empty();
		    $('.selectedPlaylist').attr('playlistID', playlistID);
		    
		    var thumbnail = '<div class="row">'
			    				+ '<div class="col-sm-12">'
				    				+ '<img src="https://img.youtube.com/vi/' + result.thumbnailID + '/0.jpg" class="playlistPic">'
				    			+ '</div>'
				    			+ '<div class="col-sm-12 text-center">'
				    				+ '<button id="playAllVideo" onclick="" class="btn btn-transition btn-outline-success btn-sm mt-1 mb-2 ">playlist μ μ²΄μ¬μ</button>'
				    			+ '</div>'
			    			+ '</div>';
		    $('#playlistInfo').append(thumbnail);
			var name = '<h4>'
							+ '<p id="displayPlaylistName" style="display:inline";><b>' + result.playlistName + '</b></p>'
							+ '<a href="javascript:void(0);" data-toggle="modal" data-target="#editPlaylistModal" class="nav-link editPlaylistBtn p-2" style="display:inline;"><i class="nav-link-icon fa fa-cog"></i></a>'
					+ '</h4>';
		    $('.playlistName').append(name); //μ€κ°μμ­ 
		    
			var totalVideoLength = convertTotalLength(result.totalVideoLength);
			var description = result.description;
			var tags = result.tag;
			if (result.description == null || result.description == '') description = "μ€λͺ μμ";
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
								+ '<p class="totalInfo"> μ΄ μμ <b>' + result.totalVideo + 'κ°</b></p>'
								+ '<p class="totalInfo"> μ΄ μ¬μμκ° <b>' + totalVideoLength + '</b></p>'
							+ '</div>'
							+ '<p> μλ°μ΄νΈ <b>' + result.modDate + '</b> </p>'
							+ '<p id="displayTag" class="text-primary">' + tags + '</p>'
							+ '<div class="description card-border card card-body border-secondary">'
								+ '<p id="displayDescription">' + description + '</p>'
							+ '</div>'
						+ '</div>';
						
			$('#playlistInfo').append(info);
		    $('#playlistInfo').attr('displayIdx', displayIdx); //νμ¬ μ€λ₯Έμͺ½μ κ°μ Έμμ§ playlistID μ μ₯
			getAllVideo(playlistID); //λ¨Όμ  playlist info λ¨Όμ  μννκ³  videolist κ°μ Έμ€κΈ°
			showAddVideoButton(playlistID, result.playlistName); 
			
			localStorage.setItem("selectedPlaylistName", result.playlistName);
			localStorage.setItem("selectedPlaylistID", playlistID);
		},
		error: function(error){
			alert('μ νν Playlist μ λ³΄λ₯Ό κ°μ Έμ€λλ° μ€ν¨νμ΅λλ€! μ μν λ€μ μλν΄μ£ΌμΈμ:(');
		}
	});
}

function getAllVideo(playlistID){ //ν΄λΉ playlistIDμ ν΄λΉνλ λΉλμ€λ€μ κ°μ Έμ¨λ€
	$.ajax({
		type : 'post',
	    url : '${pageContext.request.contextPath}/video/getOnePlaylistVideos',
	    data : {id : playlistID},
	    success : function(result){
		    videos = result.allVideo;
		    
		    $('#allVideo').empty();
			
		   	if(videos.length == 0)
				$('#allVideo').append('<div><p>νμ¬ μ μ₯λ μμμ΄ μμ΅λλ€. μμμ μΆκ°ν΄μ£ΌμΈμ!</p></div>');
			
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
										+ '<div class="videoIndex col-1 pl-2"> <i class="fa fa-fw" aria-hidden="true">ο</i></p></div>'
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
															+ '<b>μμ</b> ' + convertTotalLength(value.start_s) + ' <b class="ml-2">λ</b> ' + convertTotalLength(value.end_s) + ' <b class="ml-2">μ΄ κΈΈμ΄</b> ' + convertTotalLength(value.duration)
														+ '</p>'
													+ '</div>'
												+ '</div>'
											+ '</div>'
										+ '</div>'
										+ '<button type="button" class="videoEditBtn col-1 btn d-sm-inline-block" aria-haspopup="true" aria-expanded="false" data-toggle="dropdown">'
											+ '<i class="nav-link-icon fa fa-ellipsis-v" aria-hidden="true"></i>'
										+ '</button>'
										+ '<div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu" x-placement="bottom-start" style="position: absolute; will-change: transform; top: 0px; left: 0px; transform: translate3d(218px, 96px, 0px);">' 
											//+ '<button type="button" class="dropdown-item" onclick="" >λΉλμ€ λ³΅μ </button>' 
											+ '<button type="button" onclick="deleteVideo(' + value.id + ',' + value.seq + ')" class="dropdown-item"><p class="text-danger">μ­μ </p></button></div>'
										+ '</div>'
								+ '</div>';
	
					$('#allVideo').append(html); 
				});
		   	}
		}
	});
}
function moveToVideoDetail(playlistID, videoID){	//playlistμ λΉλμ€ detail pageλ‘ μ΄λ
	var html = '<input type="hidden" name="playlistID"  value="' + playlistID + '">'
				+ '<input type="hidden" name="videoID" value="' + videoID + '">';
	var goForm = $('<form>', {
			method: 'post',
			action: '${pageContext.request.contextPath}/video/detail',
			html: html
		}).appendTo('body'); 
	goForm.submit();
}

function changeAllVideo(deletedID){ // video μΆκ°, μ­μ , μμλ³κ²½ λ€ ν΄λΉ playlistμ μ μ²΄ video order μ¬μ λ ¬
	var playlistID = $('.selectedPlaylist').attr('playlistID');
	var idList = new Array();
	$('.video').each(function(){
		var tmp = $(this)[0];
		var tmp_videoID = tmp.getAttribute('videoID');
		if (deletedID != null){ // μ΄ ν¨μκ° playlist μ­μ  λ€μ μ€νλμ λ μ­μ λ playlistID	 μ μΈνκ³  μ¬μ λ ¬
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
	  	  		getAllVideo(playlistID); //μλ‘ μ λ ¬ν λ€ video μλ‘ λΆλ¬μμ μΆλ ₯νκΈ°
	  	  		getAllMyPlaylist();
	    	  
	      }, error:function(request,status,error){
	    	  	getPlaylistInfo(playlistID, $('#playlistInfo').attr('displayIdx'));
	  	  		getAllVideo(playlistID);
	  	  		getAllMyPlaylist();
	       }
	    });
}

function deleteVideo(videoID, seq){ // video μ­μ 
	if (confirm("λΉλμ€λ₯Ό μ λ§ μ­μ νμκ² μ΅λκΉ?")){
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
				changeAllVideo(videoID); //μ­μ ν videoID λκ²¨μ€μΌ ν¨.
			}, error : function(err){
				alert("video μ­μ κ° μ μμ μΌλ‘ μλ£λμ§ μμμ΅λλ€. μ μν λ€μ μλν΄μ£ΌμΈμ:(");
			}
		});
	}
	else false;
}

function convertTotalLength(seconds){ //μλΆμ΄λ‘ μκ° λ³ν
	var seconds_hh = Math.floor(seconds / 3600);
	var seconds_mm = Math.floor(seconds % 3600 / 60);
	var seconds_ss = parseInt(seconds % 3600 % 60); //μμ«μ λ¨μ μλ³΄μ¬μ£ΌκΈ°
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
	if(description == 'μ€λͺ μμ')	 description = null;
	
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
			alert('playlist μμ± μ€ν¨νμ΅λλ€. μ μν λ€μ μλν΄μ£ΌμΈμ:(');
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
			alert('playlist μμ μ μ€ν¨νμ΅λλ€. μ μν λ€μ μλν΄μ£ΌμΈμ:(');
		}
	});
}

function submitDeletePlaylist(){
	if(confirm("Playlistλ₯Ό μ­μ νμκ² μ΅λκΉ? νλ μ΄λ¦¬μ€νΈμ λΉλμ€λ λͺ¨λ μ­μ λ©λλ€.")){
		var playlistID = $('#setPlaylistID').val();
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/playlist/deletePlaylist',
			data: {playlistID : playlistID},
			datatype: 'json',
			success: function(data){
				alert('Playlist μ­μ κ° μλ£λμμ΅λλ€.');
				location.reload();
				},
			error: function(error){
				alert('Playlist μ­μ μ μ€ν¨νμ΅λλ€. μ μν λ€μ μλν΄μ£ΌμΈμ:(');
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
			alert('playlist κ²μμ μ€ν¨νμ΅λλ€. μ μν λ€μ μλν΄μ£ΌμΈμ:(');
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
	                                                	<input placeholder="κ²μμ΄λ₯Ό μλ ₯νμΈμ" type="hidden" id="searchType" name="searchType" class="mb-2 form-control" value="0">
	                                                		
	                                                	<input id="keyword" name="keyword" placeholder="κ²μμ΄λ₯Ό μλ ₯νμΈμ" type="text" class="form-control">
	                                                			                                                	
	                                                	<div class="input-group-append p-0">
															<button class="btn btn-secondary" type="submit">κ²μ</button>
														</div>    
														</div>                        

												</form>	

										<button class="btn btn-primary col-12 mb-2" data-toggle="modal" data-target="#addPlaylistModal">+ Playlist μμ±</button>
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
									 				onclick="location.href='${pageContext.request.contextPath}/video/youtube'" style="display: none">Youtube μμμΆκ°</button>
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
                    	</div>	<!-- λμλ³΄λ μ box λ !! -->
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
	                <h5 class="modal-title" id="addPlaylistModalLabel">Playlist μμ±</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">Γ</span>
	                </button>
	            </div>
	            <div class="modal-body">
            		<form class="needs-validation" id="formAddPlaylist" method="post" novalidate>
		               	<div class="position-relative form-group">
		               		<label for="inputPlaylistName" class="">Playlist μ΄λ¦</label>
		               		<input name="playlistName" id="inputPlaylistName" type="text" class="form-control" required>
		               		<div class="invalid-feedback">Playlist μ΄λ¦μ μλ ₯ν΄μ£ΌμΈμ</div>	
		               	</div>
		               	<div class="position-relative form-group">
		               		<label for="inputPlaylistDescription" class="">μ€λͺ</label>
		               		<textarea name="description" id="inputPlaylistDescription" class="form-control"></textarea>
		               	</div>
	                   	<div class="position-relative form-group">
		               		<label for="inputPlaylistTag" class="">νκ·Έ</label>
		               		<input name="tag" id="inputPlaylistTag" placeholder="" type="text" class="form-control">
		               	</div>
					</form>
				</div>
				<div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">μ·¨μ</button>
	                <button type="submit" form="formAddPlaylist" class="btn btn-primary" onclick="submitAddPlaylist();">μμ±</button>
            	</div>
	        </div>
	    </div>
	</div>
	
	<!-- edit playlist modal -->
    <div class="modal fade" id="editPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="editPlaylistModal" aria-hidden="true" style="display: none;">
	    <div class="modal-dialog" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="editPlaylistModalLabel">Playlist μμ </h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	                    <span aria-hidden="true">Γ</span>
	                </button>
	            </div>
	            <div class="modal-body">
	            	<form class="needs-validation" id="formEditPlaylist" method="post" novalidate>
	            		<input name="id" type="hidden" id="setPlaylistID">
		               <div class="position-relative form-group">
		               		<label for="editPlaylistName" class="">Playlist μ΄λ¦</label>
		               		<input name="playlistName" id="editPlaylistName" type="text" class="form-control" required>
		               		<div class="invalid-feedback">Playlist μ΄λ¦μ μλ ₯ν΄μ£ΌμΈμ</div>
		               </div>
		               <div class="position-relative form-group">
		               		<label for="editPlaylistDescription" class="">μ€λͺ</label>
		               		<textarea name="description" id="editPlaylistDescription" class="form-control"></textarea>
		               </div>
	                   <div class="position-relative form-group">
		               		<label for="editTag" class="">νκ·Έ</label>
		               		<input name="tag" id="editTag" type="text" class="form-control">
		               </div>
			       </form>
	            </div>
	            <div class="modal-footer">
	            	<button type="button" class="btn btn-danger" onclick="submitDeletePlaylist();">Playlist μ­μ </button>
	                <button type="button" class="btn btn-secondary" data-dismiss="modal">μ·¨μ</button>
	                <button type="submit" form="formEditPlaylist" class="btn btn-primary" onclick="submitEditPlaylist();">μμ μλ£</button>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Content-Language" content="en">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Notice</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/img/Learntube.ico">
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, shrink-to-fit=no" />
    <meta name="msapplication-tap-highlight" content="no">
	
    <link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/main.js"></script>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> 
	<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
</head>
<style>
	.text-black{
		color: rgba(13,27,62,0.7);
	}
	
	.font-header {
		font-size: .88rem;
	}
	
	.card {
		user-select: text;
	}
</style>
<script>
	var classID = ${classID};
	var notices;
	var lastIdx=0;
	
	$(document).ready(function(){
		getAllPin();
	});

	function getAllPin(){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/notice/getAllPin',
			data: {classID: classID},
			datatype: 'json',
			success: function(data){
				$('.noticeList').empty();

				$.each(data, function( index, value){
					var collapseID = "collapse" + index;
					var regDate = value.regDate.split(" ")[0];
					var viewCheck = value.studentID;	//학생이 읽지 않은 공지는 색상 다르게
					var viewdClass = '';
					var updateView = '';
					
					if (viewCheck == 0 || viewCheck == null) {
						viewCheck = '<span class="badge badge-primary viewCheck">NEW</span>';
						updateView = 'onclick="updateView(' + index + ',' + value.id + ');" ';
					}
					else {
						viewCheck = '';
						viewdClass = 'viewClass';
					}

					var html = '<div class="w-100 col-md-12 col-lg-10 col-auto ">'
								+ '<div id="accordion" class="accordion-wrapper">'
									+ '<div class="card">'
										+ '<div id="headingOne" class="card-header p-2">'
											+ '<button type="button" ' + updateView + 'class="text-left m-0 p-0 btn btn-link btn-block collapsed font-header" '
															+ 'data-toggle="collapse" data-target="#' + collapseID + '" aria-expanded="false" aria-controls="collapseOne">'
												+ '<div class="row">'
													+ '<div class="title col-md-8 font-weight-bold ' + viewdClass + '" id="' + value.id + '"><i class="pe-7s-pin"></i> ' 
															+ value.title + viewCheck + '</div>'
													+ '<div class="col-md-4 col-xs-12 text-black">게시일 ' + regDate + '</div>'
												+ '</div>'
											+ '</button>'
										+ '</div>'
										+ '<div data-parent="#accordion" id="' + collapseID + '" aria-labelledby="headingOne" class="collapse" style="">'
											+ '<div class="card-body">' + value.content + '</div>'
										+ '</div>'
									+ '</div>'
								+ '</div>'
							+ '</div>';

					$('.noticeList').append(html);
					if(index == (data.length-1))
						$('.noticeList').append('<div class="divider col-md-10 col-xs-11 m-2"></div>');
				});
				lastIdx = data.length;
				getAllNotices(data.length);
			},
			error: function(error){
				alert('상단고정된 공지를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
			}
		});
	}

	function getAllNotices(last){
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/notice/getAllNotice',
			data: {classID: classID},
			datatype: 'json',
			success: function(data){
				notices = data.notices;

				if (notices.length == 0) 
					$('.noticeList').append('<p> 게시된 공지사항이 없습니다. </p>');

				else {
					$.each(notices, function(idx, value){
						var index = last + idx;
						var collapseID = "collapse" + index;
						var regDate = value.regDate.split(" ")[0];
						var viewCheck = value.studentID;	//학생이 읽지 않은 공지는 색상 다르게
						var updateView = '';
						var viewdClass = '';
						
						if (viewCheck == 0 || viewCheck == null) {
							updateView = 'onclick="updateView(' + index + ',' + value.id + ');" ';
							viewCheck = '<span class="badge badge-primary viewCheck">NEW</span>';
						}
						else {
							viewCheck = '';
							viewdClass = 'viewClass';
						}
						var html = '<div class="w-100 col-md-12 col-lg-10 col-auto nonPin">'
							+ '<div id="accordion" class="accordion-wrapper">'
								+ '<div class="card">'
									+ '<div id="headingOne" class="card-header p-2">'
										+ '<button type="button" ' + updateView + 'class="text-left m-0 p-0 btn btn-link btn-block collapsed font-header" '
														+ 'data-toggle="collapse" data-target="#' + collapseID + '" aria-expanded="false" aria-controls="collapseOne">'
											+ '<div class="row">'
												+ '<div class="title col-md-8 text-black font-weight-bold ' + viewdClass + '" id="' + value.id + '">' + value.title + viewCheck + '</div>'
												+ '<div class="col-md-3 col-xs-12 text-black" >게시일 ' + regDate + '</div>'
											+ '</div>'
										+ '</button>'
									+ '</div>'
									+ '<div data-parent="#accordion" id="' + collapseID + '" aria-labelledby="headingOne" class="collapse" style="">'
										+ '<div class="card-body">' + value.content + '</div>'
									+ '</div>'
								+ '</div>'
							+ '</div>'
						+ '</div>';

						$('.noticeList').append(html);
					});
				}
			},
			error: function(data, status,error){
				alert('공지 리스트를 가져오는데 실패했습니다. 잠시후 다시 시도해주세요:(');
			}
		});
	}

	function updateView(index, noticeID){
		if($('.title:eq(' + index + ')').hasClass('viewdClass') == true) 
			return false;
		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/notice/insertView',
			data: {noticeID: noticeID},
			datatype: 'json',
			success: function(data){
				console.log('update view 완료!');
					$('.title:eq(' + index + ')').addClass('viewdClass');

					var element = $('.title:eq(' + index + ')');
					$('.title:eq(' + index + ')').children('span').remove();
					
					var elements = $('.title');
					$.each(elements, function(idx, value){	//같은 공지사항이 있으면 같이 'new' 뱃지 제거
						if(value.getAttribute('id') == noticeID && value != $('.title:eq(' + index + ')')){
							$('.title:eq(' + index + ')').addClass('viewdClass');

							var element = $('.title:eq(' + index + ')');
							$('.title:eq(' + index + ')').children('span').remove();
							
							var elements = $('.title');
							$.each(elements, function(idx, value){	//같은 공지사항이 있으면 같이 'new' 뱃지 제거
								if(value.getAttribute('id') == noticeID && value != $('.title:eq(' + index + ')')){
									$('.title:eq(' + idx + ')').addClass('viewdClass');
									$('.title:eq(' + idx + ')').children('span').remove();
								}
							});
							return false;
						}
							
					});
				},
				error: function(data, status,error){
					
				}
			});
	}

function search(event) {
		
		event.preventDefault(); // avoid to execute the actual submit of the form.

		/* var data = $("#searchForm").serialize();
		data : myForm.serialize().replace(/%/g, '%25'), */

		$.ajax({
			type: 'post',
			url: '${pageContext.request.contextPath}/student/notice/searchNotice',
			data: $("#searchForm").serialize().replace(/%/g, '%25'),
			success: function(data){

				$('.nonPin').empty();
				
				if (data.length == 0) 
					$('.noticeList').append('<p> 게시된 공지사항이 없습니다. </p>');

				
				else {
					console.log("검색 성공!");
					$.each(data, function(idx, value){
						console.log("idx ==> " + idx);
						var index = lastIdx + idx;
						var collapseID = "collapse" + index;
						var regDate = value.regDate.split(" ")[0];
						var viewCheck = value.studentID;	//학생이 읽지 않은 공지는 색상 다르게
						var updateView = '';
						var viewdClass = '';
						
						if (viewCheck == 0 || viewCheck == null) {
							updateView = 'onclick="updateView(' + index + ',' + value.id + ');" ';
							viewCheck = '<span class="badge badge-primary viewCheck">NEW</span>';
						}
						else {
							viewCheck = '';
							viewdClass = 'viewClass';
						}
						var html = '<div class="w-100 col-md-12 col-lg-10 col-auto nonPin">'
							+ '<div id="accordion" class="accordion-wrapper">'
								+ '<div class="card">'
									+ '<div id="headingOne" class="card-header p-2">'
										+ '<button type="button" ' + updateView + 'class="text-left m-0 p-0 btn btn-link btn-block collapsed font-header" '
														+ 'data-toggle="collapse" data-target="#' + collapseID + '" aria-expanded="false" aria-controls="collapseOne">'
											+ '<div class="row">'
												+ '<div class="title col-md-8 text-black font-weight-bold ' + viewdClass + '" id="' + value.id + '">' + value.title + viewCheck + '</div>'
												+ '<div class="col-md-3 col-xs-12 text-black" >게시일 ' + regDate + '</div>'
											+ '</div>'
										+ '</button>'
									+ '</div>'
									+ '<div data-parent="#accordion" id="' + collapseID + '" aria-labelledby="headingOne" class="collapse" style="">'
										+ '<div class="card-body">' + value.content + '</div>'
									+ '</div>'
								+ '</div>'
							+ '</div>'
						+ '</div>';

						$('.noticeList').append(html);
					});
				}
			},
			error: function(data, status,error){
				alert('공지 검색에 실패했습니다. 잠시후 다시 시도해주세요:(');
			}	
		});
	}
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow">
		<jsp:include page="../outer_top_stu.jsp" flush="false"/>

		<div class="app-main">
			<!-- outer_left.jsp에 데이터 전송 -->
		 	<jsp:include page="../outer_left_stu.jsp" flush="false">
		 		<jsp:param name="className" value="${className}"/>	
		 		<jsp:param name="menu"  value="notice"/>
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper align-items-center ">
                        	<div class="page-title-heading mr-3">
                            	<h4><span class="text-primary">${className}</span> - 공지</h4>
                            </div>
                            <div class="page-title-actions">
	                           <div class="search-wrapper d-flex justify-content-end active">
				                    <div class="input-holder active">
				                        <form id="searchForm" onsubmit="return search(event);" method="post">
					                        <input type="text" id="keyword" name="keyword" class="search-input" placeholder="공지 검색">
					                        <input type="hidden" name="classID" value="${classID}"/>
					                        <button class="search-icon" type="submit"><span></span></button>
				                      	</form>
				                    </div>
				                   
								</div>
                            </div>
                        </div>
                    </div>            
                    <div class="row justify-content-center noticeList">
                   		
                   	</div>
                    		<!--  
                    		<c:forEach var="item" items="${allNotices}" varStatus="status">
                    			<div class="col-md-12 col-lg-10 col-md-12 col-auto ">
	                             <div id="accordion" class="accordion-wrapper ml-5 mr-5 mb-3">
	                                 <div class="card">
	                                     <div id="headingOne" class="card-header">
	                                     	<c:set var="num" value="${fn:length(allNotices) - status.index}" />
	                                         <button type="button" data-toggle="collapse" data-target="#collapse${status.index}" aria-expanded="false" aria-controls="collapseOne" class="text-left m-0 p-0 btn btn-link btn-block collapsed">
	                                             <h5 class="m-0 p-0"><b>#<c:out value="${num}" /> </b><c:out value="${item.title}" /></h5>
	                                         </button>
	                                     </div>
	                                     <div data-parent="#accordion" id="collapse${status.index}" aria-labelledby="headingOne" class="collapse" style="">
	                                         <div class="card-body"><c:out value="${item.content}" /></div>
	                                     </div>
	                                 </div>
	                             </div>
	                         </div>
                    		</c:forEach>
                    		-->
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>

</body>
</html>
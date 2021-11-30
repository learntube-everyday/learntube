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
	<link rel="icon" href="${pageContext.request.contextPath}/resources/img/Learntube.png">
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
	var playlistcheck;
	var playlist;
	var total_runningtime;
	
	$(document).ready(function(){
		var weekContents = JSON.parse('${weekContents}');
		var allMyClass = JSON.parse('${realAllMyClass}');
		
		var watchCount = 0 ;
		var lastDays;
		var daySeq = 1;	//각 차시별 seq
			for(var i=0; i<allMyClass.length; i++){
				
				$.ajax({
					url : "${pageContext.request.contextPath}/student/class/forWatchedCount",
					type : "post",
					async : false,
					data : {	
						playlistID : weekContents[i].playlistID,
						classContentID : weekContents[i].id
					},
					success : function(data) {
						watchCount = data;  
						console.log(data);
					},
					error : function() {
						alert("error");
					}
				})
				
				var day = allMyClass[i].days;
				if(day != lastDays){
					lastDays = day;
					daySeq = 1;
				}
				else daySeq += 1;
				
				var endDate = allMyClass[i].endDate; //timestamp -> actural time
				if(endDate == null || endDate == '')
					endDate = '';
				else {
					endDate = allMyClass[i].endDate.split(":");
					endDate = endDate[0] + ":" + endDate[1];	
					endDate = '<p class="endDate contentInfo"">마감일: ' + endDate + '</p>';
				}
				
				var videoLength = '';
				
				var symbol;
				var totalVideo;
	         	//var percentage ;
				if(allMyClass[i].playlistID == 0){ //playlist없이 description만 올림 
					symbol = '<i class="pe-7s-note2 fa-lg" > </i>'
					totalVideo = 1;
					videoLength = '';
				}
				else{ //playlist 올림 
					symbol = '<i class="pe-7s-film fa-lg" style=" color:dodgerblue"> </i>'
					totalVideo =  weekContents[i].totalVideo;
					for(var j=0; j<weekContents.length; j++){
							if(allMyClass[i].playlistID == weekContents[j].playlistID)
							videoLength = "[" + convertTotalLength(weekContents[j].totalVideoLength) + "]";
					}
				}
				
				var progressbar = '<div class="col-sm-3">'
		               	 + '<div class="widget-content">'
		            		+'<div class="widget-content-outer">'
		                 	+'<div class="widget-content-wrapper">'
		                     	+'<div class="widget-content-right">'
		                         	+'<div class="widget-numbers fsize-1 text-muted"> ' + watchCount + " / " + totalVideo +  '</div>'
		                    		+'</div>'
		                 	+'</div>'
		                     +'<div class="widget-progress-wrapper mt-1">'
		                        + '<div class="progress-bar-sm progress-bar-animated-alt progress">'
		                             +'<div class="progress-bar bg-primary" role="progressbar" aria-valuenow="71" aria-valuemin="0" aria-valuemax="100" style="width: '+ watchCount/totalVideo*100 +'%;"></div>'
		                         +'</div>'
		                    +'</div>'
		            +' </div>'
	       	  	+ '</div>';
	         
	         
				var goDetail = "moveToContentDetail(" + allMyClass[i].id + "," + i + "," + allMyClass[i].playlistID + ");";
				var content = $('.day:eq(' + day + ')');
				
				content.append(
						 "<div class='content list-group-item-action list-group-item' seq='" + daySeq + "'>"
								+ '<div class="row col d-flex justify-content-between align-items-center">'
									+ '<div class="row col-sm-2">'
										+ '<div class="index col-6 pt-1">' + daySeq + '. </div>'
										+ '<div class="videoIcon col-6" style="font-size:25px;">' + symbol + '</div>' //playlist인지 url인지에 따라 다르게
									+ '</div>'
									+ "<div class='col-sm-7 align-items-center'  onclick=" + goDetail + " style='cursor: pointer;'>"
										+ "<div class='card-title align-items-center' style='padding: 15px 0px 0px;'>"
											+ allMyClass[i].title + " " + videoLength  
										+ '</div>'
										
										+ '<div class="align-items-center" style=" padding: 5px 0px 0px;">'
											+ '<div class="contentInfoBorder"></div>'
											+ '<div class="contentInfoBorder"></div>'
											+ endDate
										+ '</div>'
									
									+ '</div>'
									+ progressbar
                                   + '</div>'   
							+ '</div>'
						+ '</div>');
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

	function moveToContentDetail(contentID, daySeq, playlistID){	//content detail page로 이동
		var html = '<input type="hidden" name="id"  value="' + contentID + '">'
					+ '<input type="hidden" name="daySeq" value="' + daySeq + '">'
					+ '<input type="hidden" name="playlistID" value="' + playlistID + '">';
	
		var goForm = $('<form>', {
				method: 'post',
				action: '${pageContext.request.contextPath}/student/class/contentDetail',
				html: html
			}).appendTo('body'); 
	
		goForm.submit();
	}
	
</script>
<body>
	<div class="app-container app-theme-white body-tabs-shadow fixed-sidebar fixed-header">
		<jsp:include page="../outer_top_stu.jsp" flush="false"/>

		<div class="app-main">
		 	<jsp:include page="../outer_left_stu.jsp" flush="false">
		 		<jsp:param name="className" value="${className}"/>	
		 		<jsp:param name="menu"  value="contentList"/>
		 	</jsp:include>
		 	
        	<div class="app-main__outer">
        		 <div class="app-main__inner">
        			<div class="app-page-title">
                    	<div class="page-title-wrapper">
                        	<div class="page-title-heading">
                            	<span class="text-primary">${classInfo.className}</span> - 강의컨텐츠
                            </div>
                        </div>
                    </div>    
                            
                    <div class="row">
                       <div class="col-md-12">	 
                          <nav class="" aria-label="Page navigation example"> 
                          	<div id="client-paginator">
								<ul class="pagination">
                               		<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">
										<li class="page-item"><a href="#target${j-1}" class="page-link"> ${j} 차시 </a></li>
									</c:forEach>
                              	</ul>
							</div>	 
                           </nav>
                       	</div>
                        
                       	<div class="contents col-sm-12" classID="${classInfo.id}">
							<c:forEach var="j" begin="1" end="${classInfo.days}" varStatus="status">                                
                                
                                <div class="main-card mb-3 card">
                                    <div class="card-body">
                                    	<div class="card-title" style="display: inline;" >
                                    		<a style="display: inline; white-space: nowrap;" name= "target${j}" >
											 <h5 style="display: inline; ">${j} 차시</h5>
											</a> 
                                    	</div>

	                                    <div class="list-group accordion-wrapper day" day="${status.index}">
	                                        	
	                                    </div>
                                   </div>
                                   
                                   
                               </div>
                                        
                                        
							</c:forEach>
						</div>
                    </div>	
        		</div>
        		<jsp:include page="../outer_bottom.jsp" flush="false"/>
	   		</div>
	   	</div>
   	</div>
</body>
</html>

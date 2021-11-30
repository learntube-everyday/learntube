<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>

<link href="./resources/css/main.css" rel="stylesheet">
<script type="text/javascript" src="./resources/js/main.js"></script>

<script src="http://code.jquery.com/jquery-3.1.1.js"></script>
<script src="http://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/3daf17ae22.js" crossorigin="anonymous"></script>

<script>
	
</script>

    <div class="app-container app-theme-white body-tabs-shadow closed-sidebar">
        <div class="app-header header-shadow">
            <div class="app-header__logo">
                <div class="logo-src"></div>
                <div class="header__pane ml-auto">
                    <div>
                        <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                            <span class="hamburger-box">
                                <span class="hamburger-inner"></span>
                            </span>
                        </button>
                    </div>
                </div>
            </div>
            <div class="app-header__mobile-menu">
                <div>
                    <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                        <span class="hamburger-box">
                            <span class="hamburger-inner"></span>
                        </span>
                    </button>
                </div>
            </div>
            <div class="app-header__menu">
                <span>
                    <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                        <span class="btn-icon-wrapper">
                            <i class="fa fa-ellipsis-v fa-w-6"></i>
                        </span>
                    </button>
                </span>
            </div>    <div class="app-header__content">
                <div class="app-header-left">
                    <div class="search-wrapper">
                        <div class="input-holder">
                            <input type="text" class="search-input" placeholder="Type to search">
                            <button class="search-icon"><span></span></button>
                        </div>
                        <button class="close"></button>
                    </div>
                    <ul class="header-menu nav">
                        <li class="nav-item">
                            <a href="#" class="nav-link text-primary">	<!-- 상단의 대시보드/학습컨텐츠보관함의 파랑색글씨 설정 class -->
                                <i class="nav-link-icon fa fa-home"> </i>
                                대시보드
                            </a>
                        </li>
                       
                        <li class="nav-item">
                        	<!-- myplaylist/1 은 뒤에 instructorID 변경하기!!! (예원) -->
                            <a href="${pageContext.request.contextPath}/playlist/myPlaylist/1" class="nav-link">
                                <i class="nav-link-icon fa fa-archive"></i>
                                학습컨텐츠 보관함
                            </a>
                        </li>
                    </ul>  
                </div>
                <div class="app-header-right">
                    <div class="header-btn-lg pr-0">
                        <div class="widget-content p-0">
                            <div class="widget-content-wrapper">
                                <div class="widget-content-left">
                                    <div class="btn-group">
                                        <a data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="p-0 btn">
                                            <i class="fa fa-angle-down ml-2 opacity-8"></i>
                                        </a>
                                        <div tabindex="-1" role="menu" aria-hidden="true" class="dropdown-menu dropdown-menu-right">
                                           <h6 tabindex="-1" class="dropdown-header">Header</h6>
                                            <button type="button" tabindex="0" class="dropdown-item">User Account</button>
                                            <button type="button" tabindex="0" class="dropdown-item">Settings</button>
                                            <div tabindex="-1" class="dropdown-divider"></div>
                                            <button type="button" tabindex="0" class="dropdown-item">Sign Out</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="widget-content-left  ml-3 header-user-info">
                                    <div class="widget-heading">
                                        홍길동
                                    </div>
                                    <div class="widget-subheading">
                                        교수
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>        
                </div>
            </div>
        </div>              
        <div class="app-main">
                <div class="app-sidebar sidebar-shadow">
                    <div class="app-header__logo">
                        <div class="logo-src"></div>
                        <div class="header__pane ml-auto">
                            <div>
                                <button type="button" class="hamburger close-sidebar-btn hamburger--elastic" data-class="closed-sidebar">
                                    <span class="hamburger-box">
                                        <span class="hamburger-inner"></span>
                                    </span>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="app-header__mobile-menu">
                        <div>
                            <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                                <span class="hamburger-box">
                                    <span class="hamburger-inner"></span>
                                </span>
                            </button>
                        </div>
                    </div>
                    <div class="app-header__menu">
                        <span>
                            <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                                <span class="btn-icon-wrapper">
                                    <i class="fa fa-ellipsis-v fa-w-6"></i>
                                </span>
                            </button>
                        </span>
                    </div>    
                    <div class="scrollbar-sidebar ps ps--active-y">
                        <div class="app-sidebar__inner">
                            <ul class="vertical-nav-menu metismenu sideClassList">
                                <li class="app-sidebar__heading">내 강의실</li>
                                
                                <c:forEach var="v" items="${allMyClass}">
									 <li>
	                                    <a href="#">
	                                        <i class="metismenu-icon pe-7s-notebook"></i>
	                                        ${v.className}
	                                        <i class="metismenu-state-icon pe-7s-angle-down caret-left"></i>
	                                    </a>
	                                    <ul class="mm-collapse">
	                                    	<li>
	                                            <a href="#">
	                                                <i class="metismenu-icon"></i>
	                                                공지
	                                            </a>
	                                        </li>
	                                        <li>
	                                            <a href="${pageContext.request.contextPath}/class/contentList/${v.id}">
	                                                <i class="metismenu-icon"></i>
	                                                학습컨텐츠
	                                            </a>
	                                        </li>
	                                        <li>
	                                            <a href="#">
	                                                <i class="metismenu-icon"></i>
	                                               	출결/학습 현황
	                                            </a>
	                                        </li>
	                                    </ul>
	                                </li>
								</c:forEach>
                            </ul>
                        </div>
                    <div class="ps__rail-y" style="top: 0px; height: 761px; right: 0px;"><div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 549px;"></div></div></div>
                </div>
                 <div class="app-main__outer">
                    <div class="app-main__inner">
                        <div class="app-page-title">
                            <div class="page-title-wrapper">
                                <div class="page-title-heading">
                                  	대시보드
                                </div>
                          </div>
                        </div>            
                       
                        <div class="row">
                            
                        </div>	<!-- inner box 끝 !! -->
        
                    </div>
                    <div class="app-wrapper-footer">
                        <div class="app-footer">
                            <div class="app-footer__inner">
                                <div class="app-footer-left">
                                    <ul class="nav">
                                        <li class="nav-item">
                                            <a href="javascript:void(0);" class="nav-link">
                                                Footer Link 1
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="app-footer-right">
                                    <ul class="nav">
                                        <li class="nav-item">
                                            <a href="javascript:void(0);" class="nav-link">
                                                Footer Link 3
                                            </a>
                                        </li>  
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>    
              </div>
        </div>
    </div>


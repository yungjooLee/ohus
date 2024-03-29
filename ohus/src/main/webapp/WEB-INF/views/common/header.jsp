
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 스타일 추가 -->
<style>
  /* 네비게이션 스타일 추가 */
  
  a:hover {
    color: #35c5f0;
  }

  .header-upper__nav ul li a:hover {
    color: #35c5f0;
  }

  .header-upper__nav ul {
    display: flex;
  }

  .header-upper__nav ul li a {
    text-decoration-line: none;
    color: black;
  }

  /* 추가한 것 헤더 */
  .header-upper_test li {
    float: left;
  }

  /* 통합검색 클릭시 효과 */
  .header-upper__searchBar {
    display: flex;
    align-items: center;
    width: 300px;
    height: 40px;
    border: 1px solid #ccc;
    border-radius: 4px;
    overflow: hidden;
    margin-left: 30px;
    margin-right: 10px; /* 원하는 간격으로 조정 */
  }

  .header-upper__searchBar input[type="search"] {
    flex: 1;
    padding: 6px;
    border: none;
    outline: none;
  }

  .header-upper__searchBar:hover {
    outline: none !important;
    border-color: #fafafa;
    box-shadow: 0 0 10px #35c5f0;
  }

  /* 검색창과 로그인/회원 버튼 정렬하기 */
  .header-right {
    display: flex;
    align-items: center;
  }

  .header-upper__searchBar {
    margin-right: 10px;
  }

  .header-upper_test {
    display: flex; 
    align-items: center;
    
  }
  
   /* 회원가입과 로그인 사이에 | 추가 및 간격 조정 */
  .header-upper_test li.register_bar::after{
    content: "|";
    margin: 0 10px;
  }
  .header-upper_test ul li a{
 
 	margin-left : 10px;
 
 
  }
   .header-upper_test ul li a:hover {
    color: #35c5f0;
  }
  /*회원가입 로그인 로그아웃 부분*/

  .header-upper__service ul {
    display: flex;
    align-items: center;
  }

  .header-upper__service ul li {
    margin-right: 10px;
  }

  .header-upper__service ul li:first-child {
    margin-left: 0;
  }

  .header-upper__service ul li.register_bar::after {
    content: "|";
    margin: 0 5px;
  }

  .header-upper__service ul li.menu-logout {
    margin-left: 20px;
  } 
  
  .dropbtn{
  margin-left: 30px;
  }

  
</style>



	<!-- header 시작 -->

	<!-- 전체 레이아웃-->
	<div class="wrap">
		<!-- 상단 네비게이션 영역-->
		<header class="header">
			<!-- 네비게이션 상단 -->
			<div class="header-upper">
				<div class="inner">
					<i class="fas fa-bars searchMenu"></i>
					<div class="header-upper__inner">
						<!-- 로고 -->
						<div class="header-upper__logo">
							<a href="${pageContext.request.contextPath}/main/main.do">내일의집</a>
						</div>
						<!-- 상단 메뉴 시작-->
						<div class="header-upper__nav">
							<ul>
								
								<li class="header-upper__item upper__active">
									<h3><a href="${pageContext.request.contextPath}/community/list.do">
										커뮤니티
									</a></h3>
								</li>	 
									<li class="header-upper__item"><h3><a
										href="${pageContext.request.contextPath}/item/userList.do">쇼핑</a></h3></li>
									<li class="header-upper__item"><h3><a
										href="${pageContext.request.contextPath}/market/list.do">상추마켓</a></h3>
									</li>
									<li class="header-upper__item"><h3><a
										href="${pageContext.request.contextPath}/event/list.do">오이벤트</a></h3></li>
							</ul>
						</div>
						
					<!-- 서비스헤더 (오른쪽헤더) 시작-->
					<div class="header-right">
							<!-- 검색창 -->
							<div class="header-upper__searchBar">
								<input type="search" />
							</div>
							
							<div class="header-upper__service">
							<!-- ul태그 시작 -->
								<ul class="header-upper_test">
									<!-- 비회원 -->
									<c:if test="${empty user_num}">
										<li class="register_bar"><a href="${pageContext.request.contextPath}/member/registerUserForm.do">회원가입</a>
										</li>
										<li class="login_bar"><a href="${pageContext.request.contextPath}/member/loginForm.do">로그인</a>
										</li>
									</c:if>
		
									<!-- 로그인 o, 사진 o -->
									<c:if test="${!empty user_num && !empty user_photo}">
										<li class="menu-profile">
											<a href="${pageContext.request.contextPath}/member/myPage.do">
													<img src="${pageContext.request.contextPath}/upload/${user_photo}" width="46" height="39" class="my-photo"> <!-- 이미지 누르면 마이페이지로 이동하게 처리 -->
											</a>
										</li>
									</c:if>
		 
									<!-- 로그인 o, 사진 x -->
									<c:if test="${!empty user_num && empty user_photo}">
										<li class="menu-profile">
											<c:if test="${user_auth == 2}">
												<a href="${pageContext.request.contextPath}/member/myPage.do">
													<img src="${pageContext.request.contextPath}/images/face.png" width="46" height="39" class="my-photo">
												</a>
											</c:if>
											
											<c:if test="${user_auth == 9}">
												<a href="${pageContext.request.contextPath}/member/adminPage.do">
													<img src="${pageContext.request.contextPath}/images/face.png" width="46" height="39" class="my-photo">
												</a>
											</c:if>
										</li> 
									</c:if>
		
									<!-- 관리자 헤더 -->
									<c:if test="${!empty user_num && user_auth == 9}">
										<li class="menu-logout">[<span>관리자모드</span>]</li>
									</c:if>
									
									
									<!-- 회원 - 장바구니 -->
									<c:if test="${!empty user_num && user_auth == 2}">
										<li>
											<a href="${pageContext.request.contextPath}/cart/list.do"> 
												<img src="${pageContext.request.contextPath}/images/basket.png" width="40" height="40" class="basket" style="margin-left: 20px;">
											</a>
										</li>
									</c:if>
		
									<!-- 로그아웃 -->
									<c:if test="${!empty user_num}">
										<li class="menu-logout"><a href="${pageContext.request.contextPath}/member/logout.do">로그아웃</a>
										</li>
									</c:if>
		
									<!-- 회원 - 글쓰기 -->
									<c:if test="${!empty user_num && user_auth == 2}">
										<li>
											<div class="dropdown">
												<button onclick="myFunction()" class="dropbtn">글쓰기</button>
												<div id="myDropdown" class="dropdown-content">
													<a href="${pageContext.request.contextPath}/community/writeForm.do">커뮤니티글쓰기</a> 
													<a href="${pageContext.request.contextPath}/member/myPage1.do">리뷰등록</a> 
													<a href="${pageContext.request.contextPath}/market/writeForm.do">상추글쓰기</a>
													<a href="${pageContext.request.contextPath}/inquiry/writeInquiryForm.do">문의등록</a>
												</div>
											</div>
										</li>
									</c:if>
		
									<!-- 관리자 - 글쓰기 -->
									<c:if test="${!empty user_num && user_auth == 9}">
										<li>
											<div class="dropdown">
												<button onclick="myFunction()" class="dropbtn">글쓰기</button>
												<div id="myDropdown" class="dropdown-content">
													<a href="${pageContext.request.contextPath}/inquiry/writeInquiryForm.do">공지등록</a> 
													<a href="${pageContext.request.contextPath}/event/writeForm.do">이벤트등록</a>
													<a href="${pageContext.request.contextPath}/item/writeForm.do">상품등록</a>
													<a href="${pageContext.request.contextPath}/order/list.do">주문목록</a>
												</div>
											</div>
										</li>
									</c:if>
								</ul>
							</div>
						</div>
						<!-- 서비스헤더 (오른쪽헤더) 끝-->
					</div>	
				</div>	
			</div>	
		</header>		
		<!-- 상단 메뉴 끝 -->
	</div>		

<script type="text/javascript">
/* 
 글쓰기 버튼 클릭했을 때 드롭다운 처리 
 */
function myFunction() {
    document.getElementById("myDropdown").classList.toggle("show");
}

//드롭다운이 보이는 상태에서 다른 화면을 클릭했을 때 사라지도록 처리
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {

    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}
</script>	


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="site-footer">
  <div class="footer-inner">
    <div class="footer-top">
      <div>
        <div class="footer-logo">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round">
            <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
            <path d="M9 21V12h6v9"/>
          </svg>
          <div>
            <div class="ko">대덕아파트</div>
            <div class="en">DAEDEOK APARTMENT</div>
          </div>
        </div>
        <div style="margin-top:14px; font-size:12px; color:rgba(255,255,255,.35); line-height:1.9;">
          대전시 대덕구 대덕대로 123 대덕아파트 관리사무소<br>
          사업자번호: 000-00-00000 | 등록번호: 제0000호
        </div>
      </div>
      <nav class="footer-nav" style="align-self:flex-start; margin-top:8px;">
        <a href="${pageContext.request.contextPath}/manage/intro">관리사무소</a>
        <a href="${pageContext.request.contextPath}/fee/inquiry">아파트관리비</a>
        <a href="${pageContext.request.contextPath}/service/moving">생활지원서비스</a>
        <a href="${pageContext.request.contextPath}/complaint/apply">민원접수</a>
        <a href="${pageContext.request.contextPath}/vote/resident">전자투표및설문</a>
        <a href="${pageContext.request.contextPath}/board/notice">입주민게시판</a>
      </nav>
      <div class="footer-contact">
        <div class="label">Contact Us</div>
        <div class="phone">042-000-0000</div>
        <div class="detail">
          Fax. 042-000-0001<br>
          E-mail. info@daedeokapt.co.kr
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <div class="footer-info">
        고객센터: 042-000-0000 | 팩스: 042-000-0001 | 이메일: info@daedeokapt.co.kr
      </div>
      <div class="footer-copy">© 2024 대덕아파트. All rights reserved.</div>
    </div>
  </div>
</footer>
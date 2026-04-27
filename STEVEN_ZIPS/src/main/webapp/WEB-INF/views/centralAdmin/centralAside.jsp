<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String _uri = request.getRequestURI();
  String _ctx = request.getContextPath();
  if (_uri != null && _ctx != null && !_ctx.isEmpty() && _uri.startsWith(_ctx)) _uri = _uri.substring(_ctx.length());
  boolean isDashboard = _uri != null && (_uri.equals("/") || _uri.startsWith("/conManagement/main"));
  boolean isBuildSearch = _uri != null && _uri.startsWith("/conManagement/buildSearch");
  boolean isBuildRegister = _uri != null && _uri.startsWith("/conManagement/buildRegister");
  boolean isResidentList = _uri != null && (_uri.startsWith("/conManagement/residentList") || _uri.startsWith("/conManagement/residentStatus") || _uri.startsWith("/conManagement/resident"));
  boolean isContract = _uri != null && (_uri.startsWith("/conManagement/contractList") || _uri.startsWith("/conManagement/conManagement") || _uri.startsWith("/conManagement/contract"));
  boolean isStatistics = _uri != null && _uri.startsWith("/conManagement/statistics");
  boolean isCivilCom = _uri != null && _uri.startsWith("/conManagement/civilCom");
  boolean isAi = _uri != null && _uri.startsWith("/conManagement/ai");
  boolean isAnnouncement = _uri != null && _uri.startsWith("/conManagement/announcement");
  boolean isNotice = _uri != null && _uri.startsWith("/conManagement/notice");
  boolean isFacility = _uri != null && _uri.startsWith("/conManagement/facility");
  boolean isProHistory = _uri != null && _uri.startsWith("/conManagement/proHistory");
  boolean isSubAdmin = _uri != null && _uri.startsWith("/conManagement/subAdmin");
%>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-logo">
        <div class="logo-mark">
            <div class="logo-icon" id="logoIcon"><span class="material-symbols-rounded">home_work</span></div>
            <div class="logo-text">
                <h1>우리집맵핑</h1>
                <p>중앙관리 시스템</p>
            </div>
        </div>
        <button class="collapse-btn" onclick="toggleSidebar()" data-tooltip="사이드바 접기">
            <span class="material-symbols-rounded">left_panel_close</span>
        </button>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-group">
            <a href="<%= request.getContextPath() %>/" class="nav-item <%= isDashboard ? "active" : "" %>" data-page="대시보드" data-parent="대시보드">
                <span class="material-symbols-rounded nav-icon">grid_view</span>
                <span class="nav-text">대시보드</span>
            </a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
            <span class="section-label">건물 · 입주민</span>
            <a href="<%= request.getContextPath() %>/conManagement/buildSearch" class="nav-item <%= isBuildSearch ? "active" : "" %>" data-page="매물 통합 검색" data-parent="건물·입주민">
                <span class="material-symbols-rounded nav-icon">manage_search</span>
                <span class="nav-text">매물 통합 검색</span>
            </a>
            <a href="<%= request.getContextPath() %>/conManagement/buildRegister" class="nav-item <%= isBuildRegister ? "active" : "" %>" data-page="건물 등록 및 열람" data-parent="건물·입주민">
                <span class="material-symbols-rounded nav-icon">apartment</span>
                <span class="nav-text">건물 등록 및 열람</span>
            </a>
            <a href="<%= request.getContextPath() %>/conManagement/residentList" class="nav-item <%= isResidentList ? "active" : "" %>" data-page="입주민 관리" data-parent="건물·입주민">
                <span class="material-symbols-rounded nav-icon">groups</span>
                <span class="nav-text">입주민 관리</span>
            </a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
            <span class="section-label">계약 · 재무</span>
            <a href="<%= request.getContextPath() %>/conManagement/contractList.do" class="nav-item <%= isContract ? "active" : "" %>" data-page="계약 관리" data-parent="계약·재무">
                <span class="material-symbols-rounded nav-icon">contract</span>
                <span class="nav-text">계약 관리</span>
            </a>
            <a href="<%= request.getContextPath() %>/conManagement/statistics" class="nav-item <%= isStatistics ? "active" : "" %>" data-page="통계" data-parent="계약·재무">
                <span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span>
                <span class="nav-text">통계</span>
            </a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
            <span class="section-label">민원 · 소통</span>
            <a href="<%= request.getContextPath() %>/conManagement/civilCom" class="nav-item <%= isCivilCom ? "active" : "" %>" data-page="민원 관리" data-parent="민원·소통">
                <span class="material-symbols-rounded nav-icon">support_agent</span>
                <span class="nav-text">민원 관리</span>
                <span class="nav-badge">3</span>
            </a>
            <a href="<%= request.getContextPath() %>/conManagement/ai" class="nav-item <%= isAi ? "active" : "" %>" data-page="문의 관리" data-parent="민원·소통">
                <span class="material-symbols-rounded nav-icon">forum</span>
                <span class="nav-text">문의 관리</span>
                <span class="nav-badge yellow">4</span>
            </a>
            <a href="<%= request.getContextPath() %>/conManagement/announcement" class="nav-item <%= isAnnouncement ? "active" : "" %>" data-page="공고 관리" data-parent="민원·소통">
                <span class="material-symbols-rounded nav-icon">campaign</span>
                <span class="nav-text">공고 관리</span>
            </a>
            <a href="<%= request.getContextPath() %>/conManagement/notice" class="nav-item <%= isNotice ? "active" : "" %>" data-page="통합 게시판 관리" data-parent="민원·소통">
                <span class="material-symbols-rounded nav-icon">article</span>
                <span class="nav-text">통합 게시판 관리</span>
            </a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
            <span class="section-label">시설 · 시스템</span>
            <a href="<%= request.getContextPath() %>/conManagement/facility" class="nav-item <%= isFacility ? "active" : "" %>" data-page="시설 관리" data-parent="시설·시스템">
                <span class="material-symbols-rounded nav-icon">handyman</span>
                <span class="nav-text">시설 관리</span>
            </a>
            <a href="<%= request.getContextPath() %>/conManagement/proHistory" class="nav-item <%= isProHistory ? "active" : "" %>" data-page="비정상 세대 관리" data-parent="시설·시스템">
                <span class="material-symbols-rounded nav-icon">warning</span>
                <span class="nav-text">비정상 세대 관리</span>
            </a>
            <a href="<%= request.getContextPath() %>/conManagement/subAdmin" class="nav-item <%= isSubAdmin ? "active" : "" %>" data-page="하위관리자 계정" data-parent="시설·시스템">
                <span class="material-symbols-rounded nav-icon">manage_accounts</span>
                <span class="nav-text">하위관리자 계정</span>
            </a>
        </div>
    </nav>
    <div class="admin-card">
        <div class="admin-avatar">
            <span class="material-symbols-rounded" style="color: #fff; font-size: 18px">person</span>
        </div>
        <div class="admin-info">
            <p>중앙관리자</p>
            <span>클로드 최고</span>
        </div>
        <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink: 0; margin-left: auto">
            <span class="material-symbols-rounded">logout</span>
        </button>
    </div>
</aside>
<script>
  // 서버 매칭(URI) 실패 시를 대비한 active 보정(클라이언트 기준)
  (function(){
    try{
      var path=location.pathname||"";
      var links=document.querySelectorAll(".sidebar-nav .nav-item[href]");
      if(!links.length) return;
      links.forEach(function(a){a.classList.remove("active");});
      var best=null,bestLen=-1;
      links.forEach(function(a){
        var p=(new URL(a.href, location.href)).pathname||"";
        if(p==="/" && path!=="/") return;
        if(path===p || (p!=="/" && path.indexOf(p)===0)){
          if(p.length>bestLen){best=a;bestLen=p.length;}
        }
      });
      if(best) best.classList.add("active");
    }catch(e){}
  })();
</script>

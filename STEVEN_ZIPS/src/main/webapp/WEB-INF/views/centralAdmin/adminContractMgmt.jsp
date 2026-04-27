<!doctype html>
<html lang="ko">
  <head>

    <%--  합친 후 삭제예정 --%>

    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 계약 관리</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <style>
      /* SHELL CSS — 수정 금지 */
      *,
      *::before,
      *::after {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
      }
      :root {
        --bg: #f5f6f8;
        --card: #fff;
        --border: #e8eaed;
        --gray-soft: #f3f4f6;
        --text-primary: #111827;
        --text-secondary: #4b5563;
        --text-tertiary: #9ca3af;
        --accent: #3b82f6;
        --red: #dc2626;
        --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.06), 0 1px 2px rgba(0, 0, 0, 0.04);
        --r-sm: 8px;
        --r-md: 12px;
        --sb-bg: #1a2332;
        --sb-hover: rgba(255, 255, 255, 0.07);
        --sb-divider: rgba(255, 255, 255, 0.08);
        --sb-text: rgba(255, 255, 255, 0.72);
        --sb-icon: rgba(255, 255, 255, 0.45);
        --sb-label: rgba(255, 255, 255, 0.35);
        --sb-active-bg: rgba(101, 196, 120, 0.15);
        --sb-active: #65c478;
      }
      body {
        font-family: "Noto Sans KR", sans-serif;
        background: var(--bg);
        color: var(--text-primary);
        min-height: 100vh;
        display: flex;
        font-size: 15px;
        line-height: 1.6;
        letter-spacing: -0.02em;
      }
      .sidebar {
        width: 240px;
        background: var(--sb-bg);
        display: flex;
        flex-direction: column;
        height: 100vh;
        position: sticky;
        top: 0;
        overflow: hidden;
        z-index: 100;
        transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1) 0.05s;
      }
      .sidebar.collapsed {
        width: 64px;
        transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1) 0s;
      }
      .sidebar-nav {
        overflow-y: auto;
        scrollbar-width: none;
        flex: 1;
        padding: 8px 10px 16px;
      }
      .sidebar-nav::-webkit-scrollbar {
        display: none;
      }
      .nav-text,
      .nav-badge,
      .logo-text,
      .admin-info,
      .section-label {
        overflow: hidden;
        white-space: nowrap;
        max-width: 180px;
        opacity: 1;
        transition:
          max-width 0.18s cubic-bezier(0.4, 0, 1, 1) 0s,
          opacity 0.13s ease 0s;
      }
      .sidebar.collapsed .nav-text,
      .sidebar.collapsed .nav-badge,
      .sidebar.collapsed .logo-text,
      .sidebar.collapsed .admin-info,
      .sidebar.collapsed .section-label {
        max-width: 0;
        opacity: 0;
        transition:
          max-width 0.25s cubic-bezier(0.4, 0, 0.2, 1) 0.18s,
          opacity 0.2s ease 0.2s;
      }
      .sidebar-logo {
        padding: 22px 18px 18px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1px solid var(--sb-divider);
        flex-shrink: 0;
      }
      .logo-mark {
        display: flex;
        align-items: center;
        gap: 10px;
      }
      .logo-icon {
        width: 34px;
        height: 34px;
        background: linear-gradient(135deg, #65c478, #3b9e52);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
      }
      .logo-icon .material-symbols-rounded {
        color: #fff;
        font-size: 18px;
      }
      .logo-text h1 {
        font-size: 15px;
        font-weight: 800;
        color: #fff;
        letter-spacing: -0.3px;
      }
      .logo-text p {
        font-size: 10px;
        color: var(--sb-label);
        margin-top: 1px;
      }
      .sidebar.collapsed .logo-icon {
        cursor: pointer;
      }
      .collapse-btn {
        width: 28px;
        height: 28px;
        background: var(--sb-hover);
        border: none;
        border-radius: 8px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--sb-icon);
        max-width: 28px;
        opacity: 1;
        transition:
          max-width 0.15s ease,
          opacity 0.12s ease;
      }
      .sidebar.collapsed .collapse-btn {
        max-width: 0;
        opacity: 0;
      }
      .nav-group {
        margin-bottom: 4px;
      }
      .section-label {
        font-size: 11px;
        font-weight: 800;
        color: var(--sb-label);
        text-transform: uppercase;
        letter-spacing: 0.04em;
        padding: 20px 10px 6px;
        display: block;
      }
      .section-divider {
        height: 1px;
        background: var(--sb-divider);
        margin: 6px 4px;
      }
      .nav-item {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px;
        border-radius: var(--r-sm);
        color: var(--sb-text);
        text-decoration: none;
        cursor: pointer;
        transition: 0.15s;
        background: transparent;
        width: 100%;
        margin-bottom: 1px;
      }
      .nav-item:hover {
        background: var(--sb-hover);
        color: #fff;
      }
      .nav-item.active {
        background: var(--sb-active-bg);
        color: var(--sb-active);
      }
      .nav-icon {
        color: var(--sb-icon);
        font-size: 20px;
        flex-shrink: 0;
        width: 20px;
        text-align: center;
      }
      .nav-item.active .nav-icon {
        color: var(--sb-active);
      }
      .nav-text {
        font-size: 14px;
        font-weight: 500;
        flex: 1;
      }
      .nav-badge {
        background: var(--red);
        color: #fff;
        font-size: 10px;
        font-weight: 700;
        padding: 2px 6px;
        border-radius: 99px;
      }
      .nav-badge.yellow {
        background: #d97706;
      }
      .admin-card {
        margin: 10px;
        padding: 14px;
        background: rgba(255, 255, 255, 0.06);
        border-radius: var(--r-md);
        display: flex;
        align-items: center;
        gap: 10px;
        border-top: 1px solid var(--sb-divider);
        overflow: hidden;
        max-height: 80px;
        opacity: 1;
        transition:
          max-height 0.25s cubic-bezier(0.4, 0, 0.2, 1) 0s,
          opacity 0.2s ease 0s,
          margin 0.25s cubic-bezier(0.4, 0, 0.2, 1) 0s,
          padding 0.25s cubic-bezier(0.4, 0, 0.2, 1) 0s;
      }
      .sidebar.collapsed .admin-card {
        max-height: 0;
        opacity: 0;
        margin: 0 10px;
        padding: 0 14px;
        transition:
          max-height 0.2s cubic-bezier(0.4, 0, 1, 1) 0.05s,
          opacity 0.15s ease 0s,
          margin 0.2s ease 0.05s,
          padding 0.2s ease 0.05s;
      }
      .admin-avatar {
        width: 34px;
        height: 34px;
        background: linear-gradient(135deg, #65c478, #3b9e52);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
      }
      .admin-info {
        flex: 1;
        min-width: 0;
      }
      .admin-info p {
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        white-space: nowrap;
      }
      .admin-info span {
        font-size: 10px;
        color: var(--sb-label);
        white-space: nowrap;
      }
      .main-wrap {
        flex: 1;
        display: flex;
        flex-direction: column;
        min-width: 0;
      }
      .topbar {
        background: var(--card);
        border-bottom: 1px solid var(--border);
        padding: 0 28px;
        height: 60px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: sticky;
        top: 0;
        z-index: 50;
      }
      .breadcrumb {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 12px;
        color: var(--text-tertiary);
      }
      .bc-current {
        color: var(--text-primary);
        font-weight: 700;
      }
      .topbar-actions {
        display: flex;
        align-items: center;
        gap: 10px;
      }
      .topbar-icon-btn {
        width: 36px;
        height: 36px;
        border-radius: var(--r-sm);
        border: 1px solid var(--border);
        background: var(--card);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--text-secondary);
        position: relative;
        transition: 0.15s;
      }
      .topbar-icon-btn:hover {
        background: var(--gray-soft);
        color: var(--text-primary);
      }
      .topbar-icon-btn .dot {
        position: absolute;
        top: 6px;
        right: 6px;
        width: 7px;
        height: 7px;
        background: var(--red);
        border-radius: 50%;
        border: 1.5px solid white;
      }
      .main-content {
        flex: 1;
        padding: 28px;
        overflow-y: auto;
      }
      .icon-btn {
        width: 26px;
        height: 26px;
        background: none;
        border: none;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 6px;
        color: var(--sb-icon);
        transition: 0.15s;
      }
      .icon-btn:hover {
        background: var(--sb-hover);
        color: #fff;
      }
      [data-tooltip] {
        position: relative;
      }
      [data-tooltip]::after {
        content: attr(data-tooltip);
        position: absolute;
        left: 50%;
        bottom: calc(100% + 6px);
        transform: translateX(-50%);
        background: var(--text-primary);
        color: #fff;
        font-size: 11px;
        padding: 4px 8px;
        border-radius: 6px;
        white-space: nowrap;
        opacity: 0;
        pointer-events: none;
        transition: 0.15s;
        z-index: 99;
      }
      [data-tooltip]:hover::after {
        opacity: 1;
      }
      /* ↓ 페이지별 스타일 */
    </style>
    <style id="page-style">
      /* 탭 */
      .tab-bar {
        display: flex;
        gap: 4px;
        margin-bottom: 20px;
        border-bottom: 2px solid var(--border);
      }
      .tab-btn {
        padding: 10px 18px;
        font-size: 14px;
        font-weight: 600;
        color: var(--text-tertiary);
        background: none;
        border: none;
        cursor: pointer;
        border-bottom: 2px solid transparent;
        margin-bottom: -2px;
        transition: 0.15s;
      }
      .tab-btn.active {
        color: var(--accent);
        border-bottom-color: var(--accent);
      }

      /* 필터 카드 */
      .filter-card {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: var(--r-md);
        padding: 16px 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
        margin-bottom: 20px;
        box-shadow: var(--shadow-sm);
      }
      .filter-card select,
      .filter-card input {
        height: 36px;
        padding: 0 12px;
        border: 1px solid var(--border);
        border-radius: var(--r-sm);
        font-size: 13px;
        font-family: inherit;
        color: var(--text-primary);
        background: var(--card);
        outline: none;
      }
      .filter-card select:focus,
      .filter-card input:focus {
        border-color: var(--accent);
      }
      .btn {
        height: 36px;
        padding: 0 16px;
        border-radius: var(--r-sm);
        font-size: 13px;
        font-weight: 600;
        font-family: inherit;
        cursor: pointer;
        border: none;
        transition: 0.15s;
      }
      .btn-accent {
        background: var(--accent);
        color: #fff;
      }
      .btn-accent:hover {
        background: #2563eb;
      }
      .btn-ghost {
        background: none;
        border: 1px solid var(--border);
        color: var(--text-secondary);
      }
      .btn-ghost:hover {
        background: var(--gray-soft);
      }
      .btn-green {
        background: #16a34a;
        color: #fff;
      }
      .btn-green:hover {
        background: #15803d;
      }
      .btn-red {
        background: var(--red);
        color: #fff;
      }
      .btn-red:hover {
        background: #b91c1c;
      }
      .btn-blue-sm {
        height: 28px;
        padding: 0 12px;
        font-size: 12px;
        font-weight: 600;
        border-radius: 6px;
        background: rgba(59, 130, 246, 0.1);
        color: var(--accent);
        border: none;
        cursor: pointer;
        transition: 0.15s;
      }
      .btn-blue-sm:hover {
        background: rgba(59, 130, 246, 0.2);
      }

      /* 테이블 카드 */
      .table-card {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: var(--r-md);
        box-shadow: var(--shadow-sm);
        overflow: hidden;
      }
      .table-card-header {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        padding: 14px 20px;
        border-bottom: 1px solid var(--border);
      }
      table {
        width: 100%;
        border-collapse: collapse;
      }
      thead th {
        padding: 10px 16px;
        font-size: 12px;
        font-weight: 700;
        color: var(--text-tertiary);
        background: var(--gray-soft);
        text-align: left;
        white-space: nowrap;
      }
      tbody td {
        padding: 13px 16px;
        font-size: 13px;
        border-top: 1px solid var(--border);
        color: var(--text-primary);
      }
      tbody tr:hover td {
        background: #f9fafb;
      }

      /* 상태 뱃지 */
      .badge {
        display: inline-flex;
        align-items: center;
        padding: 3px 10px;
        border-radius: 99px;
        font-size: 12px;
        font-weight: 700;
      }
      .badge-pending {
        background: #fff7ed;
        color: #d97706;
      }
      .badge-approved {
        background: #f0fdf4;
        color: #16a34a;
      }
      .badge-rejected {
        background: #fef2f2;
        color: #dc2626;
      }

      /* 슬라이드오버 */
      .overlay {
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.35);
        z-index: 200;
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.25s;
      }
      .overlay.open {
        opacity: 1;
        pointer-events: auto;
      }
      .slideover {
        position: fixed;
        top: 0;
        right: 0;
        height: 100vh;
        width: 480px;
        background: var(--card);
        z-index: 201;
        display: flex;
        flex-direction: column;
        box-shadow: -4px 0 24px rgba(0, 0, 0, 0.12);
        transform: translateX(100%);
        transition: transform 0.28s cubic-bezier(0.4, 0, 0.2, 1);
      }
      .slideover.open {
        transform: translateX(0);
      }
      .so-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 18px 24px;
        border-bottom: 1px solid var(--border);
        flex-shrink: 0;
      }
      .so-header h3 {
        font-size: 16px;
        font-weight: 700;
      }
      .so-close {
        width: 32px;
        height: 32px;
        border: none;
        background: none;
        cursor: pointer;
        border-radius: 6px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--text-secondary);
        transition: 0.15s;
      }
      .so-close:hover {
        background: var(--gray-soft);
      }
      .so-body {
        flex: 1;
        overflow-y: auto;
        padding: 20px 24px;
        display: flex;
        flex-direction: column;
        gap: 20px;
      }
      .so-section h4 {
        font-size: 13px;
        font-weight: 700;
        color: var(--text-tertiary);
        text-transform: uppercase;
        letter-spacing: 0.04em;
        margin-bottom: 12px;
      }
      .info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px;
      }
      .info-item label {
        display: block;
        font-size: 11px;
        color: var(--text-tertiary);
        margin-bottom: 3px;
      }
      .info-item span {
        font-size: 13px;
        font-weight: 600;
      }
      .file-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px 14px;
        background: var(--gray-soft);
        border-radius: var(--r-sm);
      }
      .file-row + .file-row {
        margin-top: 6px;
      }
      .file-name {
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 8px;
        color: var(--text-primary);
      }
      .so-textarea {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid var(--border);
        border-radius: var(--r-sm);
        font-size: 13px;
        font-family: inherit;
        resize: vertical;
        outline: none;
        color: var(--text-primary);
      }
      .so-textarea:focus {
        border-color: var(--accent);
      }
      .so-textarea.error {
        border-color: var(--red);
      }
      .so-footer {
        padding: 16px 24px;
        border-top: 1px solid var(--border);
        display: flex;
        gap: 10px;
        flex-shrink: 0;
      }
      .so-footer .btn {
        flex: 1;
      }

      .tab-panel {
        display: none;
      }
      .tab-panel.active {
        display: block;
      }

      /* 등록 폼 */
      .form-card {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: var(--r-md);
        padding: 20px 24px;
        box-shadow: var(--shadow-sm);
      }
      .form-card-title {
        font-size: 14px;
        font-weight: 700;
        margin-bottom: 16px;
        padding-bottom: 12px;
        border-bottom: 1px solid var(--border);
      }
      .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 14px;
      }
      .form-field {
        display: flex;
        flex-direction: column;
        gap: 4px;
      }
      .form-label {
        font-size: 12px;
        font-weight: 600;
        color: var(--text-secondary);
      }
      .req {
        color: var(--red);
      }
      .form-input {
        height: 38px;
        padding: 0 12px;
        border: 1px solid var(--border);
        border-radius: var(--r-sm);
        font-size: 13px;
        font-family: inherit;
        color: var(--text-primary);
        background: var(--card);
        outline: none;
      }
      .form-input:focus {
        border-color: var(--accent);
      }
      .form-input.error {
        border-color: var(--red);
      }
      .form-err {
        font-size: 11px;
        color: var(--red);
        min-height: 14px;
      }
      .file-upload-row {
        display: flex;
        align-items: center;
        gap: 12px;
      }
      .file-label {
        display: inline-flex;
        align-items: center;
        height: 34px;
        padding: 0 14px;
        border: 1px solid var(--border);
        border-radius: var(--r-sm);
        font-size: 12px;
        font-weight: 600;
        color: var(--text-secondary);
        cursor: pointer;
        background: var(--gray-soft);
        white-space: nowrap;
        transition: 0.15s;
      }
      .file-label:hover {
        background: var(--border);
      }
      .file-label input[type="file"] {
        display: none;
      }
      .file-fname {
        font-size: 12px;
        color: var(--text-tertiary);
      }
    </style>
  </head>
  <body>
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
          <a class="nav-item" data-page="대시보드" data-parent="대시보드"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a class="nav-item" data-page="매물 통합 검색" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a class="nav-item" data-page="건물 등록 및 열람" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
          <a class="nav-item" data-page="입주민 관리" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">계약 · 재무</span>
          <a class="nav-item active" data-page="계약 관리" data-parent="계약·재무"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
          <a class="nav-item" data-page="통계" data-parent="계약·재무"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">민원 · 소통</span>
          <a class="nav-item" data-page="민원 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
          <a class="nav-item" data-page="문의 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
          <a class="nav-item" data-page="공고 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
          <a class="nav-item" data-page="통합 게시판 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">시설 · 시스템</span>
          <a class="nav-item" data-page="시설 관리" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
          <a class="nav-item" data-page="비정상 세대 관리" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
          <a class="nav-item" href="/admin/adminSubMgmt">
            <span class="material-symbols-rounded nav-icon">manage_accounts</span>
            <span class="nav-text">하위관리자 계정</span>
          </a>
        </div>
      </nav>
      <div class="admin-card">
        <div class="admin-avatar"><span class="material-symbols-rounded" style="color: #fff; font-size: 18px">person</span></div>
        <div class="admin-info">
          <p>중앙관리자</p>
          <span>클로드 최고</span>
        </div>
        <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink: 0; margin-left: auto">
          <span class="material-symbols-rounded">logout</span>
        </button>
      </div>
    </aside>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span id="bc-parent">계약·재무</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current" id="bc-current">계약 관리</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림">
            <span class="material-symbols-rounded">notifications</span>
            <div class="dot"></div>
          </button>
          <button class="topbar-icon-btn" data-tooltip="설정">
            <span class="material-symbols-rounded">settings</span>
          </button>
        </div>
      </div>

      <div class="main-content" id="page-content">
        <!-- 탭 바 -->
        <div class="tab-bar">
          <button class="tab-btn active" onclick="switchTab(0, this)">계약 목록</button>
          <button class="tab-btn" onclick="switchTab(1, this)">오프라인 계약 등록</button>
        </div>

        <!-- 탭1: 계약 목록 -->
        <div class="tab-panel active" id="tab-0">
          <!-- 필터 -->
          <div class="filter-card">
            <select id="f-type">
              <option value="">전체 계약</option>
              <option value="전세">전세계약</option>
              <option value="월세">월세계약</option>
            </select>
            <input type="text" id="f-user" placeholder="회원 ID 검색" style="width: 160px" />
            <select id="f-status">
              <option value="">전체 상태</option>
              <option value="승인대기">승인대기</option>
              <option value="승인">승인</option>
              <option value="반려">반려</option>
            </select>
            <button class="btn btn-accent" onclick="filterTable()">검색</button>
            <button class="btn btn-ghost" onclick="resetFilter()">초기화</button>
          </div>

          <!-- 테이블 -->
          <div class="table-card">
            <div class="table-card-header">
              <button class="btn btn-green" onclick="switchTab(1, document.querySelectorAll('.tab-btn')[1])"><span class="material-symbols-rounded" style="font-size: 16px; vertical-align: -3px; margin-right: 4px">add</span>오프라인 계약 등록</button>
            </div>
            <table id="contract-table">
              <thead>
                <tr>
                  <th>계약번호</th>
                  <th>계약 유형</th>
                  <th>회원 ID</th>
                  <th>아파트</th>
                  <th>계약일</th>
                  <th>상태</th>
                  <th>관리</th>
                </tr>
              </thead>
              <tbody id="table-body"></tbody>
            </table>
          </div>
        </div>

        <!-- 탭2: 오프라인 계약 등록 -->
        <div class="tab-panel" id="tab-1">
          <div style="max-width: 720px; display: flex; flex-direction: column; gap: 16px">
            <!-- 섹션1: 계약 기본 정보 -->
            <div class="form-card">
              <div class="form-card-title">계약 기본 정보</div>
              <div class="form-grid">
                <div class="form-field">
                  <label class="form-label">회원 ID <span class="req">*</span></label>
                  <input type="text" id="r-user" class="form-input" placeholder="회원 ID 입력" />
                  <span class="form-err" id="err-user"></span>
                </div>
                <div class="form-field">
                  <label class="form-label">아파트 <span class="req">*</span></label>
                  <select id="r-apt" class="form-input">
                    <option value="">아파트 선택</option>
                    <option>레미안 아파트</option>
                    <option>자이 아파트</option>
                    <option>푸르지오 아파트</option>
                  </select>
                  <span class="form-err" id="err-apt"></span>
                </div>
                <div class="form-field">
                  <label class="form-label">계약 유형 <span class="req">*</span></label>
                  <select id="r-type" class="form-input">
                    <option value="">선택</option>
                    <option value="전세">전세계약</option>
                    <option value="월세">월세계약</option>
                  </select>
                  <span class="form-err" id="err-type"></span>
                </div>
                <div class="form-field">
                  <label class="form-label">계약 상태</label>
                  <input type="text" class="form-input" value="승인대기" disabled style="background: var(--gray-soft); color: var(--text-tertiary); cursor: not-allowed" />
                </div>
              </div>
            </div>

            <!-- 섹션2: 계약 정보 -->
            <div class="form-card">
              <div class="form-card-title">계약 정보</div>
              <div class="form-grid">
                <div class="form-field">
                  <label class="form-label">계약 금액</label>
                  <input type="number" id="r-amount" class="form-input" placeholder="원 단위 입력" min="0" />
                </div>
                <div class="form-field">
                  <label class="form-label">보증금</label>
                  <input type="number" id="r-deposit" class="form-input" placeholder="원 단위 입력" min="0" />
                </div>
                <div class="form-field">
                  <label class="form-label">계약 시작일</label>
                  <input type="date" id="r-start" class="form-input" />
                </div>
                <div class="form-field">
                  <label class="form-label">계약 종료일</label>
                  <input type="date" id="r-end" class="form-input" />
                  <span class="form-err" id="err-date"></span>
                </div>
              </div>
            </div>

            <!-- 섹션3: 서류 업로드 -->
            <div class="form-card">
              <div class="form-card-title">계약 서류 업로드</div>
              <div style="display: flex; flex-direction: column; gap: 10px">
                <div class="file-upload-row">
                  <label class="form-label" style="width: 90px; flex-shrink: 0">계약서</label>
                  <label class="file-label">
                    <input type="file" id="r-file1" accept=".pdf,.doc,.docx" onchange="showFileName(this, 'fname1')" />
                    파일 선택
                  </label>
                  <span class="file-fname" id="fname1">선택된 파일 없음</span>
                </div>
                <div class="file-upload-row">
                  <label class="form-label" style="width: 90px; flex-shrink: 0">신분증</label>
                  <label class="file-label">
                    <input type="file" id="r-file2" accept=".pdf,.doc,.docx" onchange="showFileName(this, 'fname2')" />
                    파일 선택
                  </label>
                  <span class="file-fname" id="fname2">선택된 파일 없음</span>
                </div>
                <div class="file-upload-row">
                  <label class="form-label" style="width: 90px; flex-shrink: 0">추가 서류</label>
                  <label class="file-label">
                    <input type="file" id="r-file3" accept=".pdf,.doc,.docx" onchange="showFileName(this, 'fname3')" />
                    파일 선택
                  </label>
                  <span class="file-fname" id="fname3">선택된 파일 없음</span>
                </div>
              </div>
            </div>

            <!-- 하단 버튼 -->
            <div style="display: flex; gap: 10px; justify-content: flex-end">
              <button class="btn btn-ghost" onclick="switchTab(0, document.querySelectorAll('.tab-btn')[0])">취소</button>
              <button class="btn btn-green" onclick="submitRegister()">계약 등록</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 슬라이드오버 오버레이 -->
    <div class="overlay" id="overlay" onclick="closePanel()"></div>
    <div class="slideover" id="slideover">
      <div class="so-header">
        <h3>계약 상세</h3>
        <button class="so-close" onclick="closePanel()"><span class="material-symbols-rounded">close</span></button>
      </div>
      <div class="so-body">
        <div class="so-section">
          <h4>계약 정보</h4>
          <div class="info-grid" id="so-info"></div>
        </div>
        <div class="so-section">
          <h4>첨부 서류</h4>
          <div id="so-files"></div>
        </div>
        <div class="so-section" id="so-reject-section">
          <h4>반려 사유</h4>
          <textarea class="so-textarea" id="so-reason" rows="3" placeholder="반려 시 사유 입력"></textarea>
        </div>
      </div>
      <div class="so-footer" id="so-footer"></div>
    </div>

    <script>
      /* SHELL JS — 수정 금지 */
      window.toggleSidebar = function () {
        document.getElementById("sidebar").classList.toggle("collapsed");
      };
      document.getElementById("logoIcon").addEventListener("click", function () {
        if (document.getElementById("sidebar").classList.contains("collapsed")) toggleSidebar();
      });
      document.querySelectorAll(".nav-item[data-page]").forEach(function (el) {
        el.addEventListener("click", function () {
          document.querySelectorAll(".nav-item").forEach((i) => i.classList.remove("active"));
          el.classList.add("active");
          document.getElementById("bc-current").textContent = el.dataset.page;
          document.getElementById("bc-parent").textContent = el.dataset.parent;
        });
      });
    </script>
    <script id="page-script">
      const CONTRACTS = [
        { id: "CTR-001", type: "전세", user: "user123", apt: "레미안 아파트", date: "2026-04-01", status: "승인대기", amount: "3억 5,000만원", deposit: "3억 5,000만원", start: "2026-05-01", end: "2028-04-30", files: ["계약서.pdf", "신분증.pdf", "등기부등본.pdf"] },
        { id: "CTR-002", type: "월세", user: "user567", apt: "자이 아파트", date: "2026-04-03", status: "승인", amount: "월 80만원", deposit: "5,000만원", start: "2026-05-01", end: "2027-04-30", files: ["계약서.pdf", "신분증.pdf", "등기부등본.pdf"] },
        { id: "CTR-003", type: "전세", user: "user888", apt: "푸르지오 아파트", date: "2026-04-02", status: "반려", amount: "2억 8,000만원", deposit: "2억 8,000만원", start: "2026-06-01", end: "2028-05-31", files: ["계약서.pdf", "신분증.pdf", "등기부등본.pdf"] },
      ];

      const STATUS_CLASS = { 승인대기: "badge-pending", 승인: "badge-approved", 반려: "badge-rejected" };

      let currentIdx = null;

      function renderTable(data) {
        const tbody = document.getElementById("table-body");
        tbody.innerHTML = data
          .map(
            (c, i) => `
          <tr>
            <td style="font-weight:600">${c.id}</td>
            <td>${c.type}계약</td>
            <td>${c.user}</td>
            <td>${c.apt}</td>
            <td>${c.date}</td>
            <td><span class="badge ${STATUS_CLASS[c.status]}">${c.status}</span></td>
            <td><button class="btn-blue-sm" onclick="openPanel(${CONTRACTS.indexOf(c)})">상세</button></td>
          </tr>`,
          )
          .join("");
      }

      function filterTable() {
        const type = document.getElementById("f-type").value;
        const user = document.getElementById("f-user").value.trim().toLowerCase();
        const status = document.getElementById("f-status").value;
        renderTable(CONTRACTS.filter((c) => (!type || c.type === type) && (!user || c.user.toLowerCase().includes(user)) && (!status || c.status === status)));
      }

      function resetFilter() {
        document.getElementById("f-type").value = "";
        document.getElementById("f-user").value = "";
        document.getElementById("f-status").value = "";
        renderTable(CONTRACTS);
      }

      function openPanel(idx) {
        currentIdx = idx;
        const c = CONTRACTS[idx];
        document.getElementById("so-reason").value = "";
        document.getElementById("so-reason").classList.remove("error");

        document.getElementById("so-info").innerHTML = [
          ["계약번호", c.id],
          ["계약 유형", c.type + "계약"],
          ["회원 ID", c.user],
          ["아파트", c.apt],
          ["계약 금액", c.amount],
          ["보증금", c.deposit],
          ["계약 기간", `${c.start} ~ ${c.end}`],
          ["현재 상태", `<span class="badge ${STATUS_CLASS[c.status]}">${c.status}</span>`],
        ]
          .map(([l, v]) => `<div class="info-item"><label>${l}</label><span>${v}</span></div>`)
          .join("");

        document.getElementById("so-files").innerHTML = c.files
          .map(
            (f) => `
          <div class="file-row">
            <span class="file-name"><span class="material-symbols-rounded" style="font-size:18px;color:var(--text-tertiary)">description</span>${f}</span>
            <button class="btn btn-ghost" style="height:30px;font-size:12px" onclick="alert('파일 보기: ${f}')">보기</button>
          </div>`,
          )
          .join("");

        document.getElementById("so-reject-section").style.display = c.status === "승인" ? "none" : "";

        const footer = document.getElementById("so-footer");
        footer.innerHTML =
          c.status === "승인대기"
            ? `
          <button class="btn btn-red" onclick="doReject()">반려</button>
          <button class="btn btn-green" onclick="doApprove()">승인</button>`
            : "";

        document.getElementById("overlay").classList.add("open");
        document.getElementById("slideover").classList.add("open");
      }

      function closePanel() {
        document.getElementById("overlay").classList.remove("open");
        document.getElementById("slideover").classList.remove("open");
      }

      function doApprove() {
        if (!confirm("승인하시겠습니까?")) return;
        CONTRACTS[currentIdx].status = "승인";
        renderTable(CONTRACTS);
        closePanel();
      }

      function doReject() {
        const reason = document.getElementById("so-reason").value.trim();
        if (!reason) {
          document.getElementById("so-reason").classList.add("error");
          document.getElementById("so-reason").focus();
          return;
        }
        CONTRACTS[currentIdx].status = "반려";
        renderTable(CONTRACTS);
        closePanel();
      }

      function showFileName(input, targetId) {
        const el = document.getElementById(targetId);
        el.textContent = input.files[0] ? input.files[0].name : "선택된 파일 없음";
        el.style.color = input.files[0] ? "var(--text-primary)" : "var(--text-tertiary)";
      }

      function submitRegister() {
        const user = document.getElementById("r-user").value.trim();
        const apt = document.getElementById("r-apt").value;
        const type = document.getElementById("r-type").value;
        const start = document.getElementById("r-start").value;
        const end = document.getElementById("r-end").value;
        let valid = true;

        const setErr = (id, errId, msg) => {
          const el = document.getElementById(id);
          const err = document.getElementById(errId);
          const empty = !el.value.trim();
          el.classList.toggle("error", empty);
          err.textContent = empty ? msg : "";
          if (empty) valid = false;
        };

        // 필수 검사
        [
          ["r-user", "err-user", "회원 ID를 입력해주세요"],
          ["r-apt", "err-apt", "아파트를 선택해주세요"],
          ["r-type", "err-type", "계약 유형을 선택해주세요"],
        ].forEach(([id, errId, msg]) => setErr(id, errId, msg));

        // 날짜 검사
        const errDate = document.getElementById("err-date");
        const endEl = document.getElementById("r-end");
        if (start && end && end < start) {
          endEl.classList.add("error");
          errDate.textContent = "종료일은 시작일 이후여야 합니다";
          valid = false;
        } else {
          endEl.classList.remove("error");
          errDate.textContent = "";
        }

        if (!valid) return;

        const newId = "CTR-00" + (CONTRACTS.length + 1);
        const today = new Date().toISOString().slice(0, 10);
        CONTRACTS.unshift({
          id: newId,
          type,
          user,
          apt,
          date: today,
          status: "승인대기",
          amount: document.getElementById("r-amount").value ? Number(document.getElementById("r-amount").value).toLocaleString() + "원" : "-",
          deposit: document.getElementById("r-deposit").value ? Number(document.getElementById("r-deposit").value).toLocaleString() + "원" : "-",
          start: start || "-",
          end: end || "-",
          files: ["계약서.pdf", "신분증.pdf", "추가서류.pdf"],
        });

        // 폼 초기화
        ["r-user", "r-apt", "r-type", "r-amount", "r-deposit", "r-start", "r-end"].forEach((id) => (document.getElementById(id).value = ""));
        ["r-file1", "r-file2", "r-file3"].forEach((id, i) => {
          document.getElementById(id).value = "";
          document.getElementById("fname" + (i + 1)).textContent = "선택된 파일 없음";
          document.getElementById("fname" + (i + 1)).style.color = "";
        });

        renderTable(CONTRACTS);
        alert("계약이 등록되었습니다.");
        switchTab(0, document.querySelectorAll(".tab-btn")[0]);
      }

      function switchTab(idx, btn) {
        document.querySelectorAll(".tab-btn").forEach((b) => b.classList.remove("active"));
        document.querySelectorAll(".tab-panel").forEach((p) => p.classList.remove("active"));
        btn.classList.add("active");
        document.getElementById("tab-" + idx).classList.add("active");
      }

      renderTable(CONTRACTS);
    </script>
  </body>
</html>

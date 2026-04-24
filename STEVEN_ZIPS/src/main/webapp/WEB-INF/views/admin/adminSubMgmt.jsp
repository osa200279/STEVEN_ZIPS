<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>우리집맵핑 · 중앙관리 시스템</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet"/>
  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --bg: #f0f2f5;
      --sidebar-bg: #141e2d;
      --sidebar-hover: rgba(255,255,255,0.06);
      --sidebar-active-bg: rgba(101,196,120,0.14);
      --sidebar-active-text: #65c478;
      --sidebar-label: rgba(255,255,255,0.28);
      --sidebar-icon: rgba(255,255,255,0.38);
      --sidebar-text: rgba(255,255,255,0.68);
      --sidebar-divider: rgba(255,255,255,0.07);
      --card: #ffffff;
      --border: #e5e8ec;
      --border-light: #f0f2f5;
      --text-primary: #0f1724;
      --text-secondary: #4b5563;
      --text-tertiary: #9ca3af;
      --accent: #3b82f6;
      --green: #10b981;
      --red: #ef4444;
      --shadow-xs: 0 1px 2px rgba(0,0,0,0.04);
      --shadow-sm: 0 1px 4px rgba(0,0,0,0.06), 0 2px 8px rgba(0,0,0,0.04);
      --shadow-md: 0 4px 24px rgba(0,0,0,0.1), 0 1px 4px rgba(0,0,0,0.06);
      --radius-sm: 8px;
      --radius-md: 12px;
      --radius-lg: 16px;
    }

    body {
      font-family: 'Noto Sans KR', sans-serif;
      background: var(--bg);
      color: var(--text-primary);
      min-height: 100vh;
      display: flex;
      font-size: 14px;
      line-height: 1.6;
      letter-spacing: -0.02em;
    }

    /* ━━━ SIDEBAR ━━━ */
    .sidebar {
      width: 248px; min-width: 0;
      background: var(--sidebar-bg);
      display: flex; flex-direction: column;
      height: 100vh; position: sticky; top: 0;
      overflow: hidden; z-index: 100;
      transition: width 0.32s cubic-bezier(0.4,0,0.2,1) 0.05s;
    }
    .sidebar.collapsed { width: 64px; transition: width 0.28s cubic-bezier(0.4,0,0.2,1) 0s; }
    .sidebar-nav { overflow-y: auto; scrollbar-width: none; flex: 1; padding: 10px 10px 12px; }
    .sidebar-nav::-webkit-scrollbar { display: none; }
    .nav-text, .nav-badge, .logo-text, .admin-info, .section-label {
      overflow: hidden; white-space: nowrap; max-width: 180px; opacity: 1;
      transition: max-width 0.18s cubic-bezier(0.4,0,1,1) 0s, opacity 0.13s ease 0s;
    }
    .sidebar.collapsed .nav-text, .sidebar.collapsed .nav-badge,
    .sidebar.collapsed .logo-text, .sidebar.collapsed .admin-info, .sidebar.collapsed .section-label {
      max-width: 0; opacity: 0;
      transition: max-width 0.25s cubic-bezier(0.4,0,0.2,1) 0.18s, opacity 0.18s ease 0.18s;
    }
    .sidebar-logo {
      padding: 22px 18px 16px;
      display: flex; align-items: center; justify-content: space-between;
      border-bottom: 1px solid var(--sidebar-divider); flex-shrink: 0;
    }
    .logo-mark { display: flex; align-items: center; gap: 10px; }
    .logo-icon {
      width: 34px; height: 34px; flex-shrink: 0;
      background: linear-gradient(140deg, #65c478 0%, #2f9e4a 100%);
      border-radius: 10px; display: flex; align-items: center; justify-content: center;
    }
    .logo-icon .material-symbols-rounded { color: #fff; font-size: 18px; }
    .logo-text h1 { font-size: 14px; font-weight: 800; color: #fff; letter-spacing: -0.3px; }
    .logo-text p { font-size: 10px; color: var(--sidebar-label); margin-top: 1px; }
    .sidebar.collapsed .logo-icon { cursor: pointer; }
    .collapse-btn {
      width: 28px; height: 28px; background: var(--sidebar-hover);
      border: none; border-radius: 8px; cursor: pointer;
      display: flex; align-items: center; justify-content: center; color: var(--sidebar-icon);
      max-width: 28px; opacity: 1; transition: max-width 0.15s ease, opacity 0.12s ease, background 0.15s;
    }
    .collapse-btn:hover { background: rgba(255,255,255,0.1); color: #fff; }
    .sidebar.collapsed .collapse-btn { max-width: 0; opacity: 0; }
    .nav-group { margin-bottom: 2px; }
    .section-label {
      font-size: 10px; font-weight: 800; color: var(--sidebar-label);
      text-transform: uppercase; letter-spacing: 0.06em;
      padding: 18px 10px 5px; display: block;
    }
    .section-divider { height: 1px; background: var(--sidebar-divider); margin: 5px 8px; }
    .nav-item {
      display: flex; align-items: center; gap: 10px;
      padding: 9px 10px; border-radius: var(--radius-sm);
      color: var(--sidebar-text); text-decoration: none; cursor: pointer;
      transition: background 0.14s, color 0.14s; background: transparent; width: 100%;
      margin-bottom: 1px; border: none; font-family: inherit;
    }
    .nav-item:hover { background: var(--sidebar-hover); color: rgba(255,255,255,0.9); }
    .nav-item.active { background: var(--sidebar-active-bg); color: var(--sidebar-active-text); }
    .nav-icon { color: var(--sidebar-icon); font-size: 19px; flex-shrink: 0; width: 20px; text-align: center; }
    .nav-item.active .nav-icon { color: var(--sidebar-active-text); }
    .nav-item:hover .nav-icon { color: rgba(255,255,255,0.7); }
    .nav-text { font-size: 13.5px; font-weight: 500; flex: 1; }
    .nav-badge {
      background: var(--red); color: #fff; font-size: 10px; font-weight: 800;
      padding: 1px 6px; border-radius: 99px; line-height: 1.6;
    }
    .nav-badge.yellow { background: #d97706; }
    .admin-card {
      margin: 8px 10px 10px; padding: 12px 14px;
      background: rgba(255,255,255,0.05); border-radius: var(--radius-md);
      display: flex; align-items: center; gap: 10px;
      border-top: 1px solid var(--sidebar-divider);
      overflow: hidden; max-height: 80px; opacity: 1;
      transition: max-height 0.25s cubic-bezier(0.4,0,0.2,1),
                  opacity 0.2s ease, margin 0.25s, padding 0.25s;
    }
    .sidebar.collapsed .admin-card {
      max-height: 0; opacity: 0; margin: 0 10px; padding: 0 14px;
      transition: max-height 0.18s cubic-bezier(0.4,0,1,1) 0.04s,
                  opacity 0.12s ease, margin 0.18s ease 0.04s, padding 0.18s ease 0.04s;
    }
    .admin-avatar {
      width: 32px; height: 32px; flex-shrink: 0;
      background: linear-gradient(140deg, #65c478, #2f9e4a);
      border-radius: 50%; display: flex; align-items: center; justify-content: center;
    }
    .admin-info { flex: 1; min-width: 0; }
    .admin-info p { font-size: 12px; font-weight: 700; color: #fff; white-space: nowrap; }
    .admin-info span { font-size: 10px; color: var(--sidebar-label); white-space: nowrap; }

    /* ━━━ TOPBAR ━━━ */
    .main-wrap { flex: 1; display: flex; flex-direction: column; min-width: 0; }
    .topbar {
      background: var(--card); border-bottom: 1px solid var(--border);
      padding: 0 32px; height: 58px;
      display: flex; align-items: center; justify-content: space-between;
      position: sticky; top: 0; z-index: 50;
    }
    .breadcrumb { display: flex; align-items: center; gap: 6px; font-size: 12px; color: var(--text-tertiary); }
    .breadcrumb .current { color: var(--text-primary); font-weight: 700; }
    .topbar-right { display: flex; align-items: center; gap: 8px; }
    .topbar-icon-btn {
      width: 34px; height: 34px; border-radius: var(--radius-sm);
      border: 1px solid var(--border); background: var(--card);
      cursor: pointer; display: flex; align-items: center; justify-content: center;
      color: var(--text-secondary); position: relative; transition: 0.15s;
    }
    .topbar-icon-btn:hover { background: #f8f9fa; color: var(--text-primary); }
    .topbar-icon-btn .dot {
      position: absolute; top: 5px; right: 5px; width: 7px; height: 7px;
      background: var(--red); border-radius: 50%; border: 1.5px solid #fff;
    }

    /* ━━━ MAIN ━━━ */
    .main-content { flex: 1; padding: 32px; overflow-y: auto; }
    .content-stack { display: flex; flex-direction: column; gap: 28px; }

    /* Page Header */
    .page-header { display: flex; justify-content: space-between; align-items: flex-start; }
    .eyebrow {
      font-size: 11px; font-weight: 700; color: var(--accent);
      text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 6px;
      display: flex; align-items: center; gap: 5px;
    }
    .eyebrow .material-symbols-rounded { font-size: 13px; }
    .page-header h2 { font-size: 22px; font-weight: 900; color: var(--text-primary); letter-spacing: -0.5px; }
    .page-header p { font-size: 13px; color: var(--text-tertiary); margin-top: 5px; }
    .page-header-right { display: flex; gap: 10px; align-items: center; flex-shrink: 0; }

    /* Buttons */
    .btn {
      display: inline-flex; align-items: center; gap: 6px;
      padding: 9px 18px; border-radius: var(--radius-sm);
      font-size: 13px; font-weight: 600; cursor: pointer; border: none;
      transition: all 0.15s; font-family: inherit; letter-spacing: -0.01em; white-space: nowrap;
    }
    .btn .material-symbols-rounded { font-size: 17px; }
    .btn-primary { background: var(--accent); color: #fff; box-shadow: 0 1px 3px rgba(59,130,246,0.3); }
    .btn-primary:hover { background: #2563eb; transform: translateY(-1px); box-shadow: 0 3px 10px rgba(59,130,246,0.35); }
    .btn-secondary { background: #fff; color: var(--text-secondary); border: 1px solid var(--border); }
    .btn-secondary:hover { background: #f8f9fa; color: var(--text-primary); }

    /* Stats */
    .stats-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 16px; }
    .stat-card {
      background: var(--card); border-radius: var(--radius-md);
      border: 1px solid var(--border); padding: 20px 22px;
      box-shadow: var(--shadow-xs); position: relative; overflow: hidden;
      transition: box-shadow 0.2s, transform 0.2s;
    }
    .stat-card:hover { box-shadow: var(--shadow-sm); transform: translateY(-1px); }
    .stat-accent { position: absolute; top: 0; left: 0; right: 0; height: 3px; }
    .stat-icon-wrap {
      width: 38px; height: 38px; border-radius: 10px;
      display: flex; align-items: center; justify-content: center; margin-bottom: 14px;
    }
    .stat-icon-wrap .material-symbols-rounded { font-size: 20px; }
    .stat-number { font-size: 28px; font-weight: 900; color: var(--text-primary); letter-spacing: -1px; line-height: 1; }
    .stat-label { font-size: 12px; font-weight: 600; color: var(--text-tertiary); margin-top: 5px; }
    .stat-sub { font-size: 11px; margin-top: 9px; display: flex; align-items: center; gap: 4px; font-weight: 600; }
    .stat-sub .material-symbols-rounded { font-size: 13px; }

    /* Section Card */
    .section-card {
      background: var(--card); border-radius: var(--radius-lg);
      border: 1px solid var(--border); box-shadow: var(--shadow-xs); overflow: hidden;
    }
    .card-header {
      padding: 18px 26px; border-bottom: 1px solid var(--border-light);
      display: flex; align-items: center; justify-content: space-between;
      background: #fafbfc;
    }
    .card-header-left { display: flex; align-items: center; gap: 12px; }
    .card-header-icon {
      width: 34px; height: 34px; border-radius: 9px;
      display: flex; align-items: center; justify-content: center; flex-shrink: 0;
    }
    .card-header-icon .material-symbols-rounded { font-size: 18px; }
    .card-header-text h3 { font-size: 14px; font-weight: 800; color: var(--text-primary); }
    .card-header-text p { font-size: 11.5px; color: var(--text-tertiary); margin-top: 1px; }
    .card-body { padding: 26px; }

    /* Form */
    .form-row { display: grid; gap: 16px; }
    .form-row-2 { grid-template-columns: repeat(2,1fr); }
    .form-row-3 { grid-template-columns: repeat(3,1fr); }
    .input-group { display: flex; flex-direction: column; gap: 5px; }
    .input-label { font-size: 12px; font-weight: 700; color: var(--text-secondary); display: flex; align-items: center; gap: 3px; }
    .input-label .req { color: var(--red); }
    .input-field {
      padding: 10px 13px; border: 1.5px solid #e5e8ec; border-radius: var(--radius-sm);
      font-size: 13.5px; font-family: inherit; color: var(--text-primary); background: #fff;
      transition: border-color 0.18s, box-shadow 0.18s; outline: none;
    }
    .input-field:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
    .input-field::placeholder { color: #c8cdd6; }
    .input-hint { font-size: 11px; color: var(--text-tertiary); }
    .form-divider { height: 1px; background: var(--border-light); }

    /* Role Cards */
    .role-grid { display: grid; grid-template-columns: repeat(2,1fr); gap: 14px; }
    .role-card {
      border: 1.5px solid var(--border); border-radius: var(--radius-md);
      padding: 20px; cursor: pointer; transition: all 0.18s;
      position: relative; background: #fff;
    }
    .role-card:hover { border-color: #c4c9d4; box-shadow: var(--shadow-sm); transform: translateY(-1px); }
    .role-card.selected { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
    .role-top { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 12px; }
    .role-icon { width: 40px; height: 40px; border-radius: 11px; display: flex; align-items: center; justify-content: center; }
    .role-icon .material-symbols-rounded { font-size: 20px; }
    .role-lv { font-size: 10px; font-weight: 800; padding: 3px 9px; border-radius: 99px; }
    .role-card h4 { font-size: 14px; font-weight: 800; color: var(--text-primary); margin-bottom: 2px; }
    .role-desc { font-size: 11.5px; color: var(--text-tertiary); margin-bottom: 13px; line-height: 1.5; }
    .role-perms { display: flex; flex-direction: column; gap: 5px; }
    .perm { display: flex; align-items: center; gap: 7px; font-size: 12px; }
    .perm .material-symbols-rounded { font-size: 14px; flex-shrink: 0; }
    .perm.yes { color: var(--text-secondary); }
    .perm.yes .material-symbols-rounded { color: var(--green); }
    .perm.no { color: var(--text-tertiary); }
    .perm.no .material-symbols-rounded { color: #d1d5db; }
    .role-check {
      position: absolute; top: 12px; right: 12px;
      width: 20px; height: 20px; background: var(--accent);
      border-radius: 50%; display: none; align-items: center; justify-content: center;
    }
    .role-check .material-symbols-rounded { font-size: 13px; color: #fff; }
    .role-card.selected .role-check { display: flex; }

    /* Table */
    .table-toolbar {
      padding: 14px 24px; border-bottom: 1px solid var(--border-light);
      display: flex; align-items: center; gap: 12px; background: #fafbfc;
    }
    .table-toolbar-left { display: flex; align-items: center; gap: 10px; flex: 1; }
    .search-wrap { position: relative; }
    .search-wrap .material-symbols-rounded {
      position: absolute; left: 10px; top: 50%; transform: translateY(-50%);
      font-size: 17px; color: var(--text-tertiary); pointer-events: none;
    }
    .search-input {
      padding: 8px 12px 8px 34px; border: 1.5px solid var(--border);
      border-radius: var(--radius-sm); font-size: 13px; font-family: inherit;
      background: #fff; width: 250px; outline: none; color: var(--text-primary);
      transition: border-color 0.18s, box-shadow 0.18s;
    }
    .search-input:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
    .filter-tabs { display: flex; background: #f0f2f5; border-radius: var(--radius-sm); padding: 3px; gap: 2px; }
    .filter-tab {
      padding: 5px 13px; border-radius: 6px; font-size: 12px; font-weight: 600;
      cursor: pointer; border: none; background: transparent; color: var(--text-tertiary);
      font-family: inherit; transition: all 0.15s;
    }
    .filter-tab.active { background: #fff; color: var(--text-primary); box-shadow: var(--shadow-xs); }

    .data-table { width: 100%; border-collapse: collapse; font-size: 13px; }
    .data-table th {
      padding: 10px 20px; text-align: left; font-size: 11px; font-weight: 800;
      color: var(--text-tertiary); text-transform: uppercase; letter-spacing: 0.05em;
      border-bottom: 1px solid var(--border); background: #f8f9fb; white-space: nowrap;
    }
    .data-table td { padding: 14px 20px; border-bottom: 1px solid var(--border-light); vertical-align: middle; }
    .data-table tbody tr { transition: background 0.12s; }
    .data-table tbody tr:hover { background: #fafbfc; }
    .data-table tbody tr:last-child td { border-bottom: none; }
    .data-table tbody tr.row-inactive td:not(:last-child):not(:nth-last-child(2)) { opacity: 0.4; }

    /* User cell */
    .user-cell { display: flex; align-items: center; gap: 11px; }
    .user-avatar {
      width: 34px; height: 34px; border-radius: 50%; flex-shrink: 0;
      display: flex; align-items: center; justify-content: center;
      font-size: 13px; font-weight: 800;
    }
    .user-name { font-size: 13px; font-weight: 700; color: var(--text-primary); }
    .user-id { font-size: 11px; color: var(--text-tertiary); margin-top: 1px; }

    /* Role badge */
    .role-badge {
      display: inline-flex; align-items: center; gap: 5px;
      padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 700;
    }
    .role-badge .material-symbols-rounded { font-size: 13px; }

    /* Toggle */
    .toggle-wrap { position: relative; display: inline-block; width: 38px; height: 22px; cursor: pointer; }
    .toggle-wrap input { opacity: 0; width: 0; height: 0; }
    .toggle-track { position: absolute; inset: 0; background: #e2e5ea; border-radius: 99px; transition: 0.2s; }
    .toggle-thumb {
      position: absolute; width: 16px; height: 16px; border-radius: 50%;
      background: #fff; top: 3px; left: 3px; transition: 0.2s;
      box-shadow: 0 1px 3px rgba(0,0,0,0.15);
    }
    .toggle-wrap input:checked ~ .toggle-track { background: var(--green); }
    .toggle-wrap input:checked ~ .toggle-thumb { left: 19px; }
    .toggle-cell { display: flex; align-items: center; gap: 8px; }
    .toggle-lbl { font-size: 12px; font-weight: 700; }

    /* Row actions */
    .row-actions { display: flex; align-items: center; gap: 2px; justify-content: flex-end; }
    .action-btn {
      width: 30px; height: 30px; border: none; border-radius: 7px;
      background: transparent; cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      color: var(--text-tertiary); transition: all 0.14s;
    }
    .action-btn .material-symbols-rounded { font-size: 17px; }
    .action-btn:hover { background: #f0f2f5; color: var(--text-secondary); }
    .action-btn.danger:hover { background: #fef2f2; color: var(--red); }
    .action-sep { width: 1px; height: 16px; background: var(--border); margin: 0 4px; }

    /* Table Footer */
    .table-footer {
      padding: 13px 24px; border-top: 1px solid var(--border-light);
      display: flex; align-items: center; justify-content: space-between;
      background: #fafbfc;
    }
    .table-count { font-size: 12px; color: var(--text-tertiary); }
    .table-count strong { color: var(--text-secondary); }
    .pagination { display: flex; gap: 4px; }
    .page-btn {
      width: 30px; height: 30px; border-radius: 7px; border: 1px solid var(--border);
      background: #fff; cursor: pointer; display: flex; align-items: center; justify-content: center;
      font-size: 12px; font-weight: 700; color: var(--text-secondary);
      font-family: inherit; transition: all 0.14s;
    }
    .page-btn:hover { border-color: var(--accent); color: var(--accent); }
    .page-btn.active { background: var(--accent); border-color: var(--accent); color: #fff; }

    /* Misc */
    .icon-btn {
      width: 28px; height: 28px; background: none; border: none; cursor: pointer;
      display: flex; align-items: center; justify-content: center;
      border-radius: 7px; color: var(--sidebar-icon); transition: 0.14s;
    }
    .icon-btn:hover { background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.9); }

    [data-tip] { position: relative; }
    [data-tip]::after {
      content: attr(data-tip); position: absolute; left: 50%; bottom: calc(100% + 7px);
      transform: translateX(-50%); background: #1a2332; color: #fff; font-size: 11px;
      padding: 5px 9px; border-radius: 7px; white-space: nowrap; opacity: 0;
      pointer-events: none; transition: 0.15s; z-index: 999; font-weight: 500;
    }
    [data-tip]:hover::after { opacity: 1; }

    /* Modal */
    .modal-overlay {
      display: none; position: fixed; inset: 0;
      background: rgba(15,23,36,0.5); z-index: 999;
      align-items: center; justify-content: center;
    }
    .modal-overlay.open { display: flex; }
    .modal {
      background: #fff; border-radius: var(--radius-lg);
      width: 520px; box-shadow: var(--shadow-md);
      animation: modalIn 0.22s cubic-bezier(0.34,1.2,0.64,1);
    }
    @keyframes modalIn { from { opacity:0; transform:scale(0.95) translateY(10px); } to { opacity:1; transform:none; } }
    .modal-header {
      padding: 22px 28px 18px; border-bottom: 1px solid var(--border);
      display: flex; align-items: flex-start; justify-content: space-between;
    }
    .modal-header h4 { font-size: 16px; font-weight: 800; }
    .modal-header p { font-size: 12px; color: var(--text-tertiary); margin-top: 3px; }
    .modal-close {
      width: 30px; height: 30px; border: none; background: #f0f2f5;
      border-radius: 7px; cursor: pointer; display: flex; align-items: center; justify-content: center;
      color: var(--text-secondary); transition: 0.15s; flex-shrink: 0;
    }
    .modal-close:hover { background: #e5e8ec; }
    .modal-body { padding: 24px 28px; display: flex; flex-direction: column; gap: 16px; }
    .modal-footer { padding: 16px 28px 22px; display: flex; justify-content: flex-end; gap: 8px; border-top: 1px solid var(--border-light); }
  </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar" id="sidebar">
  <div class="sidebar-logo">
    <div class="logo-mark">
      <div class="logo-icon" id="logoIcon">
        <span class="material-symbols-rounded">home_work</span>
      </div>
      <div class="logo-text">
        <h1>우리집맵핑</h1>
        <p>중앙관리 시스템</p>
      </div>
    </div>
    <button class="collapse-btn" onclick="toggleSidebar()" data-tip="접기">
      <span class="material-symbols-rounded">left_panel_close</span>
    </button>
  </div>

  <nav class="sidebar-nav">
    <div class="nav-group">
      <a href="#" class="nav-item" onclick="setActive(this,'대시보드','대시보드')">
        <span class="material-symbols-rounded nav-icon">grid_view</span>
        <span class="nav-text">대시보드</span>
      </a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">건물 · 입주민</span>
      <a href="#" class="nav-item" onclick="setActive(this,'매물 통합 검색','건물·입주민')">
        <span class="material-symbols-rounded nav-icon">manage_search</span>
        <span class="nav-text">매물 통합 검색</span>
      </a>
      <a href="#" class="nav-item" onclick="setActive(this,'건물 등록 및 열람','건물·입주민')">
        <span class="material-symbols-rounded nav-icon">apartment</span>
        <span class="nav-text">건물 등록 및 열람</span>
      </a>
      <a href="#" class="nav-item" onclick="setActive(this,'입주민 관리','건물·입주민')">
        <span class="material-symbols-rounded nav-icon">groups</span>
        <span class="nav-text">입주민 관리</span>
      </a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">계약 · 재무</span>
      <a href="#" class="nav-item" onclick="setActive(this,'계약 관리','계약·재무')">
        <span class="material-symbols-rounded nav-icon">contract</span>
        <span class="nav-text">계약 관리</span>
      </a>
      <a href="#" class="nav-item" onclick="setActive(this,'통계','계약·재무')">
        <span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span>
        <span class="nav-text">통계</span>
      </a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">민원 · 소통</span>
      <a href="#" class="nav-item" onclick="setActive(this,'민원 관리','민원·소통')">
        <span class="material-symbols-rounded nav-icon">support_agent</span>
        <span class="nav-text">민원 관리</span>
        <span class="nav-badge">3</span>
      </a>
      <a href="#" class="nav-item" onclick="setActive(this,'문의 관리','민원·소통')">
        <span class="material-symbols-rounded nav-icon">forum</span>
        <span class="nav-text">문의 관리</span>
        <span class="nav-badge yellow">4</span>
      </a>
      <a href="#" class="nav-item" onclick="setActive(this,'공고 관리','민원·소통')">
        <span class="material-symbols-rounded nav-icon">campaign</span>
        <span class="nav-text">공고 관리</span>
      </a>
      <a href="#" class="nav-item" onclick="setActive(this,'통합 게시판 관리','민원·소통')">
        <span class="material-symbols-rounded nav-icon">article</span>
        <span class="nav-text">통합 게시판 관리</span>
      </a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">시설 · 시스템</span>
      <a href="#" class="nav-item" onclick="setActive(this,'시설 관리','시설·시스템')">
        <span class="material-symbols-rounded nav-icon">handyman</span>
        <span class="nav-text">시설 관리</span>
      </a>
      <a href="#" class="nav-item" onclick="setActive(this,'비정상 세대 관리','시설·시스템')">
        <span class="material-symbols-rounded nav-icon">warning</span>
        <span class="nav-text">비정상 세대 관리</span>
      </a>
      <a href="#" class="nav-item active" onclick="setActive(this,'하위관리자 계정','시설·시스템')">
        <span class="material-symbols-rounded nav-icon">manage_accounts</span>
        <span class="nav-text">하위관리자 계정</span>
      </a>
    </div>
  </nav>

  <div class="admin-card">
    <div class="admin-avatar">
      <span class="material-symbols-rounded" style="color:#fff;font-size:16px;">person</span>
    </div>
    <div class="admin-info">
      <p>중앙관리자</p>
      <span>클로드 최고</span>
    </div>
    <button class="icon-btn" data-tip="로그아웃" style="margin-left:auto;flex-shrink:0;">
      <span class="material-symbols-rounded" style="font-size:18px;">logout</span>
    </button>
  </div>
</aside>

<!-- MAIN -->
<div class="main-wrap">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="material-symbols-rounded" style="font-size:14px;">home</span>
      <span style="color:var(--border);">/</span>
      <span id="bc-parent">시설·시스템</span>
      <span style="color:var(--border);">/</span>
      <span class="current" id="bc-current">하위관리자 계정</span>
    </div>
    <div class="topbar-right">
      <button class="topbar-icon-btn" data-tip="알림">
        <span class="material-symbols-rounded" style="font-size:18px;">notifications</span>
        <div class="dot"></div>
      </button>
      <button class="topbar-icon-btn" data-tip="설정">
        <span class="material-symbols-rounded" style="font-size:18px;">settings</span>
      </button>
    </div>
  </div>

  <div class="main-content">
    <div class="content-stack">

      <!-- ① Header -->
      <div class="page-header">
        <div>
          <div class="eyebrow">
            <span class="material-symbols-rounded">manage_accounts</span>
            시설 · 시스템
          </div>
          <h2>하위 관리자 계정 관리</h2>
          <p>단지별 계정 생성 및 매핑 · 권한 레벨 설정 · 활성화 상태를 통합 제어합니다.</p>
        </div>
        <div class="page-header-right">
          <button class="btn btn-secondary">
            <span class="material-symbols-rounded">download</span>엑셀 내보내기
          </button>
          <button class="btn btn-primary" onclick="openModal()">
            <span class="material-symbols-rounded">person_add</span>신규 계정 생성
          </button>
        </div>
      </div>

      <!-- ② Stats -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-accent" style="background:linear-gradient(90deg,#3b82f6,#93c5fd);"></div>
          <div class="stat-icon-wrap" style="background:#eff6ff;">
            <span class="material-symbols-rounded" style="color:#3b82f6;">groups</span>
          </div>
          <div class="stat-number">24</div>
          <div class="stat-label">전체 계정</div>
          <div class="stat-sub" style="color:#3b82f6;">
            <span class="material-symbols-rounded">trending_up</span>이번 달 +2
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-accent" style="background:linear-gradient(90deg,#10b981,#6ee7b7);"></div>
          <div class="stat-icon-wrap" style="background:#ecfdf5;">
            <span class="material-symbols-rounded" style="color:#10b981;">check_circle</span>
          </div>
          <div class="stat-number">22</div>
          <div class="stat-label">활성 계정</div>
          <div class="stat-sub" style="color:#10b981;">
            <span class="material-symbols-rounded">radio_button_checked</span>정상 운영중
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-accent" style="background:linear-gradient(90deg,#ef4444,#fca5a5);"></div>
          <div class="stat-icon-wrap" style="background:#fef2f2;">
            <span class="material-symbols-rounded" style="color:#ef4444;">do_not_disturb_on</span>
          </div>
          <div class="stat-number">2</div>
          <div class="stat-label">비활성 계정</div>
          <div class="stat-sub" style="color:#ef4444;">
            <span class="material-symbols-rounded">warning</span>조치 필요
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-accent" style="background:linear-gradient(90deg,#8b5cf6,#c4b5fd);"></div>
          <div class="stat-icon-wrap" style="background:#f5f3ff;">
            <span class="material-symbols-rounded" style="color:#8b5cf6;">apartment</span>
          </div>
          <div class="stat-number">6</div>
          <div class="stat-label">관리 단지 수</div>
          <div class="stat-sub" style="color:#8b5cf6;">
            <span class="material-symbols-rounded">location_city</span>전체 운영
          </div>
        </div>
      </div>

      <!-- ③ 권한 레벨 -->
      <div class="section-card">
        <div class="card-header">
          <div class="card-header-left">
            <div class="card-header-icon" style="background:#f5f3ff;">
              <span class="material-symbols-rounded" style="color:#8b5cf6;">shield_person</span>
            </div>
            <div class="card-header-text">
              <h3>권한 레벨 정의</h3>
              <p>역할에 따른 시스템 접근 범위 — 계정 생성 시 아래 레벨 중 하나를 부여합니다</p>
            </div>
          </div>
        </div>
        <div class="card-body">
          <div class="role-grid" id="roleGrid">
            <div class="role-card selected" onclick="selectRole(this)">
              <div class="role-check"><span class="material-symbols-rounded">check</span></div>
              <div class="role-top">
                <div class="role-icon" style="background:#eff6ff;">
                  <span class="material-symbols-rounded" style="color:#3b82f6;">shield_person</span>
                </div>
                <span class="role-lv" style="background:#eff6ff;color:#3b82f6;">Lv. 4</span>
              </div>
              <h4>관리소장</h4>
              <p class="role-desc">단지 내 최상위 관리 권한. 모든 메뉴에 접근 가능합니다.</p>
              <div class="role-perms">
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>전체 메뉴 열람 및 편집</div>
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>계약·재무 전체 처리</div>
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>민원·공고 승인 처리</div>
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>하위 계정 현황 열람</div>
              </div>
            </div>
            <div class="role-card" onclick="selectRole(this)">
              <div class="role-check"><span class="material-symbols-rounded">check</span></div>
              <div class="role-top">
                <div class="role-icon" style="background:#fffbeb;">
                  <span class="material-symbols-rounded" style="color:#d97706;">account_balance</span>
                </div>
                <span class="role-lv" style="background:#fffbeb;color:#d97706;">Lv. 3</span>
              </div>
              <h4>회계</h4>
              <p class="role-desc">재무 데이터 전담. 수납·정산 처리에 특화된 권한입니다.</p>
              <div class="role-perms">
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>계약·재무 전체 접근</div>
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>수납 내역 조회 및 수정</div>
                <div class="perm no"><span class="material-symbols-rounded">remove_circle</span>민원·시설 접근 불가</div>
                <div class="perm no"><span class="material-symbols-rounded">remove_circle</span>계정 관리 불가</div>
              </div>
            </div>
            <div class="role-card" onclick="selectRole(this)">
              <div class="role-check"><span class="material-symbols-rounded">check</span></div>
              <div class="role-top">
                <div class="role-icon" style="background:#f0fdf4;">
                  <span class="material-symbols-rounded" style="color:#16a34a;">edit_document</span>
                </div>
                <span class="role-lv" style="background:#f0fdf4;color:#16a34a;">Lv. 2</span>
              </div>
              <h4>행정</h4>
              <p class="role-desc">입주민 소통 전담. 민원·문의·공고 처리에 집중합니다.</p>
              <div class="role-perms">
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>입주민 관리 열람</div>
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>민원·문의·공고 처리</div>
                <div class="perm no"><span class="material-symbols-rounded">remove_circle</span>재무 데이터 접근 불가</div>
                <div class="perm no"><span class="material-symbols-rounded">remove_circle</span>계정 관리 불가</div>
              </div>
            </div>
            <div class="role-card" onclick="selectRole(this)">
              <div class="role-check"><span class="material-symbols-rounded">check</span></div>
              <div class="role-top">
                <div class="role-icon" style="background:#fdf4ff;">
                  <span class="material-symbols-rounded" style="color:#a21caf;">handyman</span>
                </div>
                <span class="role-lv" style="background:#fdf4ff;color:#a21caf;">Lv. 1</span>
              </div>
              <h4>시설</h4>
              <p class="role-desc">시설 점검 전담. 최소 접근 권한으로 운영됩니다.</p>
              <div class="role-perms">
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>시설 민원 열람·처리</div>
                <div class="perm yes"><span class="material-symbols-rounded">check_circle</span>점검 일지 작성</div>
                <div class="perm no"><span class="material-symbols-rounded">remove_circle</span>재무·계약 접근 불가</div>
                <div class="perm no"><span class="material-symbols-rounded">remove_circle</span>입주민 개인정보 불가</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ④ 계정 목록 -->
      <div class="section-card">
        <div class="card-header">
          <div class="card-header-left">
            <div class="card-header-icon" style="background:#eff6ff;">
              <span class="material-symbols-rounded" style="color:#3b82f6;">person_search</span>
            </div>
            <div class="card-header-text">
              <h3>계정 목록 및 활성화 관리</h3>
              <p>토글로 즉시 활성화·비활성화 처리 가능합니다</p>
            </div>
          </div>
        </div>

        <div class="table-toolbar">
          <div class="table-toolbar-left">
            <div class="search-wrap">
              <span class="material-symbols-rounded">search</span>
              <input class="search-input" type="text" placeholder="이름, 아이디, 단지명 검색..." oninput="searchTable(this.value)">
            </div>
            <div class="filter-tabs">
              <button class="filter-tab active" onclick="filterTable('all',this)">전체 <span style="color:var(--text-tertiary);">24</span></button>
              <button class="filter-tab" onclick="filterTable('active',this)">활성 <span style="color:var(--text-tertiary);">22</span></button>
              <button class="filter-tab" onclick="filterTable('inactive',this)">비활성 <span style="color:var(--text-tertiary);">2</span></button>
            </div>
          </div>
          <button class="btn btn-secondary" style="padding:7px 13px;font-size:12px;">
            <span class="material-symbols-rounded" style="font-size:16px;">tune</span>필터
          </button>
        </div>

        <div style="overflow-x:auto;">
          <table class="data-table" id="accountTable">
            <thead>
              <tr>
                <th>관리자 정보</th>
                <th>소속 단지</th>
                <th>권한 레벨</th>
                <th>최근 접속</th>
                <th>활성화</th>
                <th style="text-align:right;padding-right:24px;">관리</th>
              </tr>
            </thead>
            <tbody>
              <tr data-status="active" data-name="김관리 admin_kim 행복아파트">
                <td>
                  <div class="user-cell">
                    <div class="user-avatar" style="background:#dbeafe;color:#1d4ed8;">김</div>
                    <div><div class="user-name">김관리</div><div class="user-id">admin_kim</div></div>
                  </div>
                </td>
                <td style="color:var(--text-secondary);">행복아파트 · A단지</td>
                <td><span class="role-badge" style="background:#eff6ff;color:#1d4ed8;"><span class="material-symbols-rounded">shield_person</span>관리소장</span></td>
                <td style="font-size:12px;color:var(--text-tertiary);"><div>2026-04-21</div><div style="color:#d1d5db;font-size:11px;">15:30</div></td>
                <td>
                  <div class="toggle-cell">
                    <label class="toggle-wrap"><input type="checkbox" checked onchange="onToggle(this)"><div class="toggle-track"></div><div class="toggle-thumb"></div></label>
                    <span class="toggle-lbl" style="color:var(--green);">활성</span>
                  </div>
                </td>
                <td><div class="row-actions">
                  <button class="action-btn" data-tip="수정"><span class="material-symbols-rounded">edit_square</span></button>
                  <button class="action-btn" data-tip="비밀번호 재설정"><span class="material-symbols-rounded">key</span></button>
                  <button class="action-btn" data-tip="권한 변경"><span class="material-symbols-rounded">manage_accounts</span></button>
                  <div class="action-sep"></div>
                  <button class="action-btn danger" data-tip="계정 삭제"><span class="material-symbols-rounded">delete_outline</span></button>
                </div></td>
              </tr>
              <tr data-status="active" data-name="이회계 acct_lee 행복아파트">
                <td>
                  <div class="user-cell">
                    <div class="user-avatar" style="background:#fef3c7;color:#92400e;">이</div>
                    <div><div class="user-name">이회계</div><div class="user-id">acct_lee</div></div>
                  </div>
                </td>
                <td style="color:var(--text-secondary);">행복아파트 · A단지</td>
                <td><span class="role-badge" style="background:#fffbeb;color:#92400e;"><span class="material-symbols-rounded">account_balance</span>회계</span></td>
                <td style="font-size:12px;color:var(--text-tertiary);"><div>2026-04-20</div><div style="color:#d1d5db;font-size:11px;">09:11</div></td>
                <td>
                  <div class="toggle-cell">
                    <label class="toggle-wrap"><input type="checkbox" checked onchange="onToggle(this)"><div class="toggle-track"></div><div class="toggle-thumb"></div></label>
                    <span class="toggle-lbl" style="color:var(--green);">활성</span>
                  </div>
                </td>
                <td><div class="row-actions">
                  <button class="action-btn" data-tip="수정"><span class="material-symbols-rounded">edit_square</span></button>
                  <button class="action-btn" data-tip="비밀번호 재설정"><span class="material-symbols-rounded">key</span></button>
                  <button class="action-btn" data-tip="권한 변경"><span class="material-symbols-rounded">manage_accounts</span></button>
                  <div class="action-sep"></div>
                  <button class="action-btn danger" data-tip="계정 삭제"><span class="material-symbols-rounded">delete_outline</span></button>
                </div></td>
              </tr>
              <tr data-status="active" data-name="박행정 admin_park 희망빌라">
                <td>
                  <div class="user-cell">
                    <div class="user-avatar" style="background:#dcfce7;color:#166534;">박</div>
                    <div><div class="user-name">박행정</div><div class="user-id">admin_park</div></div>
                  </div>
                </td>
                <td style="color:var(--text-secondary);">희망빌라 · B단지</td>
                <td><span class="role-badge" style="background:#f0fdf4;color:#166534;"><span class="material-symbols-rounded">edit_document</span>행정</span></td>
                <td style="font-size:12px;color:var(--text-tertiary);"><div>2026-04-21</div><div style="color:#d1d5db;font-size:11px;">11:42</div></td>
                <td>
                  <div class="toggle-cell">
                    <label class="toggle-wrap"><input type="checkbox" checked onchange="onToggle(this)"><div class="toggle-track"></div><div class="toggle-thumb"></div></label>
                    <span class="toggle-lbl" style="color:var(--green);">활성</span>
                  </div>
                </td>
                <td><div class="row-actions">
                  <button class="action-btn" data-tip="수정"><span class="material-symbols-rounded">edit_square</span></button>
                  <button class="action-btn" data-tip="비밀번호 재설정"><span class="material-symbols-rounded">key</span></button>
                  <button class="action-btn" data-tip="권한 변경"><span class="material-symbols-rounded">manage_accounts</span></button>
                  <div class="action-sep"></div>
                  <button class="action-btn danger" data-tip="계정 삭제"><span class="material-symbols-rounded">delete_outline</span></button>
                </div></td>
              </tr>
              <tr data-status="inactive" class="row-inactive" data-name="최시설 facility_choi 미래아파트">
                <td>
                  <div class="user-cell">
                    <div class="user-avatar" style="background:#f3f4f6;color:#9ca3af;">최</div>
                    <div><div class="user-name" style="color:var(--text-tertiary);">최시설</div><div class="user-id">facility_choi</div></div>
                  </div>
                </td>
                <td style="color:var(--text-tertiary);">미래아파트 · C단지</td>
                <td><span class="role-badge" style="background:#f9fafb;color:#9ca3af;"><span class="material-symbols-rounded">handyman</span>시설</span></td>
                <td style="font-size:12px;color:#d1d5db;"><div>2026-03-10</div><div style="color:#e5e7eb;font-size:11px;">08:00</div></td>
                <td>
                  <div class="toggle-cell">
                    <label class="toggle-wrap"><input type="checkbox" onchange="onToggle(this)"><div class="toggle-track"></div><div class="toggle-thumb"></div></label>
                    <span class="toggle-lbl" style="color:var(--text-tertiary);">비활성</span>
                  </div>
                </td>
                <td><div class="row-actions">
                  <button class="action-btn" data-tip="수정"><span class="material-symbols-rounded">edit_square</span></button>
                  <button class="action-btn" data-tip="비밀번호 재설정"><span class="material-symbols-rounded">key</span></button>
                  <button class="action-btn" data-tip="권한 변경"><span class="material-symbols-rounded">manage_accounts</span></button>
                  <div class="action-sep"></div>
                  <button class="action-btn danger" data-tip="계정 삭제"><span class="material-symbols-rounded">delete_outline</span></button>
                </div></td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="table-footer">
          <span class="table-count">총 <strong>4</strong>개 계정 표시 중</span>
          <div class="pagination">
            <button class="page-btn"><span class="material-symbols-rounded" style="font-size:15px;">chevron_left</span></button>
            <button class="page-btn active">1</button>
            <button class="page-btn">2</button>
            <button class="page-btn">3</button>
            <button class="page-btn"><span class="material-symbols-rounded" style="font-size:15px;">chevron_right</span></button>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<!-- MODAL -->
<div class="modal-overlay" id="modalOverlay" onclick="closeModalOutside(event)">
  <div class="modal">
    <div class="modal-header">
      <div>
        <h4>신규 계정 생성 및 단지 매핑</h4>
        <p>계정을 생성하고 담당 단지에 즉시 매핑합니다</p>
      </div>
      <button class="modal-close" onclick="closeModal()">
        <span class="material-symbols-rounded" style="font-size:18px;">close</span>
      </button>
    </div>
    <div class="modal-body">
      <div class="form-row form-row-2">
        <div class="input-group">
          <label class="input-label">관리자 이름 <span class="req">*</span></label>
          <input class="input-field" type="text" placeholder="성명 입력">
        </div>
        <div class="input-group">
          <label class="input-label">접속 아이디 <span class="req">*</span></label>
          <input class="input-field" type="text" placeholder="6자 이상">
          <span class="input-hint">영문·숫자 조합 권장</span>
        </div>
      </div>
      <div class="form-row form-row-2">
        <div class="input-group">
          <label class="input-label">임시 비밀번호 <span class="req">*</span></label>
          <input class="input-field" type="password" placeholder="초기 비밀번호 설정">
        </div>
        <div class="input-group">
          <label class="input-label">연락처</label>
          <input class="input-field" type="text" placeholder="010-0000-0000">
        </div>
      </div>
      <div class="form-divider"></div>
      <div class="form-row form-row-2">
        <div class="input-group">
          <label class="input-label">소속 단지 <span class="req">*</span></label>
          <select class="input-field">
            <option value="">단지 선택</option>
            <option>A단지 · 행복아파트</option>
            <option>B단지 · 희망빌라</option>
            <option>C단지 · 미래아파트</option>
            <option>D단지 · 푸른마을</option>
          </select>
        </div>
        <div class="input-group">
          <label class="input-label">권한 레벨 <span class="req">*</span></label>
          <select class="input-field">
            <option>관리소장 (Lv.4)</option>
            <option>회계 (Lv.3)</option>
            <option>행정 (Lv.2)</option>
            <option>시설 (Lv.1)</option>
          </select>
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-secondary" onclick="closeModal()">취소</button>
      <button class="btn btn-primary">
        <span class="material-symbols-rounded">person_add</span>계정 생성
      </button>
    </div>
  </div>
</div>

<script>
  function toggleSidebar() {
    document.getElementById('sidebar').classList.toggle('collapsed');
  }
  document.getElementById('logoIcon').addEventListener('click', () => {
    if (document.getElementById('sidebar').classList.contains('collapsed')) toggleSidebar();
  });
  function setActive(el, page, parent) {
    document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
    el.classList.add('active');
    document.getElementById('bc-current').textContent = page;
    document.getElementById('bc-parent').textContent = parent;
  }
  function selectRole(card) {
    document.querySelectorAll('.role-card').forEach(c => c.classList.remove('selected'));
    card.classList.add('selected');
  }
  function onToggle(cb) {
    const row = cb.closest('tr');
    const lbl = row.querySelector('.toggle-lbl');
    const active = cb.checked;
    row.dataset.status = active ? 'active' : 'inactive';
    row.classList.toggle('row-inactive', !active);
    lbl.textContent = active ? '활성' : '비활성';
    lbl.style.color = active ? 'var(--green)' : 'var(--text-tertiary)';
  }
  function filterTable(status, btn) {
    document.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('#accountTable tbody tr').forEach(row => {
      row.style.display = (status === 'all' || row.dataset.status === status) ? '' : 'none';
    });
  }
  function searchTable(val) {
    const q = val.toLowerCase();
    document.querySelectorAll('#accountTable tbody tr').forEach(row => {
      row.style.display = row.dataset.name.toLowerCase().includes(q) ? '' : 'none';
    });
  }
  function openModal() { document.getElementById('modalOverlay').classList.add('open'); }
  function closeModal() { document.getElementById('modalOverlay').classList.remove('open'); }
  function closeModalOutside(e) { if (e.target === document.getElementById('modalOverlay')) closeModal(); }
</script>
</body>
</html>

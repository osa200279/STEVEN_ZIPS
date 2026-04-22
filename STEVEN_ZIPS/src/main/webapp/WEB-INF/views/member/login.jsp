<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: PC-24
  Date: 2026-04-22
  Time: 오후 3:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login form</title>
</head>
<body>
    <form action="/login" method="post">
        <input type="text" name="username" placeholder="ID"/><br>
        <input type="text" name="password" placeholder="PW"/><br>
        <input type="submit" value="인증"/>
        <sec:csrfInput/>
    </form>
</body>
</html>

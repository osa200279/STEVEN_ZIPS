<%--
  Created by IntelliJ IDEA.
  User: PC-14
  Date: 2026-04-23
  Time: 오후 4:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>아파트목록조회</title>
  <input type="button" value="마포구apt동기화" id="aptBtn" onclick="collect()">
</head>
<body>


</body>
<script !src="">
    async function collect() {
        const res = await fetch('/apt/collect', {
            method: 'POST'
        });

        const text = await res.text();
        alert(text);
    }
</script>

</html>

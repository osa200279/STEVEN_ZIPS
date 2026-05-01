<%--
  Created by IntelliJ IDEA.
  User: LYR
  Date: 2026-04-29
  Time: 오후 5:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h1>나의 아파트</h1>
<c:choose>
        <c:when test="${not empty resident.myAptList}">
            <table border="1">
            <tr>
                <th>아파트 명</th>
            </tr>
            <c:forEach var="myapt" items="${resident.myAptList}">
                <tr>
                    <td>
                        ${myapt.aptCmplexNm} ${myapt.dongNm}동 ${myapt.ho}호
                    </td>
                    <td>
                        <a href="/apt-main?aptCmplexNo=${myapt.aptCmplexNo}">GO!➡️</a>
                    </td>
                </tr>
            </c:forEach>
            </table>
        </c:when>
    <c:otherwise>
        조회된 아파트가 없습니다!
    </c:otherwise>
</c:choose>
</body>
</html>

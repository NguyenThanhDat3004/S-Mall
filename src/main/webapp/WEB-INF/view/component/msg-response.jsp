<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <c:if test="${not empty message}">
        <!-- DEBUG: Component Is Loaded -->
        <div style="padding:10px;border:1px solid #08e835;background:#eee;">
            ${message}
        </div>
    </c:if>
    <div style="font-size: 10px; color: #ccc;">(msg-component loaded)</div>
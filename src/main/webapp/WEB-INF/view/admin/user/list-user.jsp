<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List Users</title>
  </head>

  <body>
    <jsp:include page="/WEB-INF/view/component/msg-response.jsp" />
    <h1>Users available</h1>

    <c:if test="${empty users}">
      <p>No users found.</p>
    </c:if>

    <c:if test="${not empty users}">
      <table border="1" cellpadding="6" cellspacing="0">
        <thead>
          <tr>
            <th>ID</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Gender</th>
            <th>Address</th>
            <th>Date of Birth</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="u" items="${users}">
            <tr>
              <td>${u.id}</td>
              <td>${u.fullName}</td>
              <td>${u.email}</td>
              <td>
                <c:choose>
                  <c:when test="${u.gender}">Male</c:when>
                  <c:otherwise>Female</c:otherwise>
                </c:choose>
              </td>
              <td>${u.address}</td>
              <td>${u.dateOfBirth}</td>
              <td>
                <form action="${pageContext.request.contextPath}/admin/user/delete" method="post"
                  style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this user?')">
                  <input type="hidden" name="id" value="${u.id}">
                  <button type="submit">Delete</button>
                </form>
                <button><a href="${pageContext.request.contextPath}/admin/user/update?id=${u.id}">Update</a></button>
                <button><a href="${pageContext.request.contextPath}/admin/user/view?id=${u.id}">View</a></button>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>
  </body>

  </html>
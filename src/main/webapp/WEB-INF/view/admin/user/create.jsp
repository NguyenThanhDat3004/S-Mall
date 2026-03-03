<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@taglib
uri="http://www.springframework.org/tags/form" prefix="form" %>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <!-- bootstrap -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6F"
      crossorigin="anonymous"
    />
    <!-- js -->
    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  </head>
  <body>
    <form:form
      method="post"
      action="/admin/user/create"
      modelAttribute="userProfile"
    >
      <div>
        <form:label path="email">Email:</form:label>
        <form:input type="text" path="email" class="form-control" />
      </div>
      <div>
        <form:label path="fullName">FullName:</form:label>
        <form:input type="text" path="fullName" class="form-control" />
      </div>
      <div>
        <form:label path="gender">Gender:</form:label>
        <form:input type="text" path="gender" class="form-control" />
      </div>
      <div>
        <form:label path="address">Address:</form:label>
        <form:input type="text" path="address" class="form-control" />
      </div>
      <div>
        <form:label path="dateOfBirth">Date Of Birth:</form:label>
        <form:input type="date" path="dateOfBirth" class="form-control" />
      </div>
      <button>Submit</button>
    </form:form>
  </body>
</html>

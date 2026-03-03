<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Update User</title>
        </head>

        <body>
            <h1>Update User</h1>

            <form:form action="${pageContext.request.contextPath}/admin/user/update" method="post"
                modelAttribute="userProfile">
                <form:hidden path="id" />
                <div>
                    <label>Full name:</label>
                    <form:input path="fullName" />
                </div>
                <div>
                    <label>Email:</label>
                    <form:input type="email" path="email" />
                </div>
                <div>
                    <label>Gender:</label>
                    <form:select path="gender">
                        <form:option value="true">Male</form:option>
                        <form:option value="false">Female</form:option>
                    </form:select>
                </div>
                <div>
                    <label>Address:</label>
                    <form:input path="address" />
                </div>
                <div>
                    <label>Date of Birth:</label>
                    <form:input type="date" path="dateOfBirth" />
                </div>
                <div>
                    <button type="submit">Update</button>
                    <button type="button"><a
                            href="${pageContext.request.contextPath}/admin/user/list-user">Cancel</a></button>
                </div>
            </form:form>
        </body>

        </html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="url" value="${pageContext.request.contextPath}" />
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>S-Mall | Modern E-Commerce Marketplace</title>

            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <!-- Custom CSS -->
            <link rel="stylesheet" href="${url}/css/client/header.css">
            <link rel="stylesheet" href="${url}/css/client/homepage.css">
        </head>

        <body>

            <!-- Include Header -->
            <jsp:include page="../layout/header.jsp" />


            <!-- Main Content Area -->
            <main class="container">
                <div class="row">
                    <div class="col-12">
                        <h2 class="mb-4">Featured Products</h2>
                        <!-- Product grid will go here in next steps -->
                        <div class="alert alert-info py-5 text-center">
                            <p class="mb-0">Product listing feature is currently under development. Stay tuned!</p>
                        </div>
                    </div>
                </div>
            </main>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>
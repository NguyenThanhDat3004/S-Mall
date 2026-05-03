<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy cập bị từ chối | S-Mall Passport</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #f43f5e;
            --bg: #0f172a;
            --text: #f8fafc;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }
        .container {
            max-width: 400px;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        h1 { font-size: 1.5rem; margin-bottom: 1rem; }
        p { color: #94a3b8; line-height: 1.6; }
        .btn {
            display: inline-block;
            margin-top: 2rem;
            padding: 0.75rem 2rem;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: transform 0.2s;
        }
        .btn:hover { transform: scale(1.05); }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">🚫</div>
        <h1>Truy cập bị từ chối</h1>
        <p>${message != null ? message : "Bạn không có quyền truy cập vào thông tin đơn hàng này."}</p>
        <a href="/" class="btn">Quay lại Trang chủ</a>
    </div>
</body>
</html>

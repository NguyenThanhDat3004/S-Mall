<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quét mã thành công | S-Mall</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f8fafc; font-family: 'Plus Jakarta Sans', sans-serif; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .card { max-width: 400px; padding: 40px 20px; border-radius: 24px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.05); text-align: center; }
        .icon-box { width: 80px; height: 80px; background: #f0fdf4; color: #22c55e; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; margin: 0 auto 20px; }
        h2 { font-weight: 800; color: #1e293b; margin-bottom: 15px; }
        p { color: #64748b; line-height: 1.6; margin-bottom: 30px; }
        .btn-home { background: #EE4D2D; color: white; border-radius: 12px; padding: 12px 30px; font-weight: 700; text-decoration: none; transition: all 0.2s; }
        .btn-home:hover { opacity: 0.9; transform: translateY(-2px); color: white; }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon-box">
            <i class="fas fa-check-circle"></i>
        </div>
        <h2>Quét mã thành công!</h2>
        <p>${message}</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-home">Về trang chủ</a>
    </div>
</body>
</html>

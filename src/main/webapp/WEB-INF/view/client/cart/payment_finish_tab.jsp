<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận thanh toán thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }
        .success-card {
            background: white;
            padding: 3rem;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        .icon-box {
            width: 80px;
            height: 80px;
            background: #d4edda;
            color: #28a745;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 1.5rem;
        }
    </style>
</head>
<body>
    <div class="success-card">
        <div class="icon-box">
            <i class="fas fa-check"></i>
        </div>
        <h2 class="fw-bold mb-3">Thành Công!</h2>
        <p class="text-muted mb-4">Đơn hàng của bạn đã được xác nhận. Bạn có thể đóng cửa sổ này và quay lại trang chính để theo dõi đơn hàng.</p>
        <button class="btn btn-primary w-100 py-3 fw-bold" style="border-radius: 12px;" onclick="window.close()">
            Đóng cửa sổ này
        </button>
        <p class="mt-3 small text-muted">Cửa sổ sẽ tự động đóng sau vài giây...</p>
    </div>

    <script>
        // Tự động đóng sau 5 giây
        setTimeout(function() {
            window.close();
        }, 5000);
    </script>
</body>
</html>

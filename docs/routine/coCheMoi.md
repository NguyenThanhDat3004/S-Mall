có một cái khi f5 không bị mất dữ liệu khi đang nhập :
- nhớ bổ sung cơ chế nếu như một người cố gắng đăng nhập bằng tài khoản của bạn thì gửi mail báo về cho người dùng biết







----------
ở đây tôi có giỏ hàng rồi mà : promt tập trung vào: nếu như hện thống phát hiện ra là người dùng chưa đầy đủ thông tin thì yêu cầu người dùng nhập đầy đủ trước khi tiến hành thanh toán, tức là hiện tại tôi đang ở cart và tôi bấm thanh toán thì nó sẽ hiện ra form điền thông tin địa chỉ nếu chưa có, nếu đầy đủ rồi thì một cái hóa đơn nháp hiện ra với các thông số từ shop nào đến người nhận nào, số điện thoại địa chỉ chi tiết các mặt hàng, các mục chọn voucher và các thông tin kia là thông tin mặc định tuy nhiên người dùng muốn thì vẫn có thể đặt lại và nếu người dùng click vào lưu địa chỉ thì chúng ta sẽ lưu vào redis với thời gian là vô thời hạn cho tới khi xóa, người dùng cũng có thể chọn loại giao hàng, bảo hiểm hàng, có các loại giao hàng như tiết kiệm, hỏa tốc và nhanh, ngoài ra người dùng cũng có thể lựa chọn phương thức thanh toán nữa, có thể chọn là thanh toán bằng tài khoản ngân hàng chuyển khoản qr hoặc là thanh toán lúc nhận hàng. người dùng bấm thanh toán xong thì chúng sẽ hiện ra màn hình đơn hàng gồm có đang xử lí, đang chuẩn bị đơn, đang giao, đã giao, đã hủy, đánh giá, ngoài ra còn có một mã qr được gửi về mail để có thể quét xem đơn hàng nhanh nữa, và chắc chắn rồi khi mà thành công thì bên thông báo trên web phải hiện một cái là đã đặt thành công và bạn có muốn xem đơn hàng không và nhấp vào thì hiện ra đơn hàng oke không. đưa promt figma
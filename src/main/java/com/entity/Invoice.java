package com.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Invoice {
    private int invoiceId;
    private int userId;
    private int showtimeId;
    private LocalDateTime bookingTime;
    private LocalDateTime expiryTime;
    private String status;
    private BigDecimal totalAmount;
    private String ticketCode;

    public Invoice() {
        this.bookingTime = LocalDateTime.now();
        this.status = "Pending";
    }

    public Invoice(int invoiceId, int userId, int showtimeId, LocalDateTime bookingTime, LocalDateTime expiryTime, String status, BigDecimal totalAmount, String ticketCode) {
        this.invoiceId = invoiceId;
        this.userId = userId;
        this.showtimeId = showtimeId;
        this.bookingTime = bookingTime;
        this.expiryTime = expiryTime;
        this.status = status;
        this.totalAmount = totalAmount;
        this.ticketCode = ticketCode;
    }

    // Getters and Setters
    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getShowtimeId() { return showtimeId; }
    public void setShowtimeId(int showtimeId) { this.showtimeId = showtimeId; }

    public LocalDateTime getBookingTime() { return bookingTime; }
    public void setBookingTime(LocalDateTime bookingTime) { this.bookingTime = bookingTime; }

    public LocalDateTime getExpiryTime() { return expiryTime; }
    public void setExpiryTime(LocalDateTime expiryTime) { this.expiryTime = expiryTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }
}

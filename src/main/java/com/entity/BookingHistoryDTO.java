package com.entity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

/**
 * DTO for displaying booking history in user profile
 * Aggregates data from invoices, showtimes, movies, cinema_halls, and
 * ticket_details
 */
public class BookingHistoryDTO {
    // Invoice fields
    private int invoiceId;
    private LocalDateTime bookingTime;
    private String status;
    private BigDecimal totalAmount;
    private String ticketCode;

    // Movie fields
    private String movieTitle;
    private String posterUrl;

    // Showtime fields
    private LocalDate showDate;
    private LocalTime startTime;
    private LocalTime endTime;

    // Cinema hall fields
    private String hallName;

    // Seat details
    private String seatCodes; // Comma-separated seat codes (e.g., "A1, A2, B3")

    // Constructors
    public BookingHistoryDTO() {
    }

    public BookingHistoryDTO(int invoiceId, LocalDateTime bookingTime, String status,
            BigDecimal totalAmount, String ticketCode, String movieTitle,
            String posterUrl, LocalDate showDate, LocalTime startTime,
            LocalTime endTime, String hallName, String seatCodes) {
        this.invoiceId = invoiceId;
        this.bookingTime = bookingTime;
        this.status = status;
        this.totalAmount = totalAmount;
        this.ticketCode = ticketCode;
        this.movieTitle = movieTitle;
        this.posterUrl = posterUrl;
        this.showDate = showDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.hallName = hallName;
        this.seatCodes = seatCodes;
    }

    // Getters and Setters
    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public LocalDateTime getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(LocalDateTime bookingTime) {
        this.bookingTime = bookingTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getTicketCode() {
        return ticketCode;
    }

    public void setTicketCode(String ticketCode) {
        this.ticketCode = ticketCode;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }

    public LocalDate getShowDate() {
        return showDate;
    }

    public void setShowDate(LocalDate showDate) {
        this.showDate = showDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public String getHallName() {
        return hallName;
    }

    public void setHallName(String hallName) {
        this.hallName = hallName;
    }

    public String getSeatCodes() {
        return seatCodes;
    }

    public void setSeatCodes(String seatCodes) {
        this.seatCodes = seatCodes;
    }
}

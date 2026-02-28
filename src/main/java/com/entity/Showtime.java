package com.entity;

import java.time.LocalDate;

public class Showtime {

    private int showtimeId;
    private int movieId;
    private int hallId;
    private LocalDate showDate;
    private int slotId;

    public Showtime() {
    }
    //Dùng để insert dữ liệu mới không thêm ID
    public Showtime(int movieId, int hallId, LocalDate showDate, int slotId) {
        this.showtimeId = showtimeId;
        this.movieId = movieId;
        this.hallId = hallId;
        this.showDate = showDate;
        this.slotId = slotId;
    }
    //Dùng để truy vấn sql
    public Showtime(int showtimeId, int movieId, int hallId, LocalDate showDate, int slotId) {
        this.showtimeId = showtimeId;
        this.movieId = movieId;
        this.hallId = hallId;
        this.showDate = showDate;
        this.slotId = slotId;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getHallId() {
        return hallId;
    }

    public void setHallId(int hallId) {
        this.hallId = hallId;
    }

    public LocalDate getShowDate() {
        return showDate;
    }

    public void setShowDate(LocalDate showDate) {
        this.showDate = showDate;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }
}

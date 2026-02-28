package com.entity;

import java.time.LocalDate;
import java.time.LocalTime;

public class MovieDetailDTO {

    private int showtimeId;
    private String movieTitle;
    private String slotName;
    private LocalDate showDate;      // ✅ THÊM
    private LocalTime startTime;
    private LocalTime endTime;
    private String hallName;
    private String genres;

    public MovieDetailDTO(int showtimeId,
                          String movieTitle,
                          String slotName,
                          LocalDate showDate,
                          LocalTime startTime,
                          LocalTime endTime,
                          String hallName,
                          String genres) {
        this.showtimeId = showtimeId;
        this.movieTitle = movieTitle;
        this.slotName = slotName;
        this.showDate = showDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.hallName = hallName;
        this.genres = genres;
    }

    public LocalDate getShowDate() {
        return showDate;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public String getSlotName() {
        return slotName;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public String getHallName() {
        return hallName;
    }

    public String getGenres() {
        return genres;
    }

    
    
}

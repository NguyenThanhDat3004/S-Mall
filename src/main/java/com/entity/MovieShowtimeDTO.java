package com.entity;
import java.time.LocalDateTime;

public class MovieShowtimeDTO {

    private int movieId;           // id phim
    private String movieTitle;     // ten phim
    private String hallName;       // ten phong chieu
    private String genreName;      // the loai
    private String ageRating;      // do tuoi
    private String description;    // mo ta
    private LocalDateTime startTime; // gio chieu
    private int duration;          // thoi luong
    private String posterUrl;      // link anh poster

    public MovieShowtimeDTO() {
    }

    public MovieShowtimeDTO(int movieId, String movieTitle, String hallName,
                            String genreName, String ageRating,
                            String description, LocalDateTime startTime,
                            int duration, String posterUrl) {
        this.movieId = movieId;
        this.movieTitle = movieTitle;
        this.hallName = hallName;
        this.genreName = genreName;
        this.ageRating = ageRating;
        this.description = description;
        this.startTime = startTime;
        this.duration = duration;
        this.posterUrl = posterUrl;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public String getHallName() {
        return hallName;
    }

    public void setHallName(String hallName) {
        this.hallName = hallName;
    }

    public String getGenreName() {
        return genreName;
    }

    public void setGenreName(String genreName) {
        this.genreName = genreName;
    }

    public String getAgeRating() {
        return ageRating;
    }

    public void setAgeRating(String ageRating) {
        this.ageRating = ageRating;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }
}
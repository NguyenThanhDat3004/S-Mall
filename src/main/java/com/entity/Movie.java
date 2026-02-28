package com.entity;

import java.time.LocalDate;

public class Movie {
    private int movieId;
    private String title;
    private Integer duration;
    private String description;
    private LocalDate releaseDate;
    private String ageRating;
    private String posterUrl;

    public Movie() {
        this.ageRating = "P";
    }

    public Movie(int movieId, String title, Integer duration, String description, LocalDate releaseDate, String ageRating, String posterUrl) {
        this.movieId = movieId;
        this.title = title;
        this.duration = duration;
        this.description = description;
        this.releaseDate = releaseDate;
        this.ageRating = ageRating;
        this.posterUrl = posterUrl;
    }
    // construct them vao db
    public Movie(String title, Integer duration, String description, LocalDate releaseDate, String ageRating, String posterUrl) {
        this.title = title;
        this.duration = duration;
        this.description = description;
        this.releaseDate = releaseDate;
        this.ageRating = ageRating;
        this.posterUrl = posterUrl;
    }
    // Getters and Setters
    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDate getReleaseDate() { return releaseDate; }
    public void setReleaseDate(LocalDate releaseDate) { this.releaseDate = releaseDate; }

    public String getAgeRating() { return ageRating; }
    public void setAgeRating(String ageRating) { this.ageRating = ageRating; }

    public String getPosterUrl() { return posterUrl; }
    public void setPosterUrl(String posterUrl) { this.posterUrl = posterUrl; }
    
    
}

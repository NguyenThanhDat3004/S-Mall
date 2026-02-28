package com.entity;

// 5. MovieGenreRel Model
public class MovieGenreRel {
    private int movieId;
    private int genreId;

    public MovieGenreRel() {}

    public MovieGenreRel(int movieId, int genreId) {
        this.movieId = movieId;
        this.genreId = genreId;
    }

    // Getters and Setters
    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }

    public int getGenreId() { return genreId; }
    public void setGenreId(int genreId) { this.genreId = genreId; }
}


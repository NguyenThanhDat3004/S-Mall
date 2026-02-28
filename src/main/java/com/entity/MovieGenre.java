package com.entity;

public class MovieGenre {
    private int genreId;
    private String genreName;

    public MovieGenre() {}

    public MovieGenre(int genreId, String genreName) {
        this.genreId = genreId;
        this.genreName = genreName;
    }

    // Getters and Setters
    public int getGenreId() { return genreId; }
    public void setGenreId(int genreId) { this.genreId = genreId; }

    public String getGenreName() { return genreName; }
    public void setGenreName(String genreName) { this.genreName = genreName; }
}

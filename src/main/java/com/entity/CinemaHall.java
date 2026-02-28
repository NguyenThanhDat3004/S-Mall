package com.entity;

import java.time.LocalDate;

public class CinemaHall {
    private int hallId;
    private String hallName;
    private int total_rows;
    private int total_cols;
    private boolean status;
    private LocalDate createdAt;

    // Dung de lay du lieu
    public CinemaHall(int hallId, String hallName, int total_rows, int total_cols, boolean status,
            LocalDate createdAt) {
        this.hallId = hallId;
        this.hallName = hallName;
        this.total_rows = total_rows;
        this.total_cols = total_cols;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Dung cho tao moi
    public CinemaHall(String hallName, int total_rows, int total_cols, boolean status, LocalDate createdAt) {
        this.hallName = hallName;
        this.total_rows = total_rows;
        this.total_cols = total_cols;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getHallId() {
        return hallId;
    }

    public void setHallId(int hallId) {
        this.hallId = hallId;
    }

    public String getHallName() {
        return hallName;
    }

    public void setHallName(String hallName) {
        this.hallName = hallName;
    }

    public int getTotal_rows() {
        return total_rows;
    }

    public void setTotal_rows(int total_rows) {
        this.total_rows = total_rows;
    }

    public int getTotal_cols() {
        return total_cols;
    }

    public void setTotal_cols(int total_cols) {
        this.total_cols = total_cols;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }
}

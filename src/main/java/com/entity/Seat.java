package com.entity;

public class Seat {

    private int seatId;
    private int hallId;

    private String seatCode;

    private int rowIndex;
    private int columnIndex;

    private SeatType seatType;
    private boolean active;

    public Seat() {
    }

    public Seat(int seatId, int hallId, String seatCode,
                int rowIndex, int columnIndex,
                SeatType seatType, boolean active) {

        this.seatId = seatId;
        this.hallId = hallId;
        this.seatCode = seatCode;
        this.rowIndex = rowIndex;
        this.columnIndex = columnIndex;
        this.seatType = seatType;
        this.active = active;
    }

    // Getter & Setter
    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public int getHallId() {
        return hallId;
    }

    public void setHallId(int hallId) {
        this.hallId = hallId;
    }

    public String getSeatCode() {
        return seatCode;
    }

    public void setSeatCode(String seatCode) {
        this.seatCode = seatCode;
    }

    public int getRowIndex() {
        return rowIndex;
    }

    public void setRowIndex(int rowIndex) {
        this.rowIndex = rowIndex;
    }

    public int getColumnIndex() {
        return columnIndex;
    }

    public void setColumnIndex(int columnIndex) {
        this.columnIndex = columnIndex;
    }

    public SeatType getSeatType() {
        return seatType;
    }

    public void setSeatType(SeatType seatType) {
        this.seatType = seatType;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}

package com.entity;
        
    public class SeatSelectionDTO {
    private int seatId;
    private String seatCode;
    private int rowIndex;
    private int columnIndex;
    private int seatTypeId;   // 1: thường | 2: VIP | 3: couple
    private double price;
    private String status;    // AVAILABLE / BOOKED

    public SeatSelectionDTO(int seatId, String seatCode,
                            int rowIndex, int columnIndex,
                            int seatTypeId, double price,
                            String status) {
        this.seatId = seatId;
        this.seatCode = seatCode;
        this.rowIndex = rowIndex;
        this.columnIndex = columnIndex;
        this.seatTypeId = seatTypeId;
        this.price = price;
        this.status = status;
    }

    public int getSeatId() {
        return seatId;
    }

    public String getSeatCode() {
        return seatCode;
    }

    public int getRowIndex() {
        return rowIndex;
    }

    public int getColumnIndex() {
        return columnIndex;
    }

    public int getSeatTypeId() {
        return seatTypeId;
    }

    public double getPrice() {
        return price;
    }

    public String getStatus() {
        return status;
    }

    
}

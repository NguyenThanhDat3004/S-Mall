/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.entity;

/**
 *
 * @author nguye
 */
public class Movie_Ticket_ViewDTO {
    private int id;
    private String title;
    private int ticketsSold;
    private double revenue;
    private int rowNum;
    private int pageNumber;
    // cons

    public Movie_Ticket_ViewDTO(int id, String title, int ticketsSold, double revenue, int rowNum, int pageNumber) {
        this.id = id;
        this.title = title;
        this.ticketsSold = ticketsSold;
        this.revenue = revenue;
        this.rowNum = rowNum;
        this.pageNumber = pageNumber;
    }

    public Movie_Ticket_ViewDTO() {
    }
    // get set

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getTicketsSold() {
        return ticketsSold;
    }

    public void setTicketsSold(int ticketsSold) {
        this.ticketsSold = ticketsSold;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }

    public int getRowNum() {
        return rowNum;
    }

    public void setRowNum(int rowNum) {
        this.rowNum = rowNum;
    }

    public int getPageNumber() {
        return pageNumber;
    }

    public void setPageNumber(int pageNumber) {
        this.pageNumber = pageNumber;
    }
    
}

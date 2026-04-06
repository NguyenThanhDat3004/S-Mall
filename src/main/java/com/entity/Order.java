package com.entity;

import jakarta.persistence.CascadeType;
import java.util.List;
import jakarta.annotation.Generated;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "orders")
public class Order {
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private int id;
private double totalPrice;
private String status;

@ManyToOne
@JoinColumn(name = "account_id")
private Account account;

@OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
private List<OrderDetail> orderDetails;
// noi voi java spring biet rang account_id la khoa ngoai cua bang orders,
//  lien ket voi bang account, muon join thi join voi account_id, va account_id
//  se lien ket voi id cua bang account

public Order() {
    this.status = "PENDING";
}

public Order(int id, double totalPrice, String status) {
    this.id = id;
    this.totalPrice = totalPrice;
    this.status = status;
}
public int getId() {
    return id;
}
public double getTotalPrice() {
    return totalPrice;
}
public void setId(int id) {
    this.id = id;
}
public void setTotalPrice(double totalPrice) {
    this.totalPrice = totalPrice;
}
public String getStatus() {
    return status;
}
public void setStatus(String status) {
    this.status = status;
}
public List<OrderDetail> getOrderDetails() {
    return orderDetails;
}
public void setOrderDetails(List<OrderDetail> orderDetails) {
    this.orderDetails = orderDetails;
}
@Override
public String toString() {
    return "Order [id=" + id + ", totalPrice=" + totalPrice + "]";
}

}

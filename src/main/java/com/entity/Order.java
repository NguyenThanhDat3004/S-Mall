package com.entity;

import jakarta.annotation.Generated;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "orders")
public class Order {
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private int id;
private double totalPrice;
@ManyToOne
@JoinColumn(name = "account_id")
private Account account;
// noi voi java spring biet rang account_id la khoa ngoai cua bang orders,
//  lien ket voi bang account, muon join thi join voi account_id, va account_id
//  se lien ket voi id cua bang account

public Order() {
}
public Order(int id, double totalPrice) {
    this.id = id;
    this.totalPrice = totalPrice;
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
@Override
public String toString() {
    return "Order [id=" + id + ", totalPrice=" + totalPrice + "]";
}

}

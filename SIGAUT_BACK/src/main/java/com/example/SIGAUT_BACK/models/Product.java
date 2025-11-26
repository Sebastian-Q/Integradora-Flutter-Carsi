package com.example.SIGAUT_BACK.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 50, nullable = false)
    private String name;

    @Column(nullable = false)
    private Double price;

    @Column(length = 50, nullable = false)
    private String barCode;

    @Column(length = 50, nullable = false)
    private String description;

    @Column(nullable = false)
    private Double stock;

    @Column(nullable = false)
    private Double quantityMinima;

    @Column(nullable = false)
    private Double accountSale;

    @ManyToOne(optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private User user;

    public Product(String name, Double price, String barCode, String description, Double stock, Double quantityMinima, Double accountSale) {
        this.name = name;
        this.price = price;
        this.barCode = barCode;
        this.description = description;
        this.stock = stock;
        this.quantityMinima = quantityMinima;
        this.accountSale = accountSale;
    }
}

package com.example.SIGAUT_BACK.controller.product.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductRequest {
    private String name;
    private Double price;
    private String barCode;
    private String description;
    private Double stock;
    private Double quantityMinima;
    private Double accountSale;
    private Long idCategory;
    private Long idUser;

    public ProductRequest(String name, Double price, String barCode, String description, Double stock, Double quantityMinima, Double accountSale, Long idCategory, Long idUser) {
        this.name = name;
        this.price = price;
        this.barCode = barCode;
        this.description = description;
        this.stock = stock;
        this.quantityMinima = quantityMinima;
        this.accountSale = accountSale;
        this.idCategory = idCategory;
        this.idUser = idUser;
    }
}
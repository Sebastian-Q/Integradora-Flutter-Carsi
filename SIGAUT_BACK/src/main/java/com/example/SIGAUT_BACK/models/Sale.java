package com.example.SIGAUT_BACK.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;

@Entity
@Table(name = "sales")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Sale {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Double total;

    @Column(nullable = false)
    private Double amountSale;

    @Column(nullable = false)
    private Date dateSale;

    @Column(nullable = false)
    private String employee;

    @Column(nullable = false)
    private String payMethod;

    @ManyToMany
    @JoinTable(
            name = "sale_products",
            joinColumns = @JoinColumn(name = "sale_id"),
            inverseJoinColumns = @JoinColumn(name = "product_id")
    )
    private List<Product> productsList;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    public Sale(Double total, Double amountSale, Date dateSale, String employee, String payMethod) {
        this.total = total;
        this.amountSale = amountSale;
        this.dateSale = dateSale;
        this.employee = employee;
        this.payMethod = payMethod;
    }
}

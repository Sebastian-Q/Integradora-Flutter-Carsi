package com.example.SIGAUT_BACK.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@Builder(builderClassName = "Builder", toBuilder = true)
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 50, nullable = false)
    private String name;

    @Column(length = 50, nullable = false)
    private String paternalName;

    @Column(length = 50, nullable = false)
    private String maternalName;

    @Column(length = 50, nullable = false, unique = true)
    private String email;

    @Column(length = 50, nullable = false, unique = true)
    private String username;

    @Column(length = 150, nullable = false)
    private String password;

    @Column(length = 150)
    private String direction;

    @Column(length = 512)
    private String image_url;

    @Column(name = "device_token")
    private String deviceToken;

    @OneToMany(mappedBy = "user")
    @JsonIgnore
    private List<Category> categories;

    @OneToMany(mappedBy = "user")
    @JsonIgnore
    private List<Product> products;

    @OneToMany(mappedBy = "user")
    @JsonIgnore
    private List<Sale> sales;


    public User(String name, String paternalName, String maternalName, String email, String username, String password, String direction, String image_url, String deviceToken) {
        this.name = name;
        this.paternalName = paternalName;
        this.maternalName = maternalName;
        this.email = email;
        this.username = username;
        this.password = password;
        this.direction = direction;
        this.image_url = image_url;
        this.deviceToken = deviceToken;
    }
}

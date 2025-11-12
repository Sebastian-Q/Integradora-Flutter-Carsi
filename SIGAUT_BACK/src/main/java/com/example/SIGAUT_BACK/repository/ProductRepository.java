package com.example.SIGAUT_BACK.repository;

import com.example.SIGAUT_BACK.models.Product;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
    Optional<Product> findByName(String name);
    Optional<Product> findByBarCode(String barCode);
}

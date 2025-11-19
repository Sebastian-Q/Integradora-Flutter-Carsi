package com.example.SIGAUT_BACK.repository;

import com.example.SIGAUT_BACK.models.Sale;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SaleRepository extends JpaRepository<Sale, Long> {
    List<Sale> findByUserId(Long idUser);
}

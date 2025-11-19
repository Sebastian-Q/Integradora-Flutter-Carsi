package com.example.SIGAUT_BACK.repository;

import com.example.SIGAUT_BACK.models.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findByName(String name);
    Optional<Category> findByClave(String clave);
    List<Category> findByUserId(Long idUser);
}

package com.example.SIGAUT_BACK.controller.category.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CategoryRequest {
    private String name;
    private String clave;
    private String description;
    private Long idUser;

    public CategoryRequest(String name, String clave, String description, Long idUser) {
        this.name = name;
        this.clave = clave;
        this.description = description;
        this.idUser = idUser;
    }
}

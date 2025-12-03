package com.example.SIGAUT_BACK.models;

import lombok.Data;

@Data
public class Notification {
    private String title;
    private String body;
    private Long userId; // optional si quieres mandar por usuario
}

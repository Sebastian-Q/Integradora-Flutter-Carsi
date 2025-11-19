package com.example.SIGAUT_BACK.controller.auth.dto;

import com.example.SIGAUT_BACK.models.User;
import lombok.Value;

@Value
public class SignedDto {
    String token;
    String tokenType;
    User user;
}
package com.example.SIGAUT_BACK.controller.auth.dto;

import lombok.Value;

@Value
public class SignedDto {
    String token;
    String tokenType;
    SimpleUserDto user;
}
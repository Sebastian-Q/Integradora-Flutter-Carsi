package com.example.SIGAUT_BACK.security.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;

@Service
public class JwtProvider {

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.expiration}")
    private Long expiration;

    private static final String TOKEN_HEADER = "Authorization";
    private static final String TOKEN_TYPE = "Bearer ";

    public String generateToken(Authentication auth) {
        UserDetails user = (UserDetails) auth.getPrincipal();

        Date tokenCreateTime = new Date();
        Date tokenValidity = new Date(tokenCreateTime.getTime() + expiration * 1000);

        return Jwts.builder()
                .subject(user.getUsername())
                .issuedAt(tokenCreateTime)
                .expiration(tokenValidity)
                .signWith(getSignKey())
                .compact();
    }

    private SecretKey getSignKey() {
        byte[] keyBytes = Decoders.BASE64.decode(jwtSecret);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String resolveToken(HttpServletRequest req) {
        String bearerToken = req.getHeader(TOKEN_HEADER);
        if (bearerToken != null && bearerToken.startsWith(TOKEN_TYPE)) {
            return bearerToken.substring(TOKEN_TYPE.length());
        }
        return null;
    }

    public boolean validateToken(String token) {
    try{
        getClaims(token);
        return true;
    } catch (ExpiredJwtException e) {
        System.out.println("El token ha expirado: " + e.getMessage());
    } catch (JwtException e) {
        System.out.println("Token inválido: " + e.getMessage());
    }
    return false;
    }

    public Claims getClaims(String token) {
        try{
            return Jwts.parser()
                    .setSigningKey(getSignKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch(JwtException e) {
            throw new RuntimeException("Error al obtener los claims del token: " + e.getMessage());
        }
    }


}

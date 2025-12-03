package com.example.SIGAUT_BACK.services;

import com.example.SIGAUT_BACK.config.ApiResponse;
import com.example.SIGAUT_BACK.controller.auth.dto.SignedDto;
import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.repository.UserRepository;
import com.example.SIGAUT_BACK.security.jwt.JwtProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class AuthService {

    private final UserService service;
    private final AuthenticationManager manager;
    private final JwtProvider provider;
    private final UserRepository userRepository;

    public AuthService(UserService service, AuthenticationManager manager, JwtProvider provider, UserRepository userRepository) {
        this.service = service;
        this.manager = manager;
        this.provider = provider;
        this.userRepository = userRepository;
    }

    @Transactional
    public ResponseEntity<ApiResponse> signIn(String username, String password, String deviceToken) {
        try {
            Optional<User> foundUser = service.findByUsername(username);
            if(foundUser.isEmpty()) {
                return new ResponseEntity<>(
                        new ApiResponse(HttpStatus.NOT_FOUND, true, "Usuario no encontrado"),
                        HttpStatus.NOT_FOUND
                );
            }

            User user = foundUser.get();
            Authentication auth = manager.authenticate(
                    new UsernamePasswordAuthenticationToken(username, password)
            );
            SecurityContextHolder.getContext().setAuthentication(auth);

            // Guardar token FCM (NO VALIDAR)
            if (deviceToken != null && !deviceToken.isBlank()) {
                user.setDeviceToken(deviceToken);
                userRepository.save(user);
            }

            String token = provider.generateToken(auth);
            SignedDto signedDto = new SignedDto(token, "Bearer", user);

            return new ResponseEntity<>(new ApiResponse(signedDto, HttpStatus.OK), HttpStatus.OK);

        } catch (BadCredentialsException e) {
            System.out.println("ERROR 1: " + e.getMessage());
            return new ResponseEntity<>(
                    new ApiResponse(HttpStatus.UNAUTHORIZED, true, "Credenciales inválidas"),
                    HttpStatus.UNAUTHORIZED
            );
        } catch (DisabledException e) {
            System.out.println("ERROR 2: " + e.getMessage());
            return new ResponseEntity<>(
                    new ApiResponse(HttpStatus.UNAUTHORIZED, true, "Usuario deshabilitado"),
                    HttpStatus.UNAUTHORIZED
            );
        } catch (Exception e) {
            System.out.println("ERROR 3: " + e.getMessage());
            return new ResponseEntity<>(
                    new ApiResponse(HttpStatus.INTERNAL_SERVER_ERROR, true, "Error interno del servidor"),
                    HttpStatus.INTERNAL_SERVER_ERROR
            );
        }
    }

}

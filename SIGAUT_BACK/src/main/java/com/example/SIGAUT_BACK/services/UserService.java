package com.example.SIGAUT_BACK.services;

import com.example.SIGAUT_BACK.controller.auth.dto.SignedDto;
import com.example.SIGAUT_BACK.security.jwt.JwtProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.SIGAUT_BACK.config.ApiResponse;
import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.repository.UserRepository;

import java.util.Optional;


@Service
@Transactional
public class UserService {
    private static final String EMAIL_EXISTS_MESSAGE = "El correo electrónico ya está registrado";
    private static final String USER_EXISTS_MESSAGE = "El usuario ya está registrado";
    private static final String USER_NOT_FOUND_MESSAGE = "Usuario no encontrado";

    private final UserRepository userRepository;
    private final PasswordEncoder encoder;
    private final AuthenticationManager manager;
    private final JwtProvider provider;

    @Autowired
    public UserService(UserRepository userRepository, PasswordEncoder encoder, AuthenticationManager manager, JwtProvider provider) {
        this.userRepository = userRepository;
        this.encoder = encoder;
        this.manager = manager;
        this.provider = provider;
    }

    @Transactional(readOnly = true)
    public ResponseEntity<ApiResponse> getAll() {
        return new ResponseEntity<>(new ApiResponse(userRepository.findAll(), HttpStatus.OK), HttpStatus.OK);
    }

    @Transactional(readOnly = true)
    public ResponseEntity<ApiResponse> getUserById(Long id) {
        return userRepository.findById(id)
                .map(user -> new ResponseEntity<>(new ApiResponse(user, HttpStatus.OK), HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(new ApiResponse(USER_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST));
    }

    @Transactional(readOnly = true)
    public ResponseEntity<ApiResponse> getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .map(user -> new ResponseEntity<>(new ApiResponse(user, HttpStatus.OK), HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(new ApiResponse(USER_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST));
    }

    @Transactional(readOnly = true)
    public ResponseEntity<ApiResponse> getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .map(user -> new ResponseEntity<>(new ApiResponse(user, HttpStatus.OK), HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(new ApiResponse(USER_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST));
    }

    @Transactional(readOnly = true)
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Transactional
    public ResponseEntity<ApiResponse> createUser(User user) {
        try {
            if (userRepository.findByEmail(user.getEmail()).isPresent()) {
                return new ResponseEntity<>(new ApiResponse(EMAIL_EXISTS_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
            }
            if (userRepository.findByUsername(user.getUsername()).isPresent()) {
                return new ResponseEntity<>(new ApiResponse(USER_EXISTS_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
            }

            String password = user.getPassword();
            user.setPassword(encoder.encode(user.getPassword()));
            userRepository.save(user);

            Authentication auth = manager.authenticate(
                    new UsernamePasswordAuthenticationToken(user.getUsername(), password)
            );
            SecurityContextHolder.getContext().setAuthentication(auth);
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

    @Transactional
    public ResponseEntity<ApiResponse> updateUserById(User updatedUser) {
        return userRepository.findById(updatedUser.getId())
                .map(existingUser -> {
                    // Actualizar campos básicos
                    if (updatedUser.getName() != null) existingUser.setName(updatedUser.getName());
                    if (updatedUser.getPaternalName() != null) existingUser.setPaternalName(updatedUser.getPaternalName());
                    if (updatedUser.getMaternalName() != null) existingUser.setMaternalName(updatedUser.getMaternalName());
                    if (updatedUser.getPassword() != null) existingUser.setPassword(updatedUser.getPassword());
                    if (updatedUser.getDirection() != null) existingUser.setDirection(updatedUser.getDirection());
                    // Actualizar username con validación
                    if (!updateUserUsernameIfValid(updatedUser, existingUser)) {
                        return new ResponseEntity<>(
                                new ApiResponse(USER_EXISTS_MESSAGE, HttpStatus.BAD_REQUEST),
                                HttpStatus.BAD_REQUEST);
                    }
                    // Actualizar email con validación
                    if (!updateUserEmailIfValid(updatedUser, existingUser)) {
                        return new ResponseEntity<>(
                                new ApiResponse(EMAIL_EXISTS_MESSAGE, HttpStatus.BAD_REQUEST),
                                HttpStatus.BAD_REQUEST);
                    }

                    User savedUser = userRepository.save(existingUser);
                    return new ResponseEntity<>(new ApiResponse(savedUser, HttpStatus.OK), HttpStatus.OK);
                })
                .orElseGet(() -> new ResponseEntity<>(
                        new ApiResponse(USER_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST),
                        HttpStatus.BAD_REQUEST));
    }

    @Transactional
    public ResponseEntity<ApiResponse> deleteUserById(Long id) {
        if (!userRepository.existsById(id)) {
            return new ResponseEntity<>(new ApiResponse(USER_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
        }
        userRepository.deleteById(id);
        return new ResponseEntity<>(new ApiResponse("Usuario eliminada correctamente", HttpStatus.OK), HttpStatus.OK);
    }

    @Transactional
    public void updateProfilePicture(Long userId, String imgaeUrl) {
        userRepository.findById(userId).ifPresent(user -> {
            user.setImage_url(imgaeUrl);
            userRepository.save(user);
        });
    }

    private boolean updateUserEmailIfValid(User updatedUser, User existingUser) {
        if (updatedUser.getEmail() != null && !updatedUser.getEmail().isEmpty()
                && !updatedUser.getEmail().equals(existingUser.getEmail())) {
            if (userRepository.findByEmail(updatedUser.getEmail()).isPresent()) {
                return false;
            }
            existingUser.setEmail(updatedUser.getEmail());
        }
        return true;
    }

    private boolean updateUserUsernameIfValid(User updatedUser, User existingUser) {
        if (updatedUser.getUsername() != null && !updatedUser.getUsername().isEmpty()
                && !updatedUser.getUsername().equals(existingUser.getUsername())) {
            if (userRepository.findByUsername(updatedUser.getUsername()).isPresent()) {
                return false;
            }
            existingUser.setUsername(updatedUser.getUsername());
        }
        return true;
    }
}

package com.example.SIGAUT_BACK.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.SIGAUT_BACK.config.ApiResponse;
import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.repository.UserRepository;


@Service
@Transactional
public class UserService {
    private static final String EMAIL_EXISTS_MESSAGE = "El correo electrónico ya está registrado";
    private static final String USER_EXISTS_MESSAGE = "El usuario ya está registrado";
    private static final String USER_NOT_FOUND_MESSAGE = "Usuario no encontrado";

    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
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

    @Transactional
    public ResponseEntity<ApiResponse> createUser(User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            return new ResponseEntity<>(new ApiResponse(EMAIL_EXISTS_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
        }
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            return new ResponseEntity<>(new ApiResponse(USER_EXISTS_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
        }
        //user.setPassword(passwordEncoder.encode(user.getPassword()));;
        User savedUser = userRepository.save(user);
        return new ResponseEntity<>(new ApiResponse(savedUser, HttpStatus.OK), HttpStatus.OK);
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

package com.example.SIGAUT_BACK.controller.user;

import com.example.SIGAUT_BACK.services.FirebaseStorageService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.SIGAUT_BACK.config.ApiResponse;
import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.services.UserService;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = {"*"})
public class UserController {
    private final UserService userService;
    private final FirebaseStorageService firebaseStorageService;

    public UserController(UserService userService, FirebaseStorageService firebaseStorageService) {
        this.userService = userService;
        this.firebaseStorageService = firebaseStorageService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse> getAll() {
        return userService.getAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse> getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    @GetMapping("/{username}")
    public ResponseEntity<ApiResponse> getUserByUsername(@PathVariable String username) {
        return userService.getUserByUsername(username);
    }

    @GetMapping("/{email}")
    public ResponseEntity<ApiResponse> getUserByEmail(@PathVariable String email) {
        return userService.getUserByEmail(email);
    }

    @PostMapping
    public ResponseEntity<ApiResponse> createUser(@RequestBody User user) {
        return userService.createUser(user);
    }

    @PostMapping("/{id}/profile-picture")
    public ResponseEntity<ApiResponse> uploadProfilePicture(@PathVariable Long id, @RequestParam("file") MultipartFile file) {
        try {
            String fileName = UUID.randomUUID().toString() + "-" + file.getOriginalFilename();
            String imageUrl = firebaseStorageService.uploadFile(file.getBytes(), fileName, file.getContentType());
            userService.updateProfilePicture(id, imageUrl);
            return ResponseEntity.ok(new ApiResponse(imageUrl, HttpStatus.OK));
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse("Error al subir la imagen", HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @PutMapping
    public ResponseEntity<ApiResponse> updateUserById(@RequestBody User updatedUser) {
        return userService.updateUserById(updatedUser);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse> deleteUserById(@PathVariable Long id) {
        return userService.deleteUserById(id);
    }
}
package com.example.SIGAUT_BACK.controller.notification;

import com.example.SIGAUT_BACK.models.Notification;
import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.repository.UserRepository;
import com.example.SIGAUT_BACK.services.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/notifications")
@CrossOrigin(origins = "*")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/send/{userId}")
    public ResponseEntity<?> send(@PathVariable Long userId, @RequestBody Notification req) {
        User user = userRepository.findById(userId)
                .orElse(null);

        if (user == null) {
            return ResponseEntity.status(404).body("Usuario no encontrado");
        }

        if (user.getDeviceToken() == null) {
            return ResponseEntity.status(400).body("El usuario no tiene deviceToken registrado");
        }

        try {
            String response = notificationService.sendPushNotification(
                    user.getDeviceToken(),
                    req.getTitle(),
                    req.getBody()
            );

            return ResponseEntity.ok("Notificación enviada con ID: " + response);

        } catch (Exception e) {
            return ResponseEntity.status(500).body("Error enviando notificación: " + e.getMessage());
        }
    }
}

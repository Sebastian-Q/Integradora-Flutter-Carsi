package com.example.SIGAUT_BACK.config;

import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

@Configuration
@RequiredArgsConstructor
@Order(1)
public class InitialConfig implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder encoder;

    @Override
    public void run(String... args) throws Exception {
        getOrSaveUser(
                User.builder()
                        .name("admin")
                        .paternalName("paternal")
                        .maternalName("maternal")
                        .email("admin@example.com")
                        .username("admin")
                        .password(encoder.encode("admin123"))
                        .direction("Admin Address")
                        .build()
        );
    }

    @Transactional
    public User getOrSaveUser(User user) {
        return userRepository.findByUsername(user.getUsername())
                .orElseGet(() -> userRepository.saveAndFlush(user));
    }
}

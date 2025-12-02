package com.example.SIGAUT_BACK.security.entity;

import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.services.UserService;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class UserDetailsServiceImpl implements UserDetailsService {

    @Lazy
    private final UserService service;

    public UserDetailsServiceImpl(@Lazy UserService service) {
        this.service = service;
    }

    @Override
    public UserDetails loadUserByUsername(String usuario) throws UsernameNotFoundException {
        Optional<User> foundUser = service.findByUsername(usuario);
        if(foundUser.isPresent()) {
            return UserDetailsImpl.build(foundUser.get());
        }
        throw new UsernameNotFoundException("Usuario No Encontrado");
    }
}

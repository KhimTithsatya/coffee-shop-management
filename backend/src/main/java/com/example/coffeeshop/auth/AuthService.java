package com.example.coffeeshop.auth;
import org.springframework.security.crypto.password.PasswordEncoder; import org.springframework.stereotype.Service;
@Service public class AuthService {
 private final UserRepository users; private final PasswordEncoder encoder; private final JwtService jwt;
 public AuthService(UserRepository users,PasswordEncoder encoder,JwtService jwt){this.users=users;this.encoder=encoder;this.jwt=jwt;}
 public AuthResponse register(RegisterRequest request){String email=request.email().trim().toLowerCase();if(users.existsByEmailIgnoreCase(email))throw new IllegalArgumentException("An account with this email already exists.");User user=users.save(new User(request.name().trim(),email,encoder.encode(request.password())));return response(user);}
 public AuthResponse login(AuthRequest request){User user=users.findByEmailIgnoreCase(request.email().trim()).orElseThrow(()->new IllegalArgumentException("Invalid email or password."));if(!encoder.matches(request.password(),user.getPasswordHash()))throw new IllegalArgumentException("Invalid email or password.");return response(user);}
 public User getUser(String email){return users.findByEmailIgnoreCase(email).orElseThrow(()->new IllegalArgumentException("User not found."));}
 private AuthResponse response(User u){return new AuthResponse(jwt.generateToken(u),"Bearer",u.getId(),u.getName(),u.getEmail(),u.getRole());}
}
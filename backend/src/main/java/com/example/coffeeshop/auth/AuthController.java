package com.example.coffeeshop.auth;
import jakarta.validation.Valid; import org.springframework.http.HttpStatus; import org.springframework.security.core.Authentication; import org.springframework.web.bind.annotation.*; import org.springframework.web.server.ResponseStatusException;
@RestController @RequestMapping("/api/auth")
public class AuthController {
 private final AuthService service; public AuthController(AuthService service){this.service=service;}
 @PostMapping("/register") @ResponseStatus(HttpStatus.CREATED) public AuthResponse register(@Valid @RequestBody RegisterRequest request){try{return service.register(request);}catch(IllegalArgumentException ex){throw new ResponseStatusException(HttpStatus.BAD_REQUEST,ex.getMessage());}}
 @PostMapping("/login") public AuthResponse login(@Valid @RequestBody AuthRequest request){try{return service.login(request);}catch(IllegalArgumentException ex){throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,"Invalid email or password.");}}
 @GetMapping("/me") public UserProfile me(Authentication auth){if(auth==null)throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);User u=service.getUser(auth.getName());return new UserProfile(u.getId(),u.getName(),u.getEmail(),u.getRole());}
 public record UserProfile(Long id,String name,String email,String role){}
}
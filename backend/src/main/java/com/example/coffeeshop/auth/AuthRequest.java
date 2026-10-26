package com.example.coffeeshop.auth;
import jakarta.validation.constraints.*;
public record AuthRequest(@NotBlank @Email String email,@NotBlank String password) {}
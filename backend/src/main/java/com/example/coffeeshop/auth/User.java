package com.example.coffeeshop.auth;
import jakarta.persistence.*;
import java.time.Instant;
@Entity @Table(name="app_users", uniqueConstraints=@UniqueConstraint(columnNames="email"))
public class User {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private Long id;
 @Column(nullable=false,length=100) private String name;
 @Column(nullable=false,unique=true,length=190) private String email;
 @Column(nullable=false) private String passwordHash;
 @Column(nullable=false,length=30) private String role="USER";
 @Column(nullable=false) private Instant createdAt=Instant.now();
 public User() {}
 public User(String name,String email,String passwordHash){this.name=name;this.email=email;this.passwordHash=passwordHash;this.role="USER";this.createdAt=Instant.now();}
 public Long getId(){return id;} public String getName(){return name;} public String getEmail(){return email;} public String getPasswordHash(){return passwordHash;} public String getRole(){return role;} public Instant getCreatedAt(){return createdAt;}
}
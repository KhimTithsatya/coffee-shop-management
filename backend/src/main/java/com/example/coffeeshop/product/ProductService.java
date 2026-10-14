package com.example.coffeeshop.product;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class ProductService {
    private final ProductRepository repository;

    public ProductService(ProductRepository repository) {
        this.repository = repository;
    }

    public List<Product> getProducts(boolean includeInactive) {
        return includeInactive
                ? repository.findAll()
                : repository.findByActiveTrueOrderByNameAsc();
    }

    public Product create(Product product) {
        product.setId(null);
        product.setActive(true);
        return repository.save(product);
    }

    public Product update(Long id, Product input) {
        Product existing = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found"));
        existing.setName(input.getName());
        existing.setCategory(input.getCategory());
        existing.setPrice(input.getPrice());
        return repository.save(existing);
    }

    public void deactivate(Long id) {
        Product existing = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found"));
        existing.setActive(false);
        repository.save(existing);
    }
}

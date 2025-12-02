package com.example.SIGAUT_BACK.controller.product;

import com.example.SIGAUT_BACK.config.ApiResponse;
import com.example.SIGAUT_BACK.controller.product.dto.ProductRequest;
import com.example.SIGAUT_BACK.controller.product.dto.SearchProduct;
import com.example.SIGAUT_BACK.models.Product;
import com.example.SIGAUT_BACK.services.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = {"*"})
public class ProductController {
    private final ProductService productService;

    @Autowired
    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse> getAllProducts(@RequestHeader("user") int idUser) {
        return productService.getAllProducts(idUser);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse> getProductsById (@PathVariable Long id) {
        return productService.getProductById (id);
    }

    @PostMapping("/barcode")
    public ResponseEntity<ApiResponse> getProductsByBarcode (@RequestBody SearchProduct searchProduct) {
        return productService.getProductByBarcode(searchProduct);
    }

    @PostMapping
    public ResponseEntity<ApiResponse> createProduct(@RequestBody ProductRequest request) {
        return productService.createProduct(request);
    }

    @PutMapping
    public ResponseEntity<ApiResponse> updateProduct(@RequestBody Product product) {
        return productService.updateProduct(product);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse> deleteProduct(@PathVariable Long id) {
        return productService.deleteProduct(id);
    }
}

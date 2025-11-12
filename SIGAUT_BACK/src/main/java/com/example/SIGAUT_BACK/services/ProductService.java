package com.example.SIGAUT_BACK.services;

import com.example.SIGAUT_BACK.config.ApiResponse;
import com.example.SIGAUT_BACK.controller.product.dto.ProductRequest;
import com.example.SIGAUT_BACK.models.Category;
import com.example.SIGAUT_BACK.models.Product;
import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.repository.CategoryRepository;
import com.example.SIGAUT_BACK.repository.ProductRepository;
import com.example.SIGAUT_BACK.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class ProductService {
    private static final String PRODUCT_NOT_FOUND_MESSAGE = "Producto no encontrado";
    private static final String BARCODE_EXISTS_MESSAGE = "El código de barras ya está registrado";

    private static final String CATEGORY_NOT_FOUND_MESSAGE = "Categoria no encontrado";

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;

    public ProductService(ProductRepository productRepository, CategoryRepository categoryRepository, UserRepository userRepository) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public ResponseEntity<ApiResponse> getAllProducts() {
        return new ResponseEntity<>(new ApiResponse(productRepository.findAll(), HttpStatus.OK), HttpStatus.OK);
    }

    @Transactional(readOnly = true)
    public ResponseEntity<ApiResponse> getProductById(Long id) {
        return productRepository.findById(id)
                .map(product -> new ResponseEntity<>(new ApiResponse(product, HttpStatus.OK), HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(new ApiResponse(PRODUCT_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST));
    }

    @Transactional(readOnly = true)
    public ResponseEntity<ApiResponse> getProductByBarcode(String barcode) {
        return productRepository.findByBarCode(barcode)
                .map(category -> new ResponseEntity<>(new ApiResponse(category, HttpStatus.OK), HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(new ApiResponse(PRODUCT_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST));
    }

    @Transactional
    public ResponseEntity<ApiResponse> createProduct(ProductRequest request) {
        User currentUser = userRepository.findById(request.getIdUser()).orElseThrow();
        // Validar categoría
        if (request.getIdCategory() == null) {
            return new ResponseEntity<>(new ApiResponse(CATEGORY_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
        }

        Optional<Category> categoryOpt = categoryRepository.findById(request.getIdCategory());
        if (categoryOpt.isEmpty()) {
            return new ResponseEntity<>(new ApiResponse(CATEGORY_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
        }

        // Validar código de barras único
        if (productRepository.findByBarCode(request.getBarCode()).isPresent()) {
            return new ResponseEntity<>(new ApiResponse(BARCODE_EXISTS_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
        }

        Product product = new Product(
                request.getName(),
                request.getPrice(),
                request.getBarCode(),
                request.getDescription(),
                request.getStock(),
                request.getQuantityMinima(),
                request.getAccountSale()
        );

        product.setCategory(categoryOpt.get());
        product.setUser(currentUser);
        Product savedProduct = productRepository.save(product);
        return new ResponseEntity<>(new ApiResponse(savedProduct, HttpStatus.OK), HttpStatus.OK);
    }

    @Transactional
    public ResponseEntity<ApiResponse> updateProduct(Product updatedProduct) {
        return productRepository.findById(updatedProduct.getId())
                .map(existingProduct -> {
                    if (updatedProduct.getName() != null) existingProduct.setName(updatedProduct.getName());
                    if (updatedProduct.getDescription() != null) existingProduct.setDescription(updatedProduct.getDescription());
                    if (updatedProduct.getPrice() != null) existingProduct.setPrice(updatedProduct.getPrice());
                    if (updatedProduct.getStock() != null) existingProduct.setStock(updatedProduct.getStock());
                    if (updatedProduct.getQuantityMinima() != null) existingProduct.setQuantityMinima(updatedProduct.getQuantityMinima());
                    if (updatedProduct.getAccountSale() != null) existingProduct.setAccountSale(updatedProduct.getAccountSale());

                    // Validar cambio de código de barras
                    if (updatedProduct.getBarCode() != null && !updatedProduct.getBarCode().equals(existingProduct.getBarCode())) {
                        if (productRepository.findByBarCode(updatedProduct.getBarCode()).isPresent()) {
                            return new ResponseEntity<>(new ApiResponse(BARCODE_EXISTS_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
                        }
                        existingProduct.setBarCode(updatedProduct.getBarCode());
                    }

                    // Validar categoría (si se manda una nueva)
                    if (updatedProduct.getCategory() != null && updatedProduct.getCategory().getId() != null) {
                        Optional<Category> categoryOpt = categoryRepository.findById(updatedProduct.getCategory().getId());
                        if (categoryOpt.isEmpty()) {
                            return new ResponseEntity<>(new ApiResponse(CATEGORY_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
                        }
                        existingProduct.setCategory(categoryOpt.get());
                    }

                    Product saved = productRepository.save(existingProduct);
                    return new ResponseEntity<>(new ApiResponse(saved, HttpStatus.OK), HttpStatus.OK);
                })
                .orElseGet(() -> new ResponseEntity<>(
                        new ApiResponse(PRODUCT_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST),
                        HttpStatus.BAD_REQUEST
                ));
    }

    @Transactional
    public ResponseEntity<ApiResponse> deleteProduct(Long id) {
        if (!productRepository.existsById(id)) {
            return new ResponseEntity<>(new ApiResponse(PRODUCT_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
        }

        productRepository.deleteById(id);
        return new ResponseEntity<>(new ApiResponse("Producto eliminado correctamente", HttpStatus.OK), HttpStatus.OK);
    }
}

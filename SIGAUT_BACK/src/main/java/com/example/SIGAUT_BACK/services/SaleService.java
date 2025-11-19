package com.example.SIGAUT_BACK.services;

import com.example.SIGAUT_BACK.config.ApiResponse;
import com.example.SIGAUT_BACK.controller.sale.dto.SaleRequest;
import com.example.SIGAUT_BACK.models.Product;
import com.example.SIGAUT_BACK.models.Sale;
import com.example.SIGAUT_BACK.models.User;
import com.example.SIGAUT_BACK.repository.ProductRepository;
import com.example.SIGAUT_BACK.repository.SaleRepository;
import com.example.SIGAUT_BACK.repository.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class SaleService {
    private static final String SALE_NOT_FOUND_MESSAGE = "Venta no encontrada";

    private final SaleRepository saleRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    public SaleService(SaleRepository saleRepository, ProductRepository productRepository, UserRepository userRepository) {
        this.saleRepository = saleRepository;
        this.productRepository = productRepository;
        this.userRepository = userRepository;
    }

    public ResponseEntity<ApiResponse> getAllSales(int idUser) {
        List<Sale> sales = saleRepository.findByUserId((long) idUser);

        return new ResponseEntity<>(
                new ApiResponse(sales, HttpStatus.OK),
                HttpStatus.OK
        );
    }

    public ResponseEntity<ApiResponse> getSaleById(Long id) {
        return saleRepository.findById(id)
                .map(sale -> new ResponseEntity<>(new ApiResponse(sale, org.springframework.http.HttpStatus.OK), org.springframework.http.HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(new ApiResponse(SALE_NOT_FOUND_MESSAGE, org.springframework.http.HttpStatus.BAD_REQUEST), org.springframework.http.HttpStatus.BAD_REQUEST));
    }

    public ResponseEntity<ApiResponse> createSale(SaleRequest request) {
        User currentUser = userRepository.findById(request.getIdUser()).orElseThrow();
        // Validar lista de productos
        if (request.getProductsList() == null || request.getProductsList().isEmpty()) {
            return new ResponseEntity<>(
                    new ApiResponse("Debe incluir al menos un producto", HttpStatus.BAD_REQUEST),
                    HttpStatus.BAD_REQUEST
            );
        }

        // Validar stock disponible
        for (Product p : request.getProductsList()) {
            Optional<Product> productOpt = productRepository.findById(p.getId());
            if (productOpt.isEmpty()) {
                return new ResponseEntity<>(new ApiResponse("Producto con ID " + p.getId() + " no existe", HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
            }

            Product product = productOpt.get();
            if (product.getStock() < p.getAccountSale()) {
                return new ResponseEntity<>(new ApiResponse("Stock insuficiente para el producto " + product.getName(), HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
            }
        }

        // Actualizar stock
        for (Product p : request.getProductsList()) {
            Product product = productRepository.findById(p.getId()).get();
            product.setStock(product.getStock() - p.getAccountSale());
            productRepository.save(product);
        }

        // Establecer fecha actual si no se envía
        Sale sale = new Sale(
                request.getTotal(),
                request.getAmountSale(),
                new Date(),
                request.getEmployee(),
                request.getPayMethod()
        );
        sale.setProductsList(request.getProductsList());
        sale.setUser(currentUser);
        Sale savedSale = saleRepository.save(sale);
        return new ResponseEntity<>(new ApiResponse(savedSale, HttpStatus.OK), HttpStatus.OK);
    }

    public ResponseEntity<ApiResponse> deleteSale(Long id) {
        Optional<Sale> saleOpt = saleRepository.findById(id);
        if (saleOpt.isEmpty()) {
            return new ResponseEntity<>(new ApiResponse(SALE_NOT_FOUND_MESSAGE, HttpStatus.BAD_REQUEST), HttpStatus.BAD_REQUEST);
        }
        saleRepository.deleteById(id);
        return new ResponseEntity<>(new ApiResponse("Venta eliminada correctamente", HttpStatus.OK), HttpStatus.OK);
    }
}

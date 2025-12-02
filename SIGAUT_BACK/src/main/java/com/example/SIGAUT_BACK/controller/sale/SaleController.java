package com.example.SIGAUT_BACK.controller.sale;

import com.example.SIGAUT_BACK.config.ApiResponse;
import com.example.SIGAUT_BACK.controller.sale.dto.SaleRequest;
import com.example.SIGAUT_BACK.services.SaleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/sales")
@CrossOrigin(origins = "*")
public class SaleController {
    private final SaleService saleService;

    @Autowired
    public SaleController(SaleService saleService) {
        this.saleService = saleService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse> getAllSales(@RequestHeader("user") int idUser) {
        return saleService.getAllSales(idUser);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse> getSaleById(@PathVariable Long id) {
        return saleService.getSaleById(id);
    }

    @PostMapping
    public ResponseEntity<ApiResponse> createSale(@RequestBody SaleRequest request) {
        return saleService.createSale(request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse> deleteSale(@PathVariable Long id) {
        return saleService.deleteSale(id);
    }

}

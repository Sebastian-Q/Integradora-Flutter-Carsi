package com.example.SIGAUT_BACK.config;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.http.HttpStatus;

@Getter
@Setter
@NoArgsConstructor
public class ApiResponse {
    private Object data;
    private HttpStatus status;
    private boolean error;
    private String message;
    public ApiResponse(Object data, HttpStatus status) {
        this.data = data;
        this.status = status;
    }
    public ApiResponse(HttpStatus status, boolean error, String message) {
        this.status = status;
        this.error = error;
        this.message = message;
    }
}

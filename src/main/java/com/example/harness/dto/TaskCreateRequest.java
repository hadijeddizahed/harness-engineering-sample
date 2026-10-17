package com.example.harness.dto;

import jakarta.validation.constraints.NotBlank;

public record TaskCreateRequest(
        @NotBlank(message = "Title must not be blank")
        String title,
        String description
) {
}

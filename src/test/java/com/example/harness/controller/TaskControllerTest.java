package com.example.harness.controller;

import com.example.harness.dto.TaskCreateRequest;
import com.example.harness.dto.TaskResponse;
import com.example.harness.model.TaskStatus;
import com.example.harness.service.TaskService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.Instant;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(TaskController.class)
class TaskControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private TaskService taskService;

    @Test
    @DisplayName("POST /api/tasks should create a task and return HTTP 201 Created")
    void shouldCreateTask() throws Exception {
        TaskCreateRequest request = new TaskCreateRequest("Write Docs", "Write harness engineering documentation");
        TaskResponse response = new TaskResponse(1L, "Write Docs", "Write harness engineering documentation", TaskStatus.PENDING, Instant.now());

        when(taskService.createTask(any(TaskCreateRequest.class))).thenReturn(response);

        mockMvc.perform(post("/api/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.title").value("Write Docs"))
                .andExpect(jsonPath("$.status").value("PENDING"));
    }

    @Test
    @DisplayName("POST /api/tasks with blank title should return HTTP 400 Bad Request")
    void shouldRejectBlankTitle() throws Exception {
        TaskCreateRequest request = new TaskCreateRequest("", "Empty title");

        mockMvc.perform(post("/api/tasks")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("GET /api/tasks/{id} should return HTTP 200 when task exists")
    void shouldReturnTaskWhenExists() throws Exception {
        TaskResponse response = new TaskResponse(1L, "Write Docs", "Description", TaskStatus.PENDING, Instant.now());
        when(taskService.getTaskById(1L)).thenReturn(Optional.of(response));

        mockMvc.perform(get("/api/tasks/1")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.title").value("Write Docs"))
                .andExpect(jsonPath("$.status").value("PENDING"));
    }

    @Test
    @DisplayName("GET /api/tasks/{id} should return HTTP 404 when task not found")
    void shouldReturnNotFoundWhenMissing() throws Exception {
        when(taskService.getTaskById(999L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/tasks/999")
                        .accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }
}

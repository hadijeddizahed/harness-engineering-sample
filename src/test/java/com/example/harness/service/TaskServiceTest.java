package com.example.harness.service;

import com.example.harness.dto.TaskCreateRequest;
import com.example.harness.dto.TaskResponse;
import com.example.harness.model.Task;
import com.example.harness.model.TaskStatus;
import com.example.harness.repository.TaskRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TaskServiceTest {

    @Mock
    private TaskRepository taskRepository;

    private TaskService taskService;

    @BeforeEach
    void setUp() {
        taskService = new TaskService(taskRepository);
    }

    @Test
    @DisplayName("createTask should save task and return response DTO")
    void shouldCreateTask() {
        TaskCreateRequest request = new TaskCreateRequest("Task Title", "Task Desc");

        Task savedTask = new Task("Task Title", "Task Desc");
        savedTask.setId(10L);
        savedTask.setStatus(TaskStatus.PENDING);

        when(taskRepository.save(any(Task.class))).thenReturn(savedTask);

        TaskResponse response = taskService.createTask(request);

        assertThat(response).isNotNull();
        assertThat(response.id()).isEqualTo(10L);
        assertThat(response.title()).isEqualTo("Task Title");
        assertThat(response.status()).isEqualTo(TaskStatus.PENDING);
        verify(taskRepository).save(any(Task.class));
    }

    @Test
    @DisplayName("getTaskById should return TaskResponse when found")
    void shouldFindTaskById() {
        Task task = new Task("Found Task", "Desc");
        task.setId(5L);

        when(taskRepository.findById(5L)).thenReturn(Optional.of(task));

        Optional<TaskResponse> result = taskService.getTaskById(5L);

        assertThat(result).isPresent();
        assertThat(result.get().id()).isEqualTo(5L);
        assertThat(result.get().title()).isEqualTo("Found Task");
    }
}

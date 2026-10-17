package com.example.harness.service;

import com.example.harness.dto.TaskCreateRequest;
import com.example.harness.dto.TaskResponse;
import com.example.harness.model.Task;
import com.example.harness.repository.TaskRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional
public class TaskService {

    private final TaskRepository taskRepository;

    public TaskService(TaskRepository taskRepository) {
        this.taskRepository = taskRepository;
    }

    public TaskResponse createTask(TaskCreateRequest request) {
        Task task = new Task(request.title(), request.description());
        Task saved = taskRepository.save(task);
        return TaskResponse.fromEntity(saved);
    }

    @Transactional(readOnly = true)
    public Optional<TaskResponse> getTaskById(Long id) {
        return taskRepository.findById(id).map(TaskResponse::fromEntity);
    }
}

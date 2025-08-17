package com.dsantos.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "game_results")
public class GameResult {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "dungeon_input", columnDefinition = "TEXT")
    private String dungeonInput;

    @Column(name = "minimum_hp")
    private Integer minimumHp;

    @Column(name = "execution_time_ms")
    private Long executionTimeMs;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    public GameResult() {
        this.createdAt = LocalDateTime.now();
    }

    public GameResult(String dungeonInput, Integer minimumHp, Long executionTimeMs) {
        this();
        this.dungeonInput = dungeonInput;
        this.minimumHp = minimumHp;
        this.executionTimeMs = executionTimeMs;
    }

    // Getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDungeonInput() {
        return dungeonInput;
    }

    public void setDungeonInput(String dungeonInput) {
        this.dungeonInput = dungeonInput;
    }

    public Integer getMinimumHp() {
        return minimumHp;
    }

    public void setMinimumHp(Integer minimumHp) {
        this.minimumHp = minimumHp;
    }

    public Long getExecutionTimeMs() {
        return executionTimeMs;
    }

    public void setExecutionTimeMs(Long executionTimeMs) {
        this.executionTimeMs = executionTimeMs;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

package com.dsantos.repository;

import com.dsantos.model.GameResultEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface GameResultRepository extends JpaRepository<GameResultEntity, Long> {

    @Query("SELECT gr FROM GameResultEntity gr WHERE gr.createdAt >= :startTime ORDER BY gr.createdAt DESC")
    List<GameResultEntity> findRecentResults(LocalDateTime startTime);

    @Query("SELECT AVG(gr.executionTimeMs) FROM GameResultEntity gr WHERE gr.createdAt >= :startTime")
    Double getAverageExecutionTime(LocalDateTime startTime);

    @Query("SELECT COUNT(gr) FROM GameResultEntity gr WHERE gr.createdAt >= :startTime")
    Long countRecentExecutions(LocalDateTime startTime);
}

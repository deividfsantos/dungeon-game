package com.dsantos.controller.model;

import java.time.LocalDateTime;

public record DungeonResponse(
        Long id,
        String dungeonInput,
        Integer minimumHp,
        Long executionTimeMs,
        LocalDateTime createdAt
) {
}

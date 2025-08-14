package com.dsantos.controller;

import com.dsantos.model.GameResult;
import com.dsantos.service.DungeonGameService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/dungeon")
public class DungeonGameController {

    private final DungeonGameService dungeonGameService;

    @Autowired
    public DungeonGameController(DungeonGameService dungeonGameService) {
        this.dungeonGameService = dungeonGameService;
    }


    @PostMapping("/calculate")
    public ResponseEntity<GameResult> calculateMinimumHP(@Valid @RequestBody DungeonRequest request) {
        GameResult result = dungeonGameService.calculateAndSave(request.getDungeon());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/results")
    public ResponseEntity<List<GameResult>> getRecentResults(
            @RequestParam(defaultValue = "24") int hours) {
        List<GameResult> results = dungeonGameService.getRecentResults(hours);
        return ResponseEntity.ok(results);
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats(
            @RequestParam(defaultValue = "24") int hours) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("averageExecutionTimeMs", dungeonGameService.getAverageExecutionTime(hours));
        stats.put("totalExecutions", dungeonGameService.getExecutionCount(hours));
        stats.put("hoursRange", hours);
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> status = new HashMap<>();
        status.put("status", "UP");
        status.put("service", "Dungeon Game API");
        return ResponseEntity.ok(status);
    }

    public static class DungeonRequest {
        @NotNull(message = "Dungeon cannot be null")
        @Size(min = 1, message = "Dungeon must have at least one row")
        private int[][] dungeon;

        public int[][] getDungeon() {
            return dungeon;
        }

        public void setDungeon(int[][] dungeon) {
            this.dungeon = dungeon;
        }
    }
}

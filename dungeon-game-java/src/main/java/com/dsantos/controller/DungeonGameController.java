package com.dsantos.controller;

import com.dsantos.controller.model.DungeonRequest;
import com.dsantos.controller.model.DungeonResponse;
import com.dsantos.model.GameResultEntity;
import com.dsantos.service.DungeonGameService;
import jakarta.validation.Valid;
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
    public ResponseEntity<GameResultEntity> calculateMinimumHP(@Valid @RequestBody DungeonRequest request) {
        GameResultEntity result = dungeonGameService.calculateAndSave(request.getDungeon());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/results")
    public ResponseEntity<List<DungeonResponse>> getRecentResults(
            @RequestParam(defaultValue = "24") int hours) {
        List<GameResultEntity> results = dungeonGameService.getRecentResults(hours);
        List<DungeonResponse> responseList = results.stream()
                .map(result -> new DungeonResponse(
                        result.getId(),
                        result.getDungeonInput(),
                        result.getMinimumHp(),
                        result.getExecutionTimeMs(),
                        result.getCreatedAt()))
                .toList();
        return ResponseEntity.ok(responseList);
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
}

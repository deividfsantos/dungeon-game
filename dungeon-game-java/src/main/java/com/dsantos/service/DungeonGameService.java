package com.dsantos.service;

import com.dsantos.model.GameResultEntity;
import com.dsantos.repository.GameResultRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Service
public class DungeonGameService {

    private final DungeonGame dungeonGame;
    private final GameResultRepository gameResultRepository;

    public DungeonGameService(GameResultRepository gameResultRepository) {
        this.dungeonGame = new DungeonGame();
        this.gameResultRepository = gameResultRepository;
    }

    public GameResultEntity calculateAndSave(int[][] dungeon) {
        long startTime = System.currentTimeMillis();
        int minimumHp = dungeonGame.calculateMinimumHP(dungeon);
        long executionTime = System.currentTimeMillis() - startTime;
        String dungeonInput = serializeDungeon(dungeon);
        GameResultEntity result = new GameResultEntity(dungeonInput, minimumHp, executionTime);
        return gameResultRepository.save(result);
    }

    public List<GameResultEntity> getRecentResults(int hours) {
        LocalDateTime since = LocalDateTime.now().minusHours(hours);
        return gameResultRepository.findRecentResults(since);
    }

    public Double getAverageExecutionTime(int hours) {
        LocalDateTime since = LocalDateTime.now().minusHours(hours);
        return gameResultRepository.getAverageExecutionTime(since);
    }

    public Long getExecutionCount(int hours) {
        LocalDateTime since = LocalDateTime.now().minusHours(hours);
        return gameResultRepository.countRecentExecutions(since);
    }

    private String serializeDungeon(int[][] dungeon) {
        StringBuilder sb = new StringBuilder();
        sb.append("[");
        for (int i = 0; i < dungeon.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(Arrays.toString(dungeon[i]));
        }
        sb.append("]");
        return sb.toString();
    }
}

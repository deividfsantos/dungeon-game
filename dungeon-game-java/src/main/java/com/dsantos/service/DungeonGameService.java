package com.dsantos.service;

import com.dsantos.DungeonGame;
import com.dsantos.model.GameResult;
import com.dsantos.repository.GameResultRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Service
public class DungeonGameService {
    
    private final DungeonGame dungeonGame;
    private final GameResultRepository gameResultRepository;
    
    @Autowired
    public DungeonGameService(GameResultRepository gameResultRepository) {
        this.dungeonGame = new DungeonGame();
        this.gameResultRepository = gameResultRepository;
    }
    
    public GameResult calculateAndSave(int[][] dungeon) {
        long startTime = System.currentTimeMillis();
        
        int minimumHp = dungeonGame.calculateMinimumHP(dungeon);
        
        long executionTime = System.currentTimeMillis() - startTime;
        
        String dungeonInput = serializeDungeon(dungeon);
        
        GameResult result = new GameResult(dungeonInput, minimumHp, executionTime);
        
        return gameResultRepository.save(result);
    }
    
    public List<GameResult> getRecentResults(int hours) {
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

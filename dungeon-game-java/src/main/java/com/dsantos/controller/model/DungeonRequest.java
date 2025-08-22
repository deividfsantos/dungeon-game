package com.dsantos.controller.model;


import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class DungeonRequest {
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

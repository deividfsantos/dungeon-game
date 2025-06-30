package com.dsantos;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class DungeonGameTest {

    DungeonGame game = new DungeonGame();

    @Test
    void calculateMinimumHP7() {
        int[][] dungeon = {
                {-2, -3, 3},
                {-5, -10, 1},
                {10, 30, -5}};

        int minHp = game.calculateMinimumHP(dungeon);
        assertEquals(7, minHp);
    }

    @Test
    void calculateMinimumHP1() {
        int[][] dungeon = {{0}};

        int minHp = game.calculateMinimumHP(dungeon);
        assertEquals(1, minHp);
    }

    @Test
    void calculateMinimumHP6() {
        int[][] dungeon = {
                {-2, -3, 3},
                {-5, -10, 1}};

        int minHp = game.calculateMinimumHP(dungeon);
        assertEquals(6, minHp);
    }
}
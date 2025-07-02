const std = @import("std");

pub fn calculateMinimumHP(allocator: std.mem.Allocator, dungeon: [][]i32) !i32 {
    const m = dungeon.len;
    const n = dungeon[0].len;

    var dp = try allocator.alloc([]i32, m);
    defer allocator.free(dp);

    for (dp) |*row, i| {
        row.* = try allocator.alloc(i32, n);
        defer allocator.free(row.*);
    }

    dp[m - 1][n - 1] = std.math.max(1, 1 - dungeon[m - 1][n - 1]);

    var i: usize = m - 1;
    while (i > 0) : (i -= 1) {
        dp[i - 1][n - 1] = std.math.max(1, dp[i][n - 1] - dungeon[i - 1][n - 1]);
    }

    var j: usize = n - 1;
    while (j > 0) : (j -= 1) {
        dp[m - 1][j - 1] = std.math.max(1, dp[m - 1][j] - dungeon[m - 1][j - 1]);
    }

    i = m - 1;
    while (i > 0) : (i -= 1) {
        j = n - 1;
        while (j > 0) : (j -= 1) {
            const minHealthOnExit = std.math.min(dp[i][j - 1], dp[i - 1][j]);
            dp[i - 1][j - 1] = std.math.max(1, minHealthOnExit - dungeon[i - 1][j - 1]);
        }
    }

    return dp[0][0];
}

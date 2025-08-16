const std = @import("std");

pub fn calculateMinimumHP(allocator: std.mem.Allocator, dungeon: [][]i32) !i32 {
    const m = dungeon.len;
    const n = dungeon[0].len;

    var dp = try allocator.alloc([]i32, m);
    defer allocator.free(dp);

	var i: usize = 0;
    while (i < m) : (i += 1) {
        dp[i] = try allocator.alloc(i32, n);
        defer allocator.free(dp[i]);
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

test "calculateMinimumHP returns 7" {
    const allocator = std.testing.allocator;
    const dungeon = &[_][]i32{
        .[_]i32{ -2, -3, 3 },
        .[_]i32{ -5, -10, 1 },
        .[_]i32{ 10, 30, -5 },
    };
    try std.testing.expectEqual(@as(i32, 7), try calculateMinimumHP(allocator, dungeon));
}

test "calculateMinimumHP returns 1" {
    const allocator = std.testing.allocator;
    const dungeon = &[_][]i32{
        .[_]i32{ 0 },
    };
    try std.testing.expectEqual(@as(i32, 1), try calculateMinimumHP(allocator, dungeon));
}

test "calculateMinimumHP returns 6" {
    const allocator = std.testing.allocator;
    const dungeon = &[_][]i32{
        .[_]i32{ -2, -3, 3 },
        .[_]i32{ -5, -10, 1 },
    };
    try std.testing.expectEqual(@as(i32, 6), try calculateMinimumHP(allocator, dungeon));
}

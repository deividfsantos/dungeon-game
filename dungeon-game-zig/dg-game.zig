const std = @import("std");

pub fn calculateMinimumHP(allocator: std.mem.Allocator, dungeon: anytype) !i32 {
    const m = dungeon.len;
    const n = dungeon[0].len;

    var dp = try allocator.alloc([]i32, m);

    var k: usize = 0;
    while (k < m) : (k += 1) {
        dp[k] = try allocator.alloc(i32, n);
    }

    dp[m - 1][n - 1] = @max(1, 1 - dungeon[m - 1][n - 1]);

    var i: usize = m - 1;
    while (i > 0) : (i -= 1) {
        dp[i - 1][n - 1] = @max(1, dp[i][n - 1] - dungeon[i - 1][n - 1]);
    }

    var j: usize = n - 1;
    while (j > 0) : (j -= 1) {
        dp[m - 1][j - 1] = @max(1, dp[m - 1][j] - dungeon[m - 1][j - 1]);
    }

    i = m - 1;
    while (i > 0) : (i -= 1) {
        j = n - 1;
        while (j > 0) : (j -= 1) {
            const minHealthOnExit = @min(dp[i][j - 1], dp[i - 1][j]);
            dp[i - 1][j - 1] = @max(1, minHealthOnExit - dungeon[i - 1][j - 1]);
        }
    }

    const result = dp[0][0];

    k = 0;
    while (k < m) : (k += 1) {
        allocator.free(dp[k]);
    }
    allocator.free(dp);

    return result;
}

test "calculateMinimumHP returns 7" {
    const allocator = std.testing.allocator;

    const dungeon_data = [_][3]i32{
        [_]i32{ -2, -3, 3 },
        [_]i32{ -5, -10, 1 },
        [_]i32{ 10, 30, -5 },
    };

    try std.testing.expectEqual(@as(i32, 7), try calculateMinimumHP(allocator, dungeon_data));
}

test "calculateMinimumHP returns 1" {
    const allocator = std.testing.allocator;

    const dungeon_data = [_][1]i32{
        [_]i32{ 0 },
    };

    try std.testing.expectEqual(@as(i32, 1), try calculateMinimumHP(allocator, dungeon_data));
}

test "calculateMinimumHP returns 6" {
    const allocator = std.testing.allocator;

    const dungeon_data = [_][3]i32{
        [_]i32{ -2, -3, 3 },
        [_]i32{ -5, -10, 1 },
    };

    try std.testing.expectEqual(@as(i32, 6), try calculateMinimumHP(allocator, dungeon_data));
}

test "calculateMinimumHP returns 7 for 5x5 dungeon" {
    const allocator = std.testing.allocator;

    const dungeon_data = [_][5]i32{
        [_]i32{ -2, -3, 3, -1, 2 },
        [_]i32{ -5, -10, 1, -2, -3 },
        [_]i32{ 10, 30, -5, -10, 1 },
        [_]i32{ -3, -2, -1, -2, -3 },
        [_]i32{ 1, 2, 3, -4, -5 },
    };

    try std.testing.expectEqual(@as(i32, 7), try calculateMinimumHP(allocator, dungeon_data));
}

test "calculateMinimumHP returns 4 for 4x6 dungeon" {
    const allocator = std.testing.allocator;

    const dungeon_data = [_][6]i32{
        [_]i32{ -2, -3, 3, -1, 2, -2 },
        [_]i32{ -5, -10, 1, -2, -3, 4 },
        [_]i32{ 10, 30, -5, -10, 1, -1 },
        [_]i32{ -3, -2, -1, -2, -3, -4 },
    };

    try std.testing.expectEqual(@as(i32, 4), try calculateMinimumHP(allocator, dungeon_data));
}

const std = @import("std");

pub fn calculateMinimumHP(allocator: std.mem.Allocator, dungeon: anytype) !i32 {
    const m = dungeon.len;
    const n = dungeon[0].len;

    var dp = try allocator.alloc([]i32, m);
    defer allocator.free(dp);

    var k: usize = 0;
    while (k < m) : (k += 1) {
        dp[k] = try allocator.alloc(i32, n);
        defer allocator.free(dp[k]);
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

    return dp[0][0];
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

test "calculateMinimumHP returns 6 again" {
    const allocator = std.testing.allocator;

    const dungeon_data = [_][2]i32{
        [_]i32{ -2, -3, 3 }
    };

    try std.testing.expectEqual(@as(i32, 6), try calculateMinimumHP(allocator, dungeon_data));
}
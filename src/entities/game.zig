const std = @import("std");
pub const food = @import("food.zig");
pub const snake = @import("snake.zig");

pub const Game = struct {
    food: food.Food,
    snake: snake.Snake,

    pub fn init(allocator: std.mem.Allocator) !Game {
        return Game{
            .food = food.Food.init(),
            .snake = try snake.Snake.init(allocator),
        };
    }

    pub fn deinit(self: *Game) void {
        self.food.deinit();
        self.snake.deinit();
    }

    pub fn draw(self: Game) void {
        self.food.draw();
        self.snake.draw();
    }

    pub fn update(self: *Game) !void {
        try self.snake.update();
    }
};

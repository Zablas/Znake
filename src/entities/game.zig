const std = @import("std");
const rl = @import("raylib");
pub const food = @import("food.zig");
pub const snake = @import("snake.zig");

pub const Game = struct {
    food: food.Food,
    snake: snake.Snake,

    pub fn init(allocator: std.mem.Allocator) !Game {
        const init_snake = try snake.Snake.init(allocator);
        return Game{
            .food = food.Food.init(init_snake.deque),
            .snake = init_snake,
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
        self.checkSnakeCollisionWithFood();
    }

    pub fn checkSnakeCollisionWithFood(self: *Game) void {
        if (rl.math.vector2Equals(self.snake.deque.last.?.data, self.food.position) == 1) {
            self.food.position = food.Food.generateRandomPosition(self.snake.deque);
        }
    }
};

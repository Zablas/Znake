const std = @import("std");
const rl = @import("raylib");
const food = @import("food.zig");
const snake = @import("snake.zig");
const constants = @import("constants");
const utils = @import("utils");

const grid_params = constants.grid_params;

pub const Game = struct {
    food: food.Food,
    snake: snake.Snake,
    eat_sound: rl.Sound,
    wall_sound: rl.Sound,
    is_running: bool = true,
    score: i32 = 0,
    was_input_registered: bool = false,

    pub fn init(allocator: std.mem.Allocator) !Game {
        rl.initAudioDevice();

        const init_snake = try snake.Snake.init(allocator);
        return Game{
            .food = food.Food.init(init_snake.deque),
            .snake = init_snake,
            .eat_sound = rl.loadSound("assets/audio/eat.mp3"),
            .wall_sound = rl.loadSound("assets/audio/wall.mp3"),
        };
    }

    pub fn deinit(self: *Game) void {
        self.food.deinit();
        self.snake.deinit();

        rl.unloadSound(self.eat_sound);
        rl.unloadSound(self.wall_sound);
        rl.closeAudioDevice();
    }

    pub fn draw(self: Game) void {
        self.food.draw();
        self.snake.draw();
    }

    pub fn update(self: *Game) !void {
        if (self.is_running) {
            try self.snake.update();
            self.checkSnakeCollisionWithFood();
            try self.checkCollisionWithEdges();
            try self.checkCollisionWithTail();
            self.was_input_registered = false;
        }
    }

    fn checkSnakeCollisionWithFood(self: *Game) void {
        if (rl.math.vector2Equals(self.snake.deque.last.?.data, self.food.position) == 1) {
            self.food.position = food.Food.generateRandomPosition(self.snake.deque);
            self.snake.shouldAddSegment = true;
            self.score += 1;
            rl.playSound(self.eat_sound);
        }
    }

    fn checkCollisionWithEdges(self: *Game) !void {
        if (self.snake.deque.last.?.data.x >= grid_params.cell_count or self.snake.deque.last.?.data.x <= -1) {
            try self.endGame();
        } else if (self.snake.deque.last.?.data.y >= grid_params.cell_count or self.snake.deque.last.?.data.y <= -1) {
            try self.endGame();
        }
    }

    fn checkCollisionWithTail(self: *Game) !void {
        if (self.snake.deque.last != null and utils.vectors.isElementInDeque(self.snake.deque.last.?.data, self.snake.deque.last.?.prev)) {
            try self.endGame();
        }
    }

    fn endGame(self: *Game) !void {
        self.snake.deinit();
        self.snake = try snake.Snake.init(self.snake.allocator);
        self.food.position = food.Food.generateRandomPosition(self.snake.deque);
        self.is_running = false;
        self.score = 0;
        rl.playSound(self.wall_sound);
    }
};

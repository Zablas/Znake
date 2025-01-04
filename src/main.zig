const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const entities = @import("entities");

const Snake = entities.snake.Snake;
const Food = entities.food.Food;
const grid_params = constants.grid_params;
const colors = constants.colors;

pub fn main() !void {
    rl.initWindow(
        grid_params.cell_count * grid_params.cell_size,
        grid_params.cell_count * grid_params.cell_size,
        "Znake",
    );
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    var food = Food.init();
    defer food.deinit();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var snake = try Snake.init(allocator);
    defer snake.deinit();

    var last_snake_update_time: f64 = rl.getTime();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        food.draw();
        snake.draw();

        handlePlayerInput(&snake);

        if (shouldSnakeMove(&last_snake_update_time, 0.2)) {
            try snake.update();
        }

        rl.clearBackground(colors.green);
    }
}

fn shouldSnakeMove(prev_time: *f64, interval: f64) bool {
    const curr_time = rl.getTime();
    if (curr_time - prev_time.* >= interval) {
        prev_time.* = curr_time;
        return true;
    }

    return false;
}

fn handlePlayerInput(snake: *Snake) void {
    if (rl.isKeyPressed(rl.KeyboardKey.w) and snake.direction.y != 1) {
        snake.direction = rl.Vector2{ .x = 0, .y = -1 };
    }
    if (rl.isKeyPressed(rl.KeyboardKey.s) and snake.direction.y != -1) {
        snake.direction = rl.Vector2{ .x = 0, .y = 1 };
    }
    if (rl.isKeyPressed(rl.KeyboardKey.a) and snake.direction.x != 1) {
        snake.direction = rl.Vector2{ .x = -1, .y = 0 };
    }
    if (rl.isKeyPressed(rl.KeyboardKey.d) and snake.direction.x != -1) {
        snake.direction = rl.Vector2{ .x = 1, .y = 0 };
    }
}

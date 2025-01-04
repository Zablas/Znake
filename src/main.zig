const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const entities = @import("entities");

const Game = entities.game.Game;
const grid_params = constants.grid_params;
const colors = constants.colors;

pub fn main() !void {
    rl.initWindow(
        2 * grid_params.offset + grid_params.cell_count * grid_params.cell_size,
        2 * grid_params.offset + grid_params.cell_count * grid_params.cell_size,
        "Znake",
    );
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var game = try Game.init(allocator);
    defer game.deinit();

    var last_snake_update_time = rl.getTime();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        const border = rl.Rectangle{
            .x = @floatFromInt(grid_params.offset - grid_params.border_size),
            .y = @floatFromInt(grid_params.offset - grid_params.border_size),
            .width = @floatFromInt(2 * grid_params.border_size + grid_params.cell_count * grid_params.cell_size),
            .height = @floatFromInt(2 * grid_params.border_size + grid_params.cell_count * grid_params.cell_size),
        };
        rl.drawRectangleLinesEx(border, grid_params.border_size, colors.dark_green);

        rl.drawText("Znake", grid_params.offset - 5, 20, 40, colors.dark_green);
        rl.drawText(
            rl.textFormat("%i", .{game.score}),
            grid_params.offset - 5,
            grid_params.offset + grid_params.cell_size * grid_params.cell_count + 10,
            40,
            colors.dark_green,
        );

        game.draw();
        handlePlayerInput(&game);

        if (shouldSnakeMove(&last_snake_update_time, 0.2)) {
            try game.update();
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

fn handlePlayerInput(game: *Game) void {
    if (game.was_input_registered) {
        return;
    }

    if (rl.isKeyPressed(rl.KeyboardKey.w) and game.snake.direction.y != 1) {
        game.snake.direction = rl.Vector2{ .x = 0, .y = -1 };
        game.is_running = true;
        game.was_input_registered = true;
    }
    if (rl.isKeyPressed(rl.KeyboardKey.s) and game.snake.direction.y != -1) {
        game.snake.direction = rl.Vector2{ .x = 0, .y = 1 };
        game.is_running = true;
        game.was_input_registered = true;
    }
    if (rl.isKeyPressed(rl.KeyboardKey.a) and game.snake.direction.x != 1) {
        game.snake.direction = rl.Vector2{ .x = -1, .y = 0 };
        game.is_running = true;
        game.was_input_registered = true;
    }
    if (rl.isKeyPressed(rl.KeyboardKey.d) and game.snake.direction.x != -1) {
        game.snake.direction = rl.Vector2{ .x = 1, .y = 0 };
        game.is_running = true;
        game.was_input_registered = true;
    }
}

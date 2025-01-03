const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const entities = @import("entities");

pub fn main() !void {
    rl.initWindow(
        constants.grid_params.cell_count * constants.grid_params.cell_size,
        constants.grid_params.cell_count * constants.grid_params.cell_size,
        "Znake",
    );
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    var food = entities.food.Food.init();
    defer food.deinit();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var snake = try entities.snake.Snake.init(allocator);
    defer snake.deinit();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        food.draw();
        snake.draw();

        rl.clearBackground(constants.colors.green);
    }
}

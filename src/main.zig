const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");
const entities = @import("entities");

pub fn main() !void {
    rl.initWindow(constants.grid_params.cell_count * constants.grid_params.cell_size, constants.grid_params.cell_count * constants.grid_params.cell_size, "Znake");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    const food = entities.food.Food.init(rl.Vector2{
        .x = 5,
        .y = 6,
    });

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        food.draw();

        rl.clearBackground(constants.colors.green);
    }
}

const std = @import("std");
const rl = @import("raylib");
const colors = @import("constants/colors.zig");

pub fn main() !void {
    rl.initWindow(750, 750, "Znake");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.setExitKey(rl.KeyboardKey.null);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(colors.green);
    }
}

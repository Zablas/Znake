const rl = @import("raylib");
const constants = @import("constants");

pub const Food = struct {
    position: rl.Vector2,

    pub fn init(position: rl.Vector2) Food {
        return Food{
            .position = position,
        };
    }

    pub fn draw(self: Food) void {
        rl.drawRectangle(
            @intFromFloat(self.position.x * constants.grid_params.cell_size),
            @intFromFloat(self.position.y * constants.grid_params.cell_size),
            constants.grid_params.cell_size,
            constants.grid_params.cell_size,
            constants.colors.dark_green,
        );
    }
};

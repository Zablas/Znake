const rl = @import("raylib");
const constants = @import("constants");

pub const Food = struct {
    position: rl.Vector2,
    texture: rl.Texture2D,

    pub fn init() Food {
        return Food{
            .position = generateRandomPosition(),
            .texture = rl.loadTexture("assets/textures/food.png"),
        };
    }

    pub fn deinit(self: *Food) void {
        rl.unloadTexture(self.texture);
    }

    pub fn draw(self: Food) void {
        if (self.texture.id > 0) {
            rl.drawTexture(
                self.texture,
                @intFromFloat(self.position.x * constants.grid_params.cell_size),
                @intFromFloat(self.position.y * constants.grid_params.cell_size),
                rl.Color.white,
            );
        } else {
            rl.drawRectangle(
                @intFromFloat(self.position.x * constants.grid_params.cell_size),
                @intFromFloat(self.position.y * constants.grid_params.cell_size),
                constants.grid_params.cell_size,
                constants.grid_params.cell_size,
                constants.colors.dark_green,
            );
        }
    }

    fn generateRandomPosition() rl.Vector2 {
        return rl.Vector2{
            .x = @floatFromInt(rl.getRandomValue(0, constants.grid_params.cell_count - 1)),
            .y = @floatFromInt(rl.getRandomValue(0, constants.grid_params.cell_count - 1)),
        };
    }
};

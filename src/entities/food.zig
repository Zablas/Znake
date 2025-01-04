const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");

pub const Food = struct {
    position: rl.Vector2,
    texture: rl.Texture2D,

    pub fn init(deque: std.DoublyLinkedList(rl.Vector2)) Food {
        return Food{
            .position = generateRandomPosition(deque),
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

    pub fn generateRandomPosition(deque: std.DoublyLinkedList(rl.Vector2)) rl.Vector2 {
        var position = generateRandomCell();

        while (isElementInDeque(position, deque)) {
            position = generateRandomCell();
        }

        return position;
    }

    fn generateRandomCell() rl.Vector2 {
        return rl.Vector2{
            .x = @floatFromInt(rl.getRandomValue(0, constants.grid_params.cell_count - 1)),
            .y = @floatFromInt(rl.getRandomValue(0, constants.grid_params.cell_count - 1)),
        };
    }

    fn isElementInDeque(element: rl.Vector2, deque: std.DoublyLinkedList(rl.Vector2)) bool {
        var curr = deque.first;

        while (curr != null) {
            if (rl.math.vector2Equals(element, curr.?.data) == 1) {
                return true;
            }
            curr = curr.?.next;
        }

        return false;
    }
};

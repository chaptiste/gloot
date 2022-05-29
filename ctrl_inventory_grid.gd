class_name CtrlInventoryGrid
extends Container
tool

export(Vector2) var field_dimensions: Vector2 = Vector2(32, 32);
export(Color) var grid_color: Color = Color.black;
export(NodePath) var inventory_path: NodePath setget _set_inventory_path;
var inventory: InventoryGrid = null setget _set_inventory;
var grabbed_ctrl_inventory_item = null;
var grab_offset: Vector2;
var ctrl_inventory_item_script = preload("ctrl_inventory_item_rect.gd");


func _get_configuration_warning() -> String:
    if inventory_path.is_empty():
        return "This node is not linked to an inventory, so it can't display any content.\n" + \
               "Set the inventory_path property to point to an InventoryGrid node."
    if !(get_node_or_null(inventory_path) is InventoryGrid):
        return "The inventory_path property must point to a node inheriting from InventoryGrid.";
    return "";


func _set_inventory_path(new_inv_path: NodePath) -> void:
    inventory_path = new_inv_path;
    var node: Node = get_node_or_null(inventory_path);

    if !Engine.editor_hint && is_inside_tree():
        assert(node is InventoryGrid);
        
    _set_inventory(node);
    update_configuration_warning();


func _set_inventory(new_inventory: InventoryGrid) -> void:
    if new_inventory == null && inventory:
        _disconnect_signals();

    inventory = new_inventory;
    _refresh_grid_container();
    _refresh();
    _connect_signals();


func _ready():
    _set_inventory(get_node_or_null(inventory_path));


func _connect_signals() -> void:
    if inventory:
        inventory.connect("contents_changed", self, "_refresh");


func _disconnect_signals() -> void:
    if inventory:
        inventory.disconnect("contents_changed", self, "_refresh");


func _refresh() -> void:
    _refresh_grid_container();
    _clear_list();
    _populate_list();


func _process(_delta):
    update();


func _draw():
    if !inventory:
        return;
        
    _draw_grid(Vector2.ZERO, inventory.width, inventory.height, field_dimensions);
    if grabbed_ctrl_inventory_item:
        var relative_mouse_pos: Vector2 = get_global_mouse_position() - get_global_rect().position;
        relative_mouse_pos -= grab_offset;
        var grabbed_ctrl_item_size = inventory.get_item_size(grabbed_ctrl_inventory_item.item);
        var item_size: Vector2 = Vector2(grabbed_ctrl_item_size.x * field_dimensions.x, \
            grabbed_ctrl_item_size.y * field_dimensions.y);
        var rect: Rect2 = Rect2(relative_mouse_pos, item_size);
        draw_rect(rect, Color.white, 0);


func _draw_grid(pos: Vector2, w: int, h: int, fsize: Vector2) -> void:
    var rect = Rect2(pos, Vector2(w * fsize.x, h * fsize.y));
    draw_rect(rect, grid_color, false);
    for i in range(w):
        var from: Vector2 = Vector2(i * fsize.x, 0) + pos;
        var to: Vector2 = Vector2(i * fsize.x, h * fsize.y) + pos;
        draw_line(from, to, grid_color);
    for j in range(h):
        var from: Vector2 = Vector2(0, j * fsize.y) + pos;
        var to: Vector2 = Vector2(w * fsize.x, j * fsize.y) + pos;
        draw_line(from, to, grid_color);


func _refresh_grid_container() -> void:
    if inventory:
        rect_size = Vector2(inventory.width * field_dimensions.x, \
                                           inventory.height * field_dimensions.y);
        rect_min_size = rect_size;


func _clear_list() -> void:
    for ctrl_inventory_item in get_children():
        remove_child(ctrl_inventory_item);
        ctrl_inventory_item.queue_free();


func _populate_list() -> void:
    if Engine.editor_hint:
        return;

    if inventory == null:
        return;

    for item in inventory.get_items():
        var ctrl_inventory_item = ctrl_inventory_item_script.new();
        ctrl_inventory_item.ctrl_inventory = self;
        ctrl_inventory_item.item = item;
        ctrl_inventory_item.connect("grabbed", self, "_on_item_grab");
        add_child(ctrl_inventory_item);


func _on_item_grab(ctrl_inventory_item, offset: Vector2) -> void:
    grabbed_ctrl_inventory_item = ctrl_inventory_item;
    grab_offset = offset;


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var mb_event: InputEventMouseButton = event;
        if !mb_event.is_pressed() && \
            mb_event.button_index == BUTTON_LEFT && \
            grabbed_ctrl_inventory_item:

            if _is_mouse_hovering():
                var field_coords = _get_field_coords(get_global_mouse_position() - grab_offset);
                inventory.move_item(grabbed_ctrl_inventory_item.item, \
                    field_coords.x, \
                    field_coords.y);
            grabbed_ctrl_inventory_item = null;


func _is_mouse_hovering() -> bool:
    return get_global_rect().has_point(get_global_mouse_position());


func _get_field_coords(global_pos: Vector2) -> Vector2:
    var offset = global_pos - get_global_rect().position;
    var x: int = offset.x / field_dimensions.x;
    var y: int = offset.y / field_dimensions.y;
    return Vector2(x, y);
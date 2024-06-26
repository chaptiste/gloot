# `CtrlInventoryGridEx`

Inherits: [Control](https://docs.godotengine.org/en/stable/classes/class_control.html)

## Description

A UI control similar to [`CtrlInventoryGrid`](./ctrl_inventory_grid.md) but with extended options for customization.

## Properties

* `field_dimensions: Vector2` - The size of each inventory field in pixels.
* `item_spacing: int` - The spacing between items in pixels.
* `inventory_path: NodePath` - Path to an `Inventory` node.
* `default_item_texture: Texture` - The default texture that will be used for items with no `image` property.
* `stretch_item_sprites: bool` - If true, the inventory item sprites will be stretched to fit the inventory fields they are positioned on.
* `inventory: InventoryGrid` - The `Inventory` node linked to this control.
* `select_mode: int` - Single or multi select mode (hold CTRL to select multiple items).
* `field_style: StyleBox` - Style of a single inventory field.
* `field_highlighted_style: StyleBox` - Style of a single inventory field when the mouse hovers over it.
* `field_selected_style: StyleBox` - Style of a single inventory field when the item on top of it is selected.
* `selection_style: StyleBox` - Style of a rectangle that will be drawn on top of the selected item.

## Methods

* `get_selected_inventory_item() -> InventoryItem` - Returns the currently selected item. In case multiple items are selected, the first one is returned.
* `get_selected_inventory_items() -> Array[InventoryItem]` - Returns all the currently selected items.
* `select_inventory_item(item: InventoryItem) -> void` - Selects the given item.
* `deselect_inventory_item() -> void` - Deselects the selected item.

## Signals

* `item_dropped(InventoryItem, Vector2)` - Emitted when a grabbed `InventoryItem` is dropped.
* `inventory_item_activated(InventoryItem)` - Emitted when an `InventoryItem` is activated (i.e. double clicked).
* `inventory_item_context_activated(InventoryItem)` - Emitted when the context menu of an `InventoryItem` is activated (i.e. right clicked).
* `selection_changed` - Emitted when the selection has changed. Use `get_selected_inventory_item()` to obtain the currently selected item.
* `item_mouse_entered(InventoryItem)` - Emitted when the mouse enters the `Rect` area of the control representing the given `InventoryItem`.
* `item_mouse_exited(InventoryItem)` - Emitted when the mouse leaves the `Rect` area of the control representing the given `InventoryItem`.

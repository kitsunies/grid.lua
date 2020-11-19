<h1 align=center>grid.lua</h1>
<h3 align=center>An abstract grid class for Lua 📔</h3>

# Example

```lua
local Grid = require "grid"

local grid = Grid:new(10, 5, "...")
grid:set_cell(7, 3, "Hello World!")

print(grid:get_cell(7, 3))
--> Hello World!
```

# Installation

## Luarocks

If you are using [luarocks](https://luarocks.org), just run:

```
luarocks install grid
```

## Manual

Copy the [grid.lua](grid.lua) file somewhere where your Lua interpreter will be able to find it and require it accordingly:

```lua
local Grid = require('grid')
```

# Interface

**`Grid(x, y, [default_value])`**
Create new Grid object

```lua
local grid = Grid(10, 5, "X") -> grid
```
or
```lua
local grid = Grid:new(10, 5, "X") -> grid
```

Arguments:
* `x` `(number)` - Grid width
* `y` `(number)` - Grid height
* `default` `(any)` - Default value to fill all empty cells within Grid. Defaults to `nil`

Returns:
* `Grid` `(table)` - The Grid object 

---
**`:get_size()`**
Gets grid width and height

```lua
local width, height = Grid(10, 2):get_size()
```
Returns:
* `(number)` - Grid width
* `(number)` - Grid height
---
**`:iterate()`**
Iterator to traverse all cells from Grid 
```lua
for x, y, cell in grid:iterate() do
    print(x, y, cell)
end
```
Returns:
* `(number)` - X position of cell
* `(number)` - Y position of cell
* `(any)` - Cell's data
---
**`:get_default_value()`**
Get default value of cells, that was passed in constructor
Returns:
* `(any)` - Default value
---
**`:iterate_neighbor(x, y)`**
Iterator to traverce all neighbors of given cell

Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

Returns:
* `(number)` - Delta-X position of given cell (-1, 0, 1)
* `(number)` - Delta-Y position of given cell (-1, 0, 1)
* `(any)` - Neighbor cell's data
---
**`:is_valid(x, y)`**
Checks to see if a given cell is within the grid.

Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

Returns:
* `(boolean)` - `true` if cell is valid, `false` if not
---
**`:get_cell(x, y)`**
Gets the cell's data.

Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

Returns:
* `(any)` - Cell's data
---
**`:get_cells(cells)`**
Gets a set of data for x,y pairs in table 'cells'.

Arguments:
* `cells` `(table)` - Table of cells position pairs `{{1, 1}, {2, 2}, ...}`

Returns:
* `(table)` - Table of cell's data `{(any), (any), ...}` 
---
**`:set_cell(x, y, obj)`**
Sets the cell's data to the given object.

Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell
* `obj` `(any)` - New value of cell's data
---
**`:reset_cell(x, y)`**
Resets the cell to the default data.

Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

---
**`:reset_all()`**
Resets the entire grid to the default data.

---
**`:populate(data)`**
Given a data-filled table, will set multiple cells.

Arguments:
* `data` `(table)` - Table of new cells data `{{1, 1, "A"}, {2, 2, "B"}, ...}`

---
**`:get_contents([no_default])`**
Returns a flat table of data suitable for `:populate()`

Arguments:
* `no_default` `(boolean)` - If the argument is `true`, then the returned data table only contains elements who's cells are not the default value. Defaults to `false`

Returns:
* `(table)` - Table of cell's data `{{(number), (number), (any)}, {(number), (number), (any)}, ...}` 

---
**`:get_neighbor(x, y, vector)`**
Gets a x,y's neighbor in vector direction.

Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell
* `vector` `(table)` - The table of normalized vector like {-1, -1}. Also, you can pass `Grid.direction.` data

Returns:
* `(any)` - Cell's data

---
**`:get_neighbors(x, y)`**
Returns a table of the given's cell's all neighbors.

Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

Returns:
* `(table)` - Table of cell's data `{{(number), (number), (any)}, {(number), (number), (any)}, ...}`

---
**`:resize(newx, newy)`**
Resizes the grid. Can lose data if new grid is smaller.

Arguments:
* `newx` `(number)` - New Grid width
* `newy` `(number)` - New Grid height

---
**`:get_row(x)`**
Gets the row for the given x value.

Arguments:
* `x` `(number)` - The row number

Returns:
* `(table)` - Table of cell's data `{(any), (any), ...}` 

---
**`:get_column(y)`**
Gets the column for the given y value

Arguments:
* `y` `(number)` - The column number

Returns:
* `(table)` - Table of cell's data `{(any), (any), ...}` 

---
**`:traverse(x, y, vector)`**
Returns all cells start at x,y in vector direction.

# Testing
Install busted & luacheck `luarocks install busted && luarocks install luacheck` and run:

```
$ busted
$ luacheck grid.lua
```

# License

This library is free software; You may redistribute and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.

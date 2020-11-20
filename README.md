<h1 align=center>grid.lua</h1>

<p align="center">
    <a href="https://travis-ci.org/kitsunies/grid.lua"> <img src="https://travis-ci.org/kitsunies/grid.lua.svg?branch=master"> </a>
    <a href="https://codecov.io/gh/kitsunies/grid.lua"> <img src="https://codecov.io/gh/kitsunies/grid.lua/branch/master/graph/badge.svg?token=UVolOT9zXu"/> </a>
    <a href="https://github.com/kitsunies/emoji.lua/releases/latest"> <img src="https://img.shields.io/github/v/release/kitsunies/grid.lua"> </a>
</p>

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

## Note
All examples containing the `grid` value will always be equal to:
```lua
local grid = Grid(3, 3, "-")
grid:set_cells({
    {1, 1, "A"}, {2, 1, "B"}, {3, 1, "C"},
    {1, 2, "D"}, {2, 2, "E"}, {3, 2, "F"},
    {1, 3, "G"}, {2, 3, "H"}, {3, 3, "I"}
})
```

---
**`Grid(x, y, [default])`**
Create new Grid object
```lua
local grid = Grid(3, 3, "-")
```
or
```lua
local grid = Grid:new(3, 3, "-")
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
grid:get_size() -> 3, 3
```
Returns:
* `(number)` - Grid width
* `(number)` - Grid height
---
**`:iterate()`**
Iterator to traverse all cells from Grid 
```lua
for x, y, v in grid:iterate() do
    print(x, y, v)
end
```
Returns:
* `(number)` - X position of cell
* `(number)` - Y position of cell
* `(any)` - Cell's data
---
**`:iterate_neighbor(x, y)`**
Iterator to traverse all neighbors of given cell
```lua
for x, y, z in grid:iterate_neighbor(2, 2) do
    print(x, y, z)
end
```
Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

Returns:
* `(number)` - Delta-X position of given cell (-1, 0, 1)
* `(number)` - Delta-Y position of given cell (-1, 0, 1)
* `(any)` - Neighbor cell's data
---
**`:get_default()`**
Get default value of cells, that was passed in constructor
```lua
grid:get_default() -> "-"
```
Returns:
* `(any)` - Default value
---
**`:is_valid(x, y)`**
Checks to see if a given cell is within the grid.
```lua
grid:is_valid(1, 1) -> true
```
Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

Returns:
* `(boolean)` - `true` if cell is valid, `false` if not
---
**`:get_cell(x, y)`**
Gets the cell's data.
```lua
grid:get_cell(1, 1) -> "A"
```
Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

Returns:
* `(any)` - Cell's data
---
**`:get_cells(cells)`**
Gets a set of data for x, y pairs in table 'cells'.
```lua
grid:get_cells({{1, 1}, {2, 2}}) -> { "A", "E" }
```
Arguments:
* `cells` `(table)` - Table of cells position pairs `{{1, 1}, {2, 2}, ...}`

Returns:
* `(table)` - Table of cell's data `{(any), (any), ...}` 
---
**`:set_cell(x, y, obj)`**
Sets the cell's data to the given object.
```lua
grid:set_cell(1, 1, "A")
```
Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell
* `obj` `(any)` - New value of cell's data
---
**`:reset_cell(x, y)`**
Resets the cell to the default data.
```lua
grid:reset_cell(1, 1)
```
Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

---
**`:reset_all()`**
Resets the entire grid to the default data.
```lua
grid:reset_all()
```
---
**`:populate(data)`**
Given a data-filled table, will set multiple cells.
```lua
grid:populate({{1, 1, "A2"}, {2, 2, "E2"}})
```
Arguments:
* `data` `(table)` - Table of new cells data `{{1, 1, "A"}, {2, 2, "B"}, ...}`

---
**`:get_contents([no_default])`**
Returns a flat table of data suitable for `:populate()`
```lua
grid:get_contents(true) -> { {1, 1, "A"}, {2, 1, "B"}, ... }
```
Arguments:
* `no_default` `(boolean)` - If the argument is `true`, then the returned data table only contains elements who's cells are not the default value. Defaults to `false`

Returns:
* `(table)` - Table of cell's data `{{(number), (number), (any)}, {(number), (number), (any)}, ...}` 

---
**`:get_neighbor(x, y, vector)`**
Gets a x, y's neighbor in vector direction.
```lua
grid:get_neighbor(2, 2, {-1, -1}) -> "A"
```
Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell
* `vector` `(table)` - The table of normalized vector like `{-1, -1}`. Also, you can pass `Grid.direction` data

Returns:
* `(any)` - Cell's data

---
**`:get_neighbors(x, y)`**
Returns a table of the given's cell's all neighbors.
```lua
grid:get_neighbors(2, 2) -> { {1, 1, "A"}, {1, 2, "B"}, ... }
```
Arguments:
* `x` `(number)` - X position of cell
* `y` `(number)` - Y position of cell

Returns:
* `(table)` - Table of cell's data `{{(number), (number), (any)}, {(number), (number), (any)}, ...}`

---
**`:resize(newx, newy)`**
Resizes the grid. Can lose data if new grid is smaller.
```lua
grid:resize(5, 5)
```
Arguments:
* `newx` `(number)` - New Grid width
* `newy` `(number)` - New Grid height

---
**`:get_row(x)`**
Gets the row for the given x value.
```lua
grid:get_row(1) -> { "A", "B", "C" }
```
Arguments:
* `x` `(number)` - The row number

Returns:
* `(table)` - Table of cell's data `{(any), (any), ...}` 

---
**`:get_column(y)`**
Gets the column for the given y value
```lua
grid:get_column(1) -> { "A", "D", "G" }
```
Arguments:
* `y` `(number)` - The column number

Returns:
* `(table)` - Table of cell's data `{(any), (any), ...}` 

---
**`:traverse(x, y, vector)`**
Returns all cells start at x, y in vector direction
```lua
grid:traverse(1, 1, {1, 1}) -> { {2, 2, "E"}, {3, 3, "I"} }
```
Arguments:
*  `x` `(number)` -
*  `y` `(number)` -
* `vector` `(table)` - The table of normalized vector like `{-1, -1}`. Also, you can pass `Grid.direction` data

Returns:
* `(table)` - Table of cell's data `{{(number), (number), (any)}, {(number), (number), (any)}, ...}` 

# Testing
Install busted & luacheck `luarocks install busted && luarocks install luacheck` and run:

```
$ busted
$ luacheck grid.lua
```

# License

This library is free software; You may redistribute and/or modify it under the terms of the MIT license. See [LICENSE](LICENSE) for details.

local Grid = {
    direction = {
        top_left = {-1, -1},
        top = {0, -1},
        top_right = {1, -1},
        left = {-1, 0},
        right = {1, 0},
        bottom_left = {-1, 1},
        bottom = {0, 1},
        bottom_right = {1, 1}
    }
}

local unpack = unpack or table.unpack

function Grid:new(size_x, size_y, default)
    if type(size_x) ~= 'number' or type(size_y) ~= 'number' or size_x < 1 or size_y < 1 then
        error('Grid.new: size_x and size_y must be a number values equal or greater than 1')
    end
    self.size_x = size_x
    self.size_y = size_y
    self.default = default
    self._locked = false
    self._grid = {}
    for y = 1, self.size_y do
        for x = 1, self.size_x do
            self:set_cell(x, y, self.default)
        end
    end
    return setmetatable({}, {__index = Grid})
end

function Grid:lock()
    self._locked = true
end

function Grid:unlock()
    self._locked = false
end

function Grid:get_size()
    return self.size_x, self.size_y
end

function Grid:get_default()
    return self.default
end

function Grid:iterate()
    local x, y = 0, 1
    return function()
        if x < self.size_x then
            x = x + 1
        else
            if y < self.size_y then
                y = y + 1
                x = 1
            else
                return
            end
        end
        return x, y, self:get_cell(x, y)
    end
end

function Grid:iterate_neighbor(x, y)
    if not self:is_valid(x, y) then
        error('Grid.iterate_neighbor: try to iterate around invalid cell index [ '..tostring(x)..' : '..tostring(y)..' ]')
    end
    local iterate_table = {}
    for _, v in pairs(Grid.direction) do
        if self:is_valid(x + v[1], y + v[2]) then
            table.insert(
                iterate_table,
                {
                    cur_x = x + v[1],
                    cur_y = y + v[2],
                    dx = v[1],
                    dy = v[2]
                }
            )
        end
    end
    local index = 0
    return function()
        if index < #iterate_table then
            index = index + 1
        else
            return
        end
        return iterate_table[index].dx, iterate_table[index].dy, self:get_cell(
            iterate_table[index].cur_x,
            iterate_table[index].cur_y
        )
    end
end

function Grid:is_valid(x, y)
    if type(x) ~= 'number' or type(y) ~= 'number' then
        return false
    end
    return 0 < x and x <= self.size_x and 0 < y and y <= self.size_y
end

function Grid:get_cell(x, y)
    if self:is_valid(x, y) then
        return self._grid[(x - 1) * self.size_x + y]
    else
        error('Grid.get_cell: try to get cell by invalid index'
            ..' [ '..tostring(x)..' : '..tostring(y)..' ]')
    end
end

function Grid:get_cells(cells)
    local data = {}
    if type(cells) ~= 'table' then
        error('Grid.get_cells: invalid cells data - must be a table value, but actual is '..type(cells))
    end
    for i = 1, #cells do
        local x, y = unpack(cells[i])

        if self:is_valid(x, y) then
            table.insert(data, self:get_cell(x, y))
        else
            error('Grid.get_cells: try to get cell by invalid index'
                ..' [ '..tostring(x)..' : '..tostring(y)..' ]')
        end
    end
    return data
end

function Grid:set_cell(x, y, obj)
    if self._locked then
        error('Grid is locked, execute Grid.unlock to unlock')
    end
    if self:is_valid(x, y) then
        self._grid[(x - 1) * self.size_x + y] = obj
    else
        error('Grid.set_cell: try to set cell by invalid index'
            ..' [ '..tostring(x)..' : '..tostring(y)..' ]')
    end
end

function Grid:reset_cell(x, y)
    if self:is_valid(x, y) then
        self:set_cell(x, y, self.default)
    else
        error('Grid.reset_cell: try to reset cell by invalid index'
            ..' [ '..tostring(x)..' : '..tostring(y)..' ]')
    end
end

function Grid:reset_all()
    for x, y, _ in self:iterate() do
        self:set_cell(x, y, self.default)
    end
end

function Grid:populate(data)
    if type(data) ~= 'table' then
        error('Grid.populate: invalid input data - must be a table value, but actual '..type(data))
    end
    for i = 1, #data do
        local x, y, obj = unpack(data[i])
        if self:is_valid(x, y) then
            if not obj then
                obj = self.default
            end
            self:set_cell(x, y, obj)
        end
    end
end

function Grid:get_contents(no_default)
    local data = {}
    for x, y, v in self:iterate() do
        if not no_default and v == self.default then
            table.insert(data, {x, y, v})
        end
    end
    return data
end

function Grid:get_neighbor(x, y, vector)
    local vx, vy, obj = unpack(vector)
    if vx then
        x = x + vx
        y = y + vy
        if self:is_valid(x, y) then
            obj = self:get_cell(x, y)
        end
    end
    return obj
end

function Grid:get_neighbors(x, y)
    local data, vx, vy = {}
    if not self:is_valid(x, y) then
        return data
    end
    for gx = -1, 1 do
        for gy = -1, 1 do
            vx = x + gx
            vy = y + gy

            if self:is_valid(vx, vy) and not (gx == 0 and gy == 0) then
                table.insert(data, {vx, vy, self:get_cell(vx, vy)})
            end
        end
    end
    return data
end

function Grid:resize(newx, newy)
    if self._locked then
        error('Grid is locked, execute Grid.unlock to unlock')
    end
    if type(newx) ~= 'number' or type(newy) ~= 'number' then
        error('Grid.resize: size_x and size_y must be a number values equal or greater than 1')
    end
    local contents = self:get_contents()
    self.size_x = newx
    self.size_y = newy
    self._grid = {}
    for y = 1, self.size_y do
        for x = 1, self.size_x do
            self:set_cell(x, y, self.default)
        end
    end
    self:populate(contents)
end

function Grid:get_row(y)
    local row = {}
    if type(y) == 'number' and 0 < y and y <= self.size_y then
        for x = 1, self.size_x do
            table.insert(row, self:get_cell(x, y))
        end
    else
        error("Grid.get_row: invalid row index " .. tostring(y))
    end
    return row
end

function Grid:get_column(x)
    local col = {}
    if type(x) == 'number' and 0 < x and x <= self.size_x then
        for y = 1, self.size_y do
            table.insert(col, self:get_cell(x, y))
        end
    else
        error('Grid.get_column: invalid column index '..tostring(x))
    end
    return col
end

function Grid:traverse(x, y, v)
    local data, gx, gy, vx, vy = {}
    if self:is_valid(x, y) then
        vx, vy = unpack(v)
        if not vx then
            return data
        end
        gx = x + vx
        gy = y + vy
        while self:is_valid(gx, gy) do
            local obj = self:get_cell(gx, gy)
            table.insert(data, {gx, gy, obj})
            gx = gx + vx
            gy = gy + vy
        end
        return data
    end
    return
end

return setmetatable(Grid, {__call = Grid.new})

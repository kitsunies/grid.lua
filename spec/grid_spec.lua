describe("Grid", function()

    local Grid = require "grid"

    describe("Initialize", function()
        it("call 'new' method", function()
            local gr = Grid:new(10, 20)
            assert.is.Table(gr)
        end)

        it("with gefault size", function()
            assert.has_error(
                function() Grid() end, 
                "Grid.new: size_x and size_y must be a number values equal or greater than 1"
            )
        end)

        it("with custom size", function()
            local g = Grid(10, 1)
            local x, y = g:get_size()
            assert.are.table(g)
            assert.are.equal(x, 10)
            assert.are.equal(y, 1)
        end)

        it("with default data nil", function()
            local g = Grid(10, 10)
            assert.are.equal(g:get_cell(2, 2), nil)
            assert.are.equal(g:get_default(), nil)
        end)

        it("with custom default data", function()
            local g = Grid(10, 10, "some")
            assert.are.equal(g:get_cell(2, 2), "some")
            assert.are.equal(g:get_default(), "some")
        end)
    end)

    describe("Grid lock", function()
        local g

        setup(function()
            g = Grid(30, 10, "T")
        end)

        teardown(function()
            g = nil
        end)

        it("lock", function()
            g:lock()
            assert.has_error(g:set_cell(11, 9, "DATA"))
            assert.are.same(true, g._locked)
        end)

        it("unlock", function()
            g:unlock()
            g:set_cell(11, 9, "DATA")
            assert.are.equal(g:get_cell(11, 9), "DATA")
            assert.are.same(false, g._locked)
        end)
    end)

    describe("Cell validation", function()
        local g

        setup(function()
            g = Grid(30, 10)
        end)

        teardown(function()
            g = nil
        end)

        it("valid cells", function()
            assert.is.True(g:is_valid(1, 1))
            assert.is.True(g:is_valid(1, 10))
            assert.is.True(g:is_valid(30, 10))
            assert.is.True(g:is_valid(30, 1))
        end)

        it("not valid cells", function()
            assert.is.False(g:is_valid(0, 0))
            assert.is.False(g:is_valid(30, 11))
            assert.is.False(g:is_valid(31, 10))
        end)

        it("error parameters", function()
            assert.is.False(g:is_valid())
            assert.is.False(g:is_valid("a", "b"))
        end)
    end)

    describe("Get cell", function()
        local g

        setup(function()
            g = Grid(30, 10, "T")
        end)

        teardown(function()
            g = nil
        end)

        it("get valid cell", function()
            local data = g:get_cell(6, 8)
            assert.are.equal(data, "T")
        end)

        it("get invalid cell", function()
            assert.has_error(
                function() g:get_cell("a", "b") end, 
                "Grid.get_cell: try to get cell by invalid index [ a : b ]"
            )
        end)
    end)

    describe("Get cells", function()
        local g

        setup(function()
            g = Grid(30, 10, "T")
        end)

        teardown(function()
            g = nil
        end)

        it("valid cells table", function()
            local cells_table = {
                {1, 1},
                {20, 6}
            }

            local data_table = g:get_cells(cells_table)
            assert.is.Table(data_table)
        end)
    end)

    describe("Set cell", function()
        local g

        setup(function()
            g = Grid(30, 10, "T")
        end)

        teardown(function()
            g = nil
        end)

        it("set data in cell", function()
            g:set_cell(11, 9, "NEW")
            assert.are.equal(g:get_cell(11, 9), "NEW")
        end)
    end)

    describe("Reset cell", function()
        it("valid cell to default value", function()
            local g = Grid(10, 5)
            g:set_cell(2, 3, "DATA")
            g:reset_cell(2, 3)
            assert.are.equal(g:get_cell(2, 3), g:get_default())
        end)

        it("valid cell to custom value", function()
            local g = Grid(10, 5, "T")
            g:set_cell(2, 3, "DATA")
            g:reset_cell(2, 3)
            assert.are.equal(g:get_cell(2, 3), "T")
        end)

        it("try to reset invalid cell", function()
            local g = Grid(10, 5, "T")
            assert.has_error(
                function() g:reset_cell(100, 100) end, 
                "Grid.reset_cell: try to reset cell by invalid index [ 100 : 100 ]"
            )
        end)
    end)

    describe("Reset all cells", function()
        it("to default value", function()
            local g = Grid(17, 73)
            g:set_cell(11, 11, "Some")
            g:reset_all()
            assert.are.equal(g:get_cell(11, 11), g:get_default())
        end)

        it("to custom value", function()
            local g = Grid(8, 2, "Base")
            g:set_cell(1, 1, "Some")
            g:reset_all()
            assert.are.equal(g:get_cell(1, 1), "Base")
        end)
    end)

    describe("Populate grid", function()
        it("with new data", function()
            local g = Grid(10, 10, "Data")
            local data = {
                {1, 1, "foo"},
                {2, 2, "bar"}
            }
            g:populate(data)
            assert.are.equal(g:get_cell(1, 1), "foo")
            assert.are.equal(g:get_cell(2, 2), "bar")
        end)

        it("with default data", function()
            local g = Grid(10, 10, "Data")
            g:set_cell(1, 1, "a")
            g:set_cell(1, 1, "b")
            local data = {
                {1, 1},
                {2, 2}
            }
            g:populate(data)
            assert.are.equal(g:get_cell(1, 1), "Data")
            assert.are.equal(g:get_cell(2, 2), "Data")
        end)

        it("data is not table", function()
            local g = Grid(10, 10, "Data")
            assert.has_error(
                function() g:populate("aaaaa") end, 
                "Grid.populate: invalid input data - must be a table value, but actual string"
            )
        end)
    end)

    describe("Get contents", function()
        local gr

        setup(function()
            gr = Grid(2, 2)
            gr:set_cell(1, 1, "A")
            gr:set_cell(2, 2, "B")
        end)

        teardown(function()
            gr = nil
        end)

        it("all grid data", function()
            local res = gr:get_contents()
            assert.is.Table(res)
            assert.is.equal(#res, 4)

            assert.is.Table(res[1])
            assert.are.same(res[1], {1, 1, "A"})

            assert.is.Table(res[2])
            assert.are.same(res[2], {2, 1, nil})

            assert.is.Table(res[3])
            assert.are.same(res[3], {1, 2, nil})

            assert.is.Table(res[4])
            assert.are.same(res[4], {2, 2, "B"})
        end)

        it("only no default data", function()
            local res = gr:get_contents(true)
            assert.is.Table(res)
            assert.is.equal(#res, 2)

            assert.is.Table(res[1])
            assert.are.same(res[1], {1, 1, "A"})

            assert.is.Table(res[2])
            assert.are.same(res[2], {2, 2, "B"})
        end)
    end)

    describe("Get neighbor", function()
        local gr

        setup(function()
            gr = Grid(3, 3, "Base")
            gr:set_cell(1, 1, "A")
            gr:set_cell(2, 1, "B")
            gr:set_cell(3, 1, "C")
            gr:set_cell(1, 2, "D")
            gr:set_cell(2, 2, "E")
            gr:set_cell(3, 2, "F")
            gr:set_cell(1, 3, "G")
            gr:set_cell(2, 3, "H")
            gr:set_cell(3, 3, "I")
        end)

        teardown(function()
            gr = nil
        end)

        it("top left", function()
            local res = gr:get_neighbor(2, 2, Grid.direction.top_left)
            assert.is.equal(res, "A")
        end)

        it("not valid cell", function()
            local res = gr:get_neighbor(1, 1, Grid.direction.top)
            assert.is.Nil(res)
        end)
    end)

    describe("Get neighbors", function()
        it("valid base cell", function()
            local g = Grid(3, 3, "A")
            local res = g:get_neighbors(2, 2)
            assert.is.Table(res)
            assert.is.equal(#res, 8)
            assert.are.same(res[1], {1, 1, "A"})
        end)

        it("not valid base cell", function()
            local g = Grid(10, 10, "A")
            local res = g:get_neighbors(20, 20)
            assert.is.Table(res)
            assert.are.same(res, {})
        end)
    end)

    describe("Resize", function()
        it("bigger size", function()
            local gr = Grid(2, 2)
            gr:resize(3, 3)
            local size_x, size_y = gr:get_size()
            assert.is.equal(size_x, 3)
            assert.is.equal(size_y, 3)
        end)

        it("lesser size", function()
            local gr = Grid(5, 5)
            gr:resize(2, 2)
            local size_x, size_y = gr:get_size()
            assert.is.equal(size_x, 2)
            assert.is.equal(size_y, 2)
        end)

        it("invalid size", function()
            local gr = Grid(5, 5)
            assert.has_error(
                function() gr:resize("a", "b") end, 
                "Grid.resize: size_x and size_y must be a number values equal or greater than 1"
            )
        end)
    end)

    describe("Get row", function()
        it("valid row", function()
            local gr = Grid(4, 3, "A")
            local res = gr:get_row(1)
            assert.is.Table(res)
            assert.are.same(res, {"A", "A", "A", "A"})
        end)

        it("row index is not number", function()
            local gr = Grid(4, 3, "A")
            assert.has_error(
                function() gr:get_row("a") end, 
                "Grid.get_row: invalid row index a"
            )
        end)

        it("row index less then grid size", function()
            local gr = Grid(4, 3, "A")
            assert.has_error(
                function() gr:get_row(0) end, 
                "Grid.get_row: invalid row index 0"
            )
        end)

        it("row index more then grid size", function()
            local gr = Grid(4, 6, "A")
            assert.has_error(
                function() gr:get_row(7) end, 
                "Grid.get_row: invalid row index 7"
            )
        end)
    end)

    describe("Get column", function()
        it("valid column", function()
            local gr = Grid(2, 3, "A")
            local res = gr:get_column(1)
            assert.is.Table(res)
            assert.are.same(res, {"A", "A", "A"})
        end)

        it("column index is not number", function()
            local gr = Grid(4, 3, "A")
            assert.has_error(
                function() gr:get_column("a") end, 
                "Grid.get_column: invalid column index a"
            )
        end)

        it("column index less then grid size", function()
            local gr = Grid(4, 3, "A")
            assert.has_error(
                function() gr:get_column(0) end, 
                "Grid.get_column: invalid column index 0"
            )
        end)

        it("column index more then grid size", function()
            local gr = Grid(4, 6, "A")
            assert.has_error(
                function() gr:get_column(7) end, 
                "Grid.get_column: invalid column index 7"
            )
        end)
    end)

    describe("Traverse", function()
        it("valid vector", function()
            local gr = Grid(2, 2, "B")
            local res = gr:traverse(2, 1, Grid.direction.bottom_left)
            assert.is.Table(res)
            assert.are.same(res, {{1, 2, "B"}})
        end)

        it("invalid base cell", function()
            local gr = Grid(2, 2, "B")
            local res = gr:traverse(0, 0, Grid.direction.bottom_left)
            assert.is.Nil(res)
        end)
    end)
end)

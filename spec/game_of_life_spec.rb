require "./game_of_life"

describe "rspec" do
    it "asserts true is true" do
        expect(true).to be true
    end
end

describe "board" do
    it "exists" do
        expect(Board.new).not_to be_nil
        # expect(Board.new).to exist
    end

    it "has columns" do
        expect(Board.new(columns: 10).columns).to eq(10)
    end

    it "has rows" do
        expect(Board.new(rows: 10).rows).to eq(10)
    end

    it "returns cells" do
        expect(Board.new.cells).to eq([])
    end

    it "a cell can be found on board" do
        @board = Board.new
        @cell = Cell.new(x: 10, y: 10, board: @board)
        @cell2 = Cell.new(x: 11, y: 11, board: @board)
        expect(@board.find_cell(x: 10, y: 10)).to eq(@cell)
    end
end

describe "cell" do
    it "exists" do
        expect(Cell.new).not_to be_nil
    end

    it "has x position" do
        expect(Cell.new(x: 1).x).to eq(1)
    end

    it "has y position" do
        expect(Cell.new(y:1).y).to eq(1)
    end

    it "is alive" do
        expect(Cell.new.alive).to eq(true)
    end

    it "is dead" do
        cell = Cell.new(alive: false)
        expect(cell.alive).to eq(false)
    end

    it "belongs on a board" do
        expect(Cell.new(board: Board.new).board).not_to be_nil
    end

    # it "is located on a board" do
    #     board = Board.new(columns: 10, rows: 10)
    #     expect(Cell.new(x: 11, y: 11, board: board)).to raise_error("Cell outside of board")
    # end

    before(:each) do
        @board = Board.new
        @cell = Cell.new(x: 10, y: 10, board: @board)
    end

    it "is added to board when initialized" do
        expect(@board.cells).not_to be_empty
    end

    it "returns its neighbours" do
        expect(@cell.alive_neighbours).to be_a_kind_of(Array)
    end

    it "shows that cell has one neighbour (detects neighbours)" do
        Cell.new(x: 10, y: 9, board: @board)
        expect(@cell.alive_neighbours.size).to eq(1)
    end

    it "detects bottom neighbour" do
        @cell2 = Cell.new(x: 10, y: 9, board: @board)
        expect(@cell.alive_neighbours.size).to eq(1)
    end

    it "detects top neighbour" do
        Cell.new(x: 10, y: 11, board: @board)
        expect(@cell.alive_neighbours.size).to eq(1)
    end

    it "detects left neighbour" do
        Cell.new(x: 9, y: 10, board: @board)
        expect(@cell.alive_neighbours.size).to eq(1)
    end

    it "detects right neighbour" do
        Cell.new(x: 11, y: 10, board: @board)
        expect(@cell.alive_neighbours.size).to eq(1)
    end

    it "cell can change its status" do
        expect(@cell).to respond_to(:evaluate_state)
    end

    it "change status from live to dead" do
        @cell.toggle_status
        expect(@cell.alive).to eq(false)
    end

    it "cell dies when less than 2 neighbours" do
        @cell.evaluate_state
        expect(@cell.alive).to eq(false)
    end

    it "cell dies when over 3 neighbours" do
        Cell.new(x: 10, y: 9, board: @board)
        Cell.new(x: 10, y: 11, board: @board)
        Cell.new(x: 9, y: 10, board: @board)
        Cell.new(x: 11, y: 10, board: @board)
        @cell.evaluate_state
        expect(@cell.alive).to eq(false)
    end

    it "cell lives when 3 neighbours" do
        Cell.new(x: 10, y: 9, board: @board)
        Cell.new(x: 10, y: 11, board: @board)
        Cell.new(x: 9, y: 10, board: @board)
        @cell.evaluate_state
        expect(@cell.alive).to eq(true)
    end

    it "cell lives when 2 neighbours" do
        Cell.new(x: 10, y: 9, board: @board)
        Cell.new(x: 10, y: 11, board: @board)
        Cell.new(x: 9, y: 10, board: @board)
        @cell.evaluate_state
        expect(@cell.alive).to eq(true)
    end

    it "returns top dead neighbour of a cell" do
        # Cell.new(x: 10, y: 9, board: @board)
        Cell.new(x: 10, y: 11, board: @board)
        Cell.new(x: 9, y: 10, board: @board)
        Cell.new(x: 11, y: 10, board: @board)
        expect(@cell.return_dead_neighbours.size).to eq(1)
    end

    it "returns bottom dead neighbour of a cell" do
        Cell.new(x: 10, y: 9, board: @board)
        # Cell.new(x: 10, y: 11, board: @board)
        Cell.new(x: 9, y: 10, board: @board)
        Cell.new(x: 11, y: 10, board: @board)
        expect(@cell.return_dead_neighbours.size).to eq(1)
    end

    it "returns left dead neighbour of a cell" do
        Cell.new(x: 10, y: 9, board: @board)
        Cell.new(x: 10, y: 11, board: @board)
        # Cell.new(x: 9, y: 10, board: @board)
        Cell.new(x: 11, y: 10, board: @board)
        expect(@cell.return_dead_neighbours.size).to eq(1)
    end

    it "returns right dead neighbour of a cell" do
        Cell.new(x: 10, y: 9, board: @board)
        Cell.new(x: 10, y: 11, board: @board)
        Cell.new(x: 9, y: 10, board: @board)
        # Cell.new(x: 11, y: 10, board: @board)
        expect(@cell.return_dead_neighbours.size).to eq(1)
    end

    it "returns dead neighbours of a cell" do
        Cell.new(x: 10, y: 9, board: @board)
        Cell.new(x: 10, y: 11, board: @board)
        # check neighbours of x:11, y:10 cell
        expect(@cell.return_dead_neighbours.size).to eq(2)
    end

    it "a new cell comes alive if 3 neighbours - step by step" do
        # x:11, y:10 to come alive
        # existing: x: 10, y: 10
        Cell.new(x: 11, y: 9, board: @board)
        Cell.new(x: 11, y: 11, board: @board)
        cell = Cell.new(x: 11, y:10, board: @board, alive: false)
        cell.evaluate_state
        expect(cell.alive).to be true
    end

    it "a new cell comes alive if 3 neighbours #resurrect_dead_neighbour" do
        # x:11, y:10 to come alive
        # existing: x: 10, y: 10
        Cell.new(x: 11, y: 9, board: @board)
        Cell.new(x: 11, y: 11, board: @board)
        @cell.resurrect_dead_neighbour
        expect(@board.find_cell(x: 11, y:10).alive).to be true
    end

    # TESTS FOR #generation function
end
class Board
    attr_accessor :columns, :rows, :cells

    def initialize(attributes = {})
        @columns = attributes[:columns]
        @rows = attributes[:rows]
        @cells = []
    end

    def find_cell(coordinates = {})
        self.cells.each do |cell|
           return cell if cell.x == coordinates[:x] && cell.y == coordinates[:y]   
        end
        nil
    end

    def generation
        self.cells.each do |cell|
            cell.evaluate_state
            cell.resurrect_dead_neighbour
        end
        self.cells.each { |cell| cell.delete(cell) if !cell.alive }
    end
end

class Cell
    attr_accessor :x, :y, :alive, :board

    def initialize(attributes = {})
        @x = attributes[:x]
        @y = attributes[:y]
        attributes[:alive].nil? ? @alive = true : @alive = attributes[:alive]
        @board = attributes[:board]
        # raise StandardError.new "Cell outside of board" if @x > @board.columns || @y > @board.rows
        @board.cells << self if @board
    end

    def alive_neighbours
        alive_neighbours = []
        @board.cells.each do |cell|
            # same column, different rows
            if cell.x == self.x && cell.alive == true
                # bottom neighbour
                alive_neighbours << cell if cell.y == (self.y - 1)
                # top neighbour
                alive_neighbours << cell if cell.y == (self.y + 1)
            end
            # same row, different columns
            if cell.y == self.y && cell.alive == true
                # left neighbour
                alive_neighbours << cell if cell.x == (self.x - 1)
                # # right neighbour
                alive_neighbours << cell if cell.x == (self.x + 1)
            end
        end
        alive_neighbours
    end

    def evaluate_state
        if self.alive 
            # live cell dies if less than 2 neighbours
            self.toggle_status if self.alive_neighbours.size < 2
            # live cell dies if more than 3 neighbours
            self.toggle_status if self.alive_neighbours.size > 3
        end

        if !self.alive
            self.toggle_status if self.alive_neighbours.size == 3
        end
    end

    def toggle_status
        @alive = !@alive
    end

    def delete_from_board
        @board.cells.delete(self)
    end

    def return_dead_neighbours
        dead_neighbours = []
        # create temporary instances alive = false
        # top neighbour
        dead_neighbours << Cell.new(x: self.x, y: (self.y - 1), alive: false, board: self.board) if @board.find_cell(x: self.x, y: (self.y - 1)) == nil
        # bottom neighbour
        dead_neighbours << Cell.new(x: self.x, y: (self.y + 1), alive: false, board: self.board) if @board.find_cell(x: self.x, y: (self.y + 1)) == nil
        # left neighbour
        dead_neighbours << Cell.new(x: (self.x - 1), y: (self.y), alive: false, board: self.board) if @board.find_cell(x: (self.x - 1), y: self.y) == nil
        # right neighbour
        dead_neighbours << Cell.new(x: (self.x + 1), y: self.y, alive: false, board: self.board) if @board.find_cell(x: (self.x + 1), y: self.y) == nil
        dead_neighbours
    end

    def resurrect_dead_neighbour
        dead_neighbours = self.return_dead_neighbours
        dead_neighbours.each do |neighbour|
            state_before = neighbour.alive
            neighbour.evaluate_state
            # if still dead remove from cells array
            neighbour.delete_from_board if state_before == neighbour.alive
        end
    end
end
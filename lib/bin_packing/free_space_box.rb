module BinPacking
  class FreeSpaceBox
    attr_accessor :x, :y, :width, :height

    def initialize(width, height)
      @width = width
      @height = height
      @x = 0
      @y = 0
    end
  end
end

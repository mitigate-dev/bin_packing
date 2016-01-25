module BinPacking
  class Box
    attr_accessor :width, :height, :x, :y, :packed

    def initialize(width, height)
      @width = width
      @height = height
      @x = 0
      @y = 0
      @packed = false
    end

    def area
      @area ||= @width * @height
    end

    def rotate
      @width, @height = [@height, @width]
    end

    def packed?
      @packed
    end

    def label
      "#{@width}x#{@height} at [#{@x},#{@y}]"
    end
  end
end

module BinPacking
  class Score
    include Comparable

    MAX_INT = (2**(0.size * 8 -2) -1)

    attr_reader :score_1, :score_2

    def self.new_blank
      new
    end

    def initialize(score_1 = nil, score_2 = nil)
      @score_1 = score_1 || MAX_INT
      @score_2 = score_2 || MAX_INT
    end

    # Smaller number is greater (used by original algorithm).
    def <=>(other)
      if self.score_1 > other.score_1 || (self.score_1 == other.score_1 && self.score_2 > other.score_2)
        -1
      elsif self.score_1 < other.score_1 || (self.score_1 == other.score_1 && self.score_2 < other.score_2)
        1
      else
        0
      end
    end

    def assign(other)
      @score_1 = other.score_1
      @score_2 = other.score_2
    end

    def is_blank?
      @score_1 == MAX_INT
    end

    def decrease_by(delta)
      @score_1 += delta
      @score_2 += delta
    end
  end
end

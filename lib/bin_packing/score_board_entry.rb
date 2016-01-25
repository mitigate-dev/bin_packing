module BinPacking
  class ScoreBoardEntry
    attr_reader :bin, :box, :score

    def initialize(bin, box)
      @bin = bin
      @box = box
      @score = nil
    end

    def calculate
      @score = @bin.score_for(@box)
    end

    def fit?
      !@score.is_blank?
    end
  end
end

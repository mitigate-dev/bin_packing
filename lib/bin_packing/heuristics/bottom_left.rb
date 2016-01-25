module BinPacking
  module Heuristics
    class BottomLeft < BinPacking::Heuristics::Base
      private

      def calculate_score(free_rect, rect_width, rect_height)
        top_side_y = free_rect.y + rect_height
        BinPacking::Score.new(top_side_y, free_rect.x)
      end
    end
  end
end

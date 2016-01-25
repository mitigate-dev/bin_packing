module BinPacking
  module Heuristics
    class BestLongSideFit < BinPacking::Heuristics::Base
      private

      def calculate_score(free_rect, rect_width, rect_height)
        leftover_horiz = (free_rect.width - rect_width).abs
        leftover_vert = (free_rect.height - rect_height).abs
        BinPacking::Score.new(*[leftover_horiz, leftover_vert].sort.reverse)
      end
    end
  end
end

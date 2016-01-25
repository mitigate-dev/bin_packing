module BinPacking
  module Heuristics
    class BestAreaFit < BinPacking::Heuristics::Base
      private

      def calculate_score(free_rect, rect_width, rect_height)
        area_fit = free_rect.width * free_rect.height - rect_width * rect_height
        leftover_horiz = (free_rect.width - rect_width).abs
        leftover_vert = (free_rect.height - rect_height).abs
        short_side_fit = [leftover_horiz, leftover_vert].min
        BinPacking::Score.new(area_fit, short_side_fit)
      end
    end
  end
end

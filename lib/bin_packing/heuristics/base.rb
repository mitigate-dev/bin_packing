module BinPacking
  module Heuristics
    class Base
      def find_position_for_new_node!(box, free_rectangles)
        best_score = BinPacking::Score.new
        width = box.width
        height = box.height

        free_rectangles.each do |free_rect|
          try_place_rect_in(free_rect, box, width, height, best_score)
          try_place_rect_in(free_rect, box, height, width, best_score)
        end

        best_score
      end

      private

      def try_place_rect_in(free_rect, box, rect_width, rect_height, best_score)
        if free_rect.width >= rect_width && free_rect.height >= rect_height
          score = calculate_score(free_rect, rect_width, rect_height)
          if score > best_score
            box.x = free_rect.x
            box.y = free_rect.y
            box.width = rect_width
            box.height = rect_height
            box.packed = true
            best_score.assign(score)
          end
        end
      end

      def calculate_score(free_rect, rect_width, rect_height)
        raise NotImplementedError
      end
    end
  end
end

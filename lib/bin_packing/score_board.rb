#       box_1 box_2 box_3 ...
# bin_1  100   200    0
# bin_2   0     5     0
# bin_3   9    100    0
# ...
module BinPacking
  class ScoreBoard
    def initialize(bins, boxes)
      @entries = []
      bins.each do |bin|
        add_bin_entries(bin, boxes)
      end
    end

    def any?
      @entries.any?
    end

    def largest_not_fiting_box
      unfit = nil
      fitting_boxes = Set.new(@entries.select(&:fit?).map(&:box))
      @entries.each do |entry|
        next if fitting_boxes.include?(entry.box)
        unfit = entry if unfit.nil? || unfit.box.area < entry.box.area
      end
      unfit.try(:box)
    end

    def best_fit
      best = nil
      @entries.each do |entry|
        next unless entry.fit?
        best = entry if best.nil? || best.score < entry.score
      end
      best
    end

    def remove_box(box)
      @entries.delete_if { |e| e.box == box }
    end

    def add_bin(bin)
      add_bin_entries(bin, current_boxes)
    end

    def recalculate_bin(bin)
      @entries.select { |e| e.bin == bin }.each(&:calculate)
    end

    private

    def add_bin_entries(bin, boxes)
      boxes.each do |box|
        entry = BinPacking::ScoreBoardEntry.new(bin, box)
        entry.calculate
        @entries << entry
      end
    end

    def current_boxes
      @entries.map(&:box).uniq
    end
  end
end

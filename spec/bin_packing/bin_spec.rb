require 'spec_helper'

describe BinPacking::Bin do
  describe 'for documentation' do
    it 'allows to insert boxes while space available' do
      bin = BinPacking::Bin.new(100, 50)
      boxes = [
        BinPacking::Box.new(50, 50),
        BinPacking::Box.new(10, 40),
        BinPacking::Box.new(50, 44)
      ]
      remaining_boxes = []
      boxes.each do |box|
        remaining_boxes << box unless bin.insert(box)
      end
      expect(bin.boxes.size).to eq(2)
      expect(bin.boxes[0]).to eq boxes[0]
      expect(bin.boxes[1]).to eq boxes[1]
      expect(remaining_boxes.size).to eq 1
      expect(remaining_boxes[0]).to eq boxes[2]
      expect(bin.boxes[0].x).to eq 0
      expect(bin.boxes[0].y).to eq 0
      expect(bin.boxes[0].packed?).to eq true
      expect(bin.boxes[1].x).to eq 50
      expect(bin.boxes[1].y).to eq 0
      expect(bin.boxes[1].packed?).to eq true
      expect(bin.efficiency).to eq 58
      expect(remaining_boxes[0].x).to eq 0
      expect(remaining_boxes[0].y).to eq 0
      expect(remaining_boxes[0].packed?).to eq false
    end

    it 'allows to use custom heuristic' do
      bin = BinPacking::Bin.new(100, 50, BinPacking::Heuristics::BestAreaFit.new)
      expect(bin.insert(BinPacking::Box.new(50, 100))).to eq true
    end
  end
end

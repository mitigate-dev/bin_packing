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

  describe 'insert_in_known_position' do
    let(:bin) { BinPacking::Bin.new(100, 50) }

    it 'should allow inserting a box without updating its position' do
      box = BinPacking::Box.new(50, 50)
      box.x = 40
      box.y = 10

      expect(bin.insert_in_known_position(box)).to eq(true)

      expect(box.x).to eq(40)
      expect(box.y).to eq(10)
    end

    it 'should not be movable by inserting new boxes' do
      box = BinPacking::Box.new(50, 50)
      box.x = 25
      box.y = 25

      bin.insert_in_known_position(box)

      other_box = BinPacking::Box.new(30, 30)

      expect(bin.insert(other_box)).to eq(false)
      expect(other_box.packed?).to eq(false)
    end

    it 'should allow insertion of boxes if known boxes leave space' do
      big_box = BinPacking::Box.new(50, 50)
      big_box.x = 0
      big_box.y = 0

      bin.insert_in_known_position(big_box)

      smaller_box = BinPacking::Box.new(30, 20)
      smaller_box.x = 50
      smaller_box.y = 0

      bin.insert_in_known_position(smaller_box)

      fitting_box = BinPacking::Box.new(20, 20)

      expect(bin.insert(fitting_box)).to eq(true)

      too_big_box = BinPacking::Box.new(40, 40)

      expect(bin.insert(too_big_box)).to eq(false)
    end

    it 'should allow insertion of overlapping boxes' do
      box_a = BinPacking::Box.new(50, 50)
      box_a.x = 0
      box_a.y = 0

      box_b = BinPacking::Box.new(50, 50)
      box_b.x = 5
      box_b.y = 5

      expect(bin.insert_in_known_position(box_a)).to eq(true)
      expect(bin.insert_in_known_position(box_b)).to eq(true)
    end

    it 'should allow insertion of boxes too big for bins' do
      box = BinPacking::Box.new(100, 100)
      box.x = 0
      box.y = 0

      expect(bin.insert_in_known_position(box)).to eq(true)
    end
  end
end

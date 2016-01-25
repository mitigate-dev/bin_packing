require 'spec_helper'

describe BinPacking::Packer do
  let(:bin_of_size_1) { BinPacking::Bin.new(9_600, 3_100) }
  let(:bin_of_size_2) { BinPacking::Bin.new(10_000, 4_500) }
  let(:bin_of_size_3) { BinPacking::Bin.new(12_000, 4_500) }

  describe '#pack' do
    it 'does nothing when no bin and no box passed' do
      packer = BinPacking::Packer.new([])
      expect(packer.pack([])).to eq []
    end

    it 'puts single box in single bin' do
      bin = bin_of_size_1
      box = BinPacking::Box.new(9_000, 3_000)
      packer = BinPacking::Packer.new([bin])
      expect(packer.pack([box])).to eq [box]
      expect(bin.boxes.size).to be 1
      expect(box.width).to be 9_000
      expect(box.height).to be 3_000
      expect(box.x).to be 0
      expect(box.y).to be 0
      expect(box.packed?).to be true
    end

    it 'puts rotated box in single bin' do
      bin = bin_of_size_1
      box = BinPacking::Box.new(1_000, 9_000)
      packer = BinPacking::Packer.new([bin])
      expect(packer.pack([box]).size).to be 1
      expect(bin.boxes.size).to be 1
      expect(box.width).to be 9_000
      expect(box.height).to be 1_000
      expect(box.x).to be 0
      expect(box.y).to be 0
      expect(box.packed?).to be true
    end

    it 'puts large box in large bin' do
      bin_1 = bin_of_size_1
      bin_2 = bin_of_size_2
      bin_3 = bin_of_size_3
      box = BinPacking::Box.new(11_000, 2_000)
      packer = BinPacking::Packer.new([bin_1, bin_2, bin_3])
      expect(packer.pack([box]).size).to be 1
      expect(bin_1.boxes.size).to be 0
      expect(bin_2.boxes.size).to be 0
      expect(bin_3.boxes.size).to be 1
      expect(box.width).to be 11_000
      expect(box.height).to be 2_000
    end

    it 'puts two boxes in single bin' do
      bin = bin_of_size_1
      box_1 = BinPacking::Box.new(8_000, 1_500)
      box_2 = BinPacking::Box.new(1_000, 9_000)
      packer = BinPacking::Packer.new([bin])
      expect(packer.pack([box_1, box_2]).size).to be 2
      expect(bin.boxes.size).to be 2
    end

    it 'puts two boxes in separate bins' do
      bin_1 = BinPacking::Bin.new(9_600, 3_100)
      bin_2 = BinPacking::Bin.new(9_600, 3_100)
      box_1 = BinPacking::Box.new(5_500, 2_000)
      box_2 = BinPacking::Box.new(5_000, 2_000)
      packer = BinPacking::Packer.new([bin_1, bin_2])
      expect(packer.pack([box_1, box_2]).size).to be 2
      expect(bin_1.boxes.size).to be 1
      expect(bin_2.boxes.size).to be 1
    end

    it 'does not put in bin too large box' do
      bin = bin_of_size_1
      box = BinPacking::Box.new(10_000, 10)
      packer = BinPacking::Packer.new([bin])
      expect(packer.pack([box]).size).to be 0
      expect(bin.boxes.size).to be 0
      expect(box.packed?).to be false
    end

    it 'puts in bin only fitting boxes' do
      bin = bin_of_size_1
      box_1 = BinPacking::Box.new(4_000, 3_000)
      box_2 = BinPacking::Box.new(4_000, 3_000)
      box_3 = BinPacking::Box.new(4_000, 3_000)
      boxes = [box_1, box_2, box_3]
      packer = BinPacking::Packer.new([bin])
      expect(packer.pack(boxes).size).to be 2
      expect(bin.boxes.size).to be 2
      expect(boxes.size).to be 3 # Should not modify input array
      expect(boxes.count(&:packed?)).to be 2
    end

    it 'respects limit' do
      bin = bin_of_size_1
      box_1 = BinPacking::Box.new(1_000, 1_000)
      box_2 = BinPacking::Box.new(1_000, 1_000)
      boxes = [box_1, box_2]
      packer = BinPacking::Packer.new([bin])
      expect(packer.pack(boxes, limit: 1).size).to be 1
      expect(bin.boxes.size).to be 1
      expect(boxes.size).to be 2
      expect(boxes.count(&:packed?)).to be 1
    end

    it 'does not pack box twice' do
      bin = bin_of_size_1
      box = BinPacking::Box.new(1_000, 9_000)
      packer = BinPacking::Packer.new([bin])
      expect(packer.pack([box]).size).to be 1
      expect(packer.pack([box]).size).to be 0
    end
  end

  describe '#pack!' do
    it 'throws error when some of boxes not packed' do
      box_1 = BinPacking::Box.new(9_000, 3_000)
      box_2 = BinPacking::Box.new(8_000, 2_500)
      packer = BinPacking::Packer.new([bin_of_size_1])
      expect { packer.pack!([box_1, box_2]) }.to \
        raise_error(ArgumentError, '1 boxes not packed into 1 bins!')
    end
  end

  describe 'for documentation' do
    it 'puts multiple boxes into multiple bins' do
      bin_1 = BinPacking::Bin.new(100, 50)
      bin_2 = BinPacking::Bin.new(50, 50)
      boxes = [
        BinPacking::Box.new(15, 10), # Should be added last (smaller)
        BinPacking::Box.new(50, 45), # Fits in bin_2 better than in bin_1
        BinPacking::Box.new(40, 40),
        BinPacking::Box.new(200, 200) # Too large to fit
      ]
      packer = BinPacking::Packer.new([bin_1, bin_2])
      packed_boxes = packer.pack(boxes)
      expect(packed_boxes.size).to eq 3
      expect(bin_1.boxes.size).to eq 2
      expect(bin_1.boxes[0].label).to eq '40x40 at [0,0]'
      expect(bin_1.boxes[1].label).to eq '15x10 at [0,40]'
      expect(bin_2.boxes.size).to eq 1
      expect(bin_2.boxes[0].label).to eq '50x45 at [0,0]'
      expect(boxes.last.packed?).to eq false
    end
  end
end

require 'spec_helper'

class Record
  attr_accessor :id, :width, :height
end

class BinWithRecord < BinPacking::Bin
  attr_reader :record

  def initialize(record)
    super(record.width, record.height)
    @record = record
  end
end

class BoxWithColor < BinPacking::Box
  attr_reader :color

  def initialize(width, height, color)
    super(width, height)
    @color = color
  end
end

describe 'for documentation' do
  it 'can store extra information' do
    record = Record.new
    record.id = 321
    record.width = 100
    record.height = 200
    bin = BinWithRecord.new(record)
    box = BoxWithColor.new(70, 80, 'silver')
    expect(bin.insert(box)).to eq true
    expect(bin.record.id).to eq 321
    expect(bin.boxes.first.color).to eq 'silver'
  end
end

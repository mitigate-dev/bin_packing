[![Build Status](https://api.travis-ci.org/mak-it/bin_packing.png)](http://travis-ci.org/mak-it/bin_packing)

# Bin-packing

A library for placing 2D rectangles (box-es) in one or multiple rectangular areas (bins) with reasonable area allocation efficiency. Rectangles may be rotated by 90 degrees.

This is [Maximal Rectangles Algorithm](http://clb.demon.fi/files/RectangleBinPack.pdf) implementation in Ruby. Translated [from C++](https://github.com/juj/RectangleBinPack) and improved.

## Install

```shell
gem install bin_packing
```
or add the following line to Gemfile:

```ruby
gem 'bin_packing'
```
and run `bundle install` from your shell.


## Documentation

Add boxes to bin in given order:
```ruby
require 'bin_packing'

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

bin.boxes.size
=> 2
bin.boxes[1].x
=> 50
bin.boxes[1].y
=> 0
bin.boxes[1].packed?
=> true
bin.efficiency # in percent
=> 58
remaining_boxes.size
=> 1
```

Add boxes to one or multiple bins in best-fitting order:
```ruby
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

packed_boxes.size
=> 3
bin_1.boxes.size
=> 2
bin_1.boxes[0].label
=> '40x40 at [0,0]'
bin_1.boxes[1].label
=> '15x10 at [0,40]'
bin_2.boxes.size
=> 1
bin_2.boxes[0].label
=> '50x45 at [0,0]'
boxes.last.packed?
=> false
```

Specify heuristic for box arrangement in bin:
```ruby
bin = BinPacking::Bin.new(100, 50, BinPacking::Heuristics::BestAreaFit.new)
bin.insert(BinPacking::Box.new(50, 100)))
=> true
```
Following heuristics are available:
* BestAreaFit - least remaining area
* BestLongSideFit - least remaining side length (worst of both dimensions is more important)
* BestShortSideFit - least remaining side length (best of both dimensions is more important) - __default__
* BottomLeft - most tallest box is taken

Add custom data to bins and boxes using inheritance:
```ruby
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

record = Record.new
record.id = 321
record.width = 100
record.height = 200
bin = BinWithRecord.new(record)
box = BoxWithColor.new(70, 80, 'silver')
bin.insert(box)
=> true
bin.record.id
=> 321
bin.boxes.first.color
=> 'silver'
```

Export results to HTML:
```ruby
bin_1 = BinPacking::Bin.new(1500, 1000)
bin_2 = BinPacking::Bin.new(500, 200)
bin_1.insert!(BinPacking::Box.new(950, 950))
bin_1.insert!(BinPacking::Box.new(500, 500))
bin_1.insert!(BinPacking::Box.new(200, 500))
bin_1.insert!(BinPacking::Box.new(250, 300))

html = BinPacking::Export.new(bin_1, bin_2).to_html(zoom: 0.5)

File.write('my/path.html', html)
```
![Exported html example](https://github.com/mak-it/bin_packing/raw/master/images/export_example.png "Exported html example")

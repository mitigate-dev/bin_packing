require 'spec_helper'
require 'fileutils'

describe BinPacking::Export do
  describe '#to_html' do
    describe 'for documentation' do
      it 'renders html file' do
        bin_1 = BinPacking::Bin.new(1500, 1000)
        bin_2 = BinPacking::Bin.new(500, 200)
        bin_1.insert!(BinPacking::Box.new(950, 950))
        bin_1.insert!(BinPacking::Box.new(500, 500))
        bin_1.insert!(BinPacking::Box.new(200, 500))
        bin_1.insert!(BinPacking::Box.new(250, 300))
        html = BinPacking::Export.new(bin_1, bin_2).to_html(zoom: 0.5)
        expect(html).to include(bin_1.label)
        expect(html).to include(bin_1.boxes.first.label)
        expect(html).to include(bin_1.boxes.last.label)
        expect(html).to include(bin_2.label)

        # export_path = File.expand_path("../result_#{Time.now.to_i}.html", __FILE__)
        # File.write(export_path, html)
      end
    end

    it 'exports array of bins' do
      bin_1 = BinPacking::Bin.new(100, 50)
      bin_1.insert!(BinPacking::Box.new(25, 100))
      bin_2 = BinPacking::Bin.new(500, 200)
      bin_2.insert!(BinPacking::Box.new(500, 200))
      html = BinPacking::Export.new([bin_1, bin_2]).to_html
      expect(html).to include(bin_1.label)
      expect(html).to include(bin_1.boxes.first.label)
      expect(html).to include(bin_2.label)
      expect(html).to include(bin_2.boxes.first.label)
    end

    it 'exports single empty bin' do
      bin_1 = BinPacking::Bin.new(10, 10)
      html = BinPacking::Export.new(bin_1).to_html
      expect(html).to include(bin_1.label)
    end

    it 'exports no bin' do
      html = BinPacking::Export.new([]).to_html
      expect(html).to include('<body>')
    end
  end
end

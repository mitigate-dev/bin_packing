module BinPacking
  class ExportBinding
    attr_reader :bins

    def initialize(bins, zoom)
      @bins = bins
      @zoom = zoom
    end

    def zoom(value)
      (value * @zoom).to_i
    end

    def get_binding
      binding
    end
  end
end

module BinPacking
  class Export
    def initialize(*bins)
      @bins = Array(bins)
      read_template
    end

    def to_html(options = {})
      @zoom = options[:zoom] || 1
      bins_html = render_bins
      html = @html_template % { bins: bins_html }
      html
    end

    private

    def read_template
      template_path = File.expand_path('../resources/export.html', __FILE__)
      template = File.read(template_path)
      @bin_template = extract_section!(template, 'bin')
      @box_template = extract_section!(template, 'box')
      @html_template = template
    end

    def extract_section!(template, tag_name)
      if template =~ /<#{tag_name}>(.+)<\/#{tag_name}>/m
        section = $1
        template.sub!(section, '')
        section
      else
        raise BinPacking::Error, "Section '#{tag_name}' not found in export template!"
      end
    end

    def render_bins
      html = ''
      @bins.each do |bin|
        boxes_html = render_boxes(bin.boxes)
        params = {
          label: bin.label,
          width: zoom(bin.width),
          height: zoom(bin.height),
          boxes: boxes_html
        }
        html << (@bin_template % params)
      end
      html
    end

    def render_boxes(boxes)
      html = ''
      boxes.each do |box|
        params = {
          label: box.label,
          width: zoom(box.width),
          height: zoom(box.height),
          x: zoom(box.x),
          y: zoom(box.y)
        }
        html << (@box_template % params)
      end
      html
    end

    def zoom(value)
      (value * @zoom).to_i
    end
  end
end

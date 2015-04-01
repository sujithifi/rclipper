module Rclipper

  class Vertex

    attr_accessor :x, :y, :next, :prev, :neighbor, :entry, :alpha, :intersect, :checked

    def initialize(vertex, alpha=0.0, intersect=false, entry=true, checked=false)
      @x, @y     = vertex.is_a?(Vertex) ? [vertex.x, vertex.y] : vertex.map(&:to_f)
      @entry     = entry
      @alpha     = alpha
      @intersect = intersect
      @checked   = checked
    end

    def is_inside?(polygon)
      winding_num = 0
      infinity    = Vertex.new([Float::INFINITY, @y])
      polygon.each do |v|
        winding_num +=1 if !v.intersect && Clipper::intersection(self, infinity, v, polygon.next(v.next))
      end
      ( winding_num % 2 ) != 0

    end

    def set_checked
      @checked = true
      @neighbor.set_checked if @neighbor && !@neighbor.checked
    end

  end

end
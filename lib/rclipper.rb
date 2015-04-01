# Based on Efficient clipping of arbitrary polygons by Günther Greiner and Kai Hormann
# Degeneracy fix by Erich L Foster and James Overfelt
# Also thanks to Helder Correia (https://github.com/helderco/univ-polyclip)

require "rclipper/vertex"
require "rclipper/polygon"
require "rclipper/version"

module Rclipper

  def intersection(s1, s2, c1, c2)
    den = (c2.y - c1.y) * (s2.x - s1.x) - (c2.x - c1.x) * (s2.y - s1.y)
    return nil if den.zero?

    us = ((c2.x - c1.x) * (s1.y - c1.y) - (c2.y - c1.y) * (s1.x - c1.x)) / den
    uc = ((s2.x - s1.x) * (s1.y - c1.y) - (s2.y - s1.y) * (s1.x - c1.x)) / den

    if (0 < us && us < 1) && (0 < uc && uc < 1)
      x = ( s1.x + us * (s2.x - s1.x) ).round(4)
      y = ( s1.y + us * (s2.y - s1.y) ).round(4)
      return [[x,y], us, uc]
    elsif ( (us == 0 || us == 1) && (0 <= uc && uc <= 1) ) || 
       ( (uc == 0 || uc == 1) && (0 <= us && us <= 1) )
       # Degeneracy case. Should work if treated as non-intersection
       return nil
     else
      return nil
    end
  end

  def find_origin(subj, clip)
    x, y = [], []
    subj.each do |s|
      x << s[0]
      y << s[1]
    end

    clip.each do |c|
      x << c[0]
      y << c[1]
    end

    x_min, x_max = x.min, x.max
    y_min, y_max = y.min, y.max

    width  = x_max - x_min
    height = y_max - y_min

    [-x_max / 2, -y_max /2, -(1.5 * width + 1.5 * height) / 2]

  end

  def clip_polygon(subj, clipp,oper=:clip)
    subject = Polygon.new
    clipper = Polygon.new
    subj.each  { |s| subject.add(Vertex.new(s)) }
    clipp.each { |c| clipper.add(Vertex.new(c)) }

    case oper
    when :clip
      subject.clip(clipper,true,true)
    when :union
      subject.clip(clipper,false,false)
    when :diff
      subject.clip(clipper,false,true)
    end

  end

  module_function :clip_polygon, :find_origin, :intersection

end

# USAGE:
#
# a = [[0,0], [100,0], [100,50], [0,50]]
# b = [[0,25], [20,100], [75,25], [100,50], [100,0], [0,50]]
#
# p Clipper::clip_polygon(a,b)

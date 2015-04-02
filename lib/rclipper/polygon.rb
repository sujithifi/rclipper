module Rclipper

  class Polygon

    attr_accessor :first

    def add(vertex)
      if @first
        nxt         = @first
        prv         = nxt.prev
        nxt.prev    = vertex
        vertex.next = nxt
        vertex.prev = prv
        prv.next    = vertex
      else
        @first      = vertex
        @first.next = vertex
        @first.prev = vertex   
      end
    end

    def insert(vertex, st, en)
      curr = st
      while curr != en && curr.alpha < vertex.alpha
        curr = curr.next
      end
      prev        = curr.prev
      vertex.next = curr
      vertex.prev = prev
      prev.next   = vertex
      curr.prev   = vertex
    end

    def next(v)
      c = v
      while c.intersect
        c = c.next
      end
      c
    end

    def next_poly
      @first.next_poly
    end

    def first_intersect
      each do |v|
        return v if v.intersect && !v.checked
      end
    end

    def points
      p = []
      each do |v|
        p << [v.x, v.y]
      end
      p
    end

    def unprocessed
      each do |v|
        return true if v.intersect && !v.checked
      end
      false
    end

   def clip(clip_poly,s_entry=true, c_entry=true)
      each do |s|
        next if s.intersect
        clip_poly.each do |c|
          next if c.intersect
          begin
            i, alpha_s, alpha_c = Rclipper::intersection( s, self.next(s.next), c, clip_poly.next(c.next) )
            next unless i
            i_s = Vertex.new(i, alpha_s, true, false)
            i_c = Vertex.new(i, alpha_c, true, false)
            
            i_s.neighbor = i_c
            i_c.neighbor = i_s

            self.insert(i_s, s, self.next(s.next))
            clip_poly.insert(i_c, c, clip_poly.next(c.next))

          rescue Exception=>e
            puts e.message
          end
        end
      end

      s_entry ^= @first.is_inside?(clip_poly)
      each do |s|
        if s.intersect 
          s.entry = s_entry
          s_entry = !s_entry
        end
      end

      c_entry ^= clip_poly.first.is_inside?(self)
      clip_poly.each do |c|
        if c.intersect
          c.entry = c_entry
          c_entry = !c_entry
        end
      end

      list = []
      while unprocessed
        curr    = first_intersect
        clipped = Polygon.new
        clipped.add(Vertex.new(curr))
        while true
          curr.set_checked
          if curr.entry
            while true
              curr = curr.next
              clipped.add(Vertex.new(curr))
              break if curr.intersect
            end
          else
            while true
              curr = curr.prev
              clipped.add(Vertex.new(curr))
              break if curr.intersect
            end
          end

          curr = curr.neighbor
          break if curr.checked
        end
        list << clipped.points
      end

      list << self.points if list.empty?

      list

    end

    def each
      s = @first
      while true
        yield s
        s = s.next
        return if s == @first
      end
    end

  end

end

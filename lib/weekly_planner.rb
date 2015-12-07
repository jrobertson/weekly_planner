#!/usr/bin/env ruby

# file: weekly_planner.rb

require 'date'
require 'dynarex'


class WeeklyPlanner
  
  attr_reader :to_s

  def initialize(filename='weekly-planner.txt', path: '.')
    
    @filename, @path = filename, path
    
    fpath = File.join(path, filename)
    @s = File.exists?(fpath) ? File.read(fpath) :  create()    
    @dx = create_dx(@s)
    
  end

  def dx()
    @dx
  end
  
  def save(filename=@filename)
    s = File.basename(filename) + "\n" + @s.lines[1..-1].join
    File.write File.join(@path, filename), s
  end
  
  def to_s()
    @s
  end

  private
  
  def create()
    
    d = DateTime.now

    def ordinal(n)
      n.to_s + ( (10...20).include?(n) ? 'th' : \
                      %w{ th st nd rd th th th th th th }[n % 10] )
    end

    a = []
    a <<  "%s, %s %s" % [Date::DAYNAMES[d.wday], ordinal(d.day), 
                                                Date::ABBR_MONTHNAMES[d.month]]
    a += (d+1).upto(d+6).map {|date|  Date::ABBR_DAYNAMES[date.wday] }

    a2 = a.map {|x| "%s\n%s" % [x, '-' * x.length]}
    title = File.basename(@filename)
    s = title + "\n" + "=" * title.length + "\n\n%s\n\n" % [a2.join("\n\n")]
  end
  
  def create_dx(s)
    
    rows = s.split(/.*(?=^[\w, ]+\n\-+)/)

    dx = Dynarex.new 'sections[title]/section(x)'

    rows.shift
    d = Date.parse(rows.first.lines.first.chomp)
    dx.title = "Weekly Planner (%s)" % (d).strftime("%d-%b-%Y")

    rows.each.with_index do |raw_x, i|
      
      a = raw_x.lines
      a.shift
      heading = "# %s\n" % (d + i).strftime("%d-%b-%Y")

      a.shift # removes the dashed line
      content = a.join
      dx.create({x: heading + content}, id: (d + i).strftime("%Y%m%d"))

    end
    
    return dx
    
  end
  
  def parse()
  end
end
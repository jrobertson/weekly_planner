#!/usr/bin/env ruby

# file: weekly_planner.rb

require 'date'
require 'dynarex'


class WeeklyPlanner
  
  attr_reader :to_s

  def initialize(filename='weekly-planner.txt', path: '.')
    
    @filename, @path = filename, path
    
    if File.exists? File.join(path, filename) then
      @to_s = File.read File.join(path, filename)
    else
      @to_s = create()
    end
  end

  def dx()
  end
  
  def save(filename=@filename)
    s = File.basename(filename) + "\n" + @to_s.lines[1..-1].join
    File.write File.join(@path, filename), s
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
    s = File.basename(@filename) + "\n==================\n\n%s\n\n" % 
                                                              [a2.join("\n\n")]
  end
  
  def parse()
  end
end

#!/usr/bin/env ruby

# file: weekly_planner.rb

require 'date'
require 'dynarex'
require 'fileutils'



class WeeklyPlanner
  
  attr_reader :to_s

  def initialize(filename='weekly-planner.txt', path: '.')
    
    @filename, @path = filename, path
    
    fpath = File.join(path, filename)
    
    if File.exists?(fpath) then
      
      s = File.read(fpath)
      @dx = import_to_dx(s)
      archive()         
      
      # purge any past dates
      while Date.parse(@dx.all.first.id, "%Y%m%d") != DateTime.now.to_date \
                                                      and @dx.all.length > 0 do
        @dx.all.first.delete
        
      end
      
      # new days to add?
      len = 7 - @dx.all.length
      
      if len > 0 then
        
        date = Date.strptime(@dx.all.last.id, "%Y%m%d") + 1
        
        len.times.with_index do |row, i|
          @dx.create({x: (date + i).strftime("# %d-%b-%Y\n\n")}, \
                                             id: (date + i).strftime("%Y%m%d"))
        end
        
      end
    
    else      
      @dx = new_dx
    end
    
  end

  def dx()
    @dx
  end
  
  def save(filename=@filename)
    
    s = File.basename(filename) + "\n" + dx_to_s(@dx).lines[1..-1].join
    File.write File.join(@path, filename), s
    
    archive()
    
  end
  
  def to_s()
    dx_to_s @dx
  end

  private
  
  def archive()
    
    # archive the weekly planner
    # e.g. weeklyplanner/2015/wp50.xml
    d = Date.strptime(@dx.all.first.id, "%Y%m%d")
    archive_path = File.join(@path, d.year.to_s)
    FileUtils.mkdir_p archive_path
    
    a = @dx.all.partition {|x| Date.strptime(x.id, "%Y%m%d").cweek == d.cweek }

    a.each do |rows|
      
      filename = "wp%s.xml" % Date.strptime(rows.first.id, "%Y%m%d").cweek
      filepath = File.join(archive_path, filename)
      
      if File.exists? filepath then
        
        dx = Dynarex.new filepath
        
        rows.each do |row|
          
          record = dx.find_by_id row.id
          
          if record then
            record.x = row.x unless record.x == row.x
          else
            dx.create row
          end
        end
        
        dx.sort_by! {|x| x.attributes[:id].to_i}
        dx.save filepath
        
      else
        
        dx = Dynarex.new 'sections[title]/section(x)'
        rows.each {|row| dx.create row }
        dx.save filepath        
         
      end
            
    end    
  end
  
  def import_to_dx(s)
    
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
      content = a.join.rstrip
      dx.create({x: heading + content}, id: (d + i).strftime("%Y%m%d"))

    end
    
    return dx
    
  end
  
  def dx_to_s(dx)

    def format_row(heading, content)
      content.prepend "\n\n" unless content.empty?
      "%s\n%s%s" % [heading, '-' * heading.length, content]
    end

    def ordinal(n)
      n.to_s + ( (10...20).include?(n) ? 'th' : \
                      %w{ th st nd rd th th th th th th }[n % 10] )
    end

    row1 = dx.all.first
    d = Date.strptime(row1.id, "%Y%m%d")
    heading =  "%s, %s %s" % [Date::DAYNAMES[d.wday], ordinal(d.day), 
                                                Date::ABBR_MONTHNAMES[d.month]]
    rows = [format_row(heading, row1.x.lines[1..-1].join.strip)]

    rows += dx.all[1..-1].map do |row|
      date = Date.strptime(row.id, "%Y%m%d")    
      dayname = Date::ABBR_DAYNAMES[date.wday]
      format_row dayname, row.x.lines[1..-1].join.strip
    end

    title = File.basename(@filename)
    title + "\n" + "=" * title.length + "\n\n%s\n\n" % [rows.join("\n\n")]

  end
  
  def new_dx()
    
    dx = Dynarex.new 'sections[title]/section(x)'

    d = DateTime.now
    dx.title = "Weekly Planner (%s)" % (d).strftime("%d-%b-%Y")

    (d).upto(d+6) do |date|  
      
      dx.create({x: date.strftime("# %d-%b-%Y\n\n")}, \
                                                   id: date.strftime("%Y%m%d"))
    end

    return dx
  end

end
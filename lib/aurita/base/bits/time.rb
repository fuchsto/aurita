
require 'date'
class Time
  def to_datetime
    # Convert seconds + microseconds into a fractional number of seconds
    seconds = sec + Rational(usec, 10**6)

    # Convert a UTC offset measured in minutes to one measured in a
    # fraction of a day.
    offset = Rational(utc_offset, 60 * 60 * 24)
    DateTime.new(year, month, day, hour, min, seconds, offset)
  end
end

class DateTime
  def to_date
    # Convert seconds + microseconds into a fractional number of seconds
    # seconds = sec + Rational(usec, 10**6)

    # Convert a UTC offset measured in minutes to one measured in a
    # fraction of a day.
    # offset = Rational(utc_offset, 60 * 60 * 24)
    Date.civil(year, month, day)
  end
end

class Integer
  def days
    return self * 24 * 60 * 60
  end
  def hours
    return self * 60 * 60
  end
  def minutes
    return self * 60
  end
  def seconds
    return self
  end
end

module Aurita

  class Datetime < Time

    def initialize(time_string=nil)

      if time_string then
      
        begin
          time_a = time_string.split(' ')
          date = time_a[0].split('-')
        rescue 
          begin
            date = time_string.split('-')
          rescue 
          end
        end

        if !time_a[1].nil? then
          time = time_a[1].split(':')
        end

        if time_a[1].nil? then
          begin
            @time = Time.local(date[0].to_i, date[1].to_i, date[2].to_i)
          rescue ::Exception => ignore
            @time = Time.now
          end
        else
          begin
            @time = Time.local(date[0].to_i, date[1].to_i, date[2].to_i, 
                               time[0].to_i, time[1].to_i, time[2].to_i)
          rescue ::Exception => ignore
            @time = Time.now
          end
        end

      else 

        @time = Time.now

      end
      
    end # def 

    def self.now(format=nil)
      format = "%m/%d/%Y - %H:%M:%S" if format.nil?
      format = "%Y-%m-%d %H:%M:%S"   if format == :sql
      format = "%Y%m%d%H%M%S"        if format == :raw
      format = "%d.%m.%Y H%:M%S"     if format == :eur
      return Time.now.strftime(format)
    end

    def string(format=nil)

      if @time.nil? then return '' end
      
      format = "%m/%d/%Y - %H:%M:%S" if format.nil?
      format = "%Y-%m-%d %H:%M:%S"   if format == :sql
      format = "%Y%m%d%H%M%S"        if format == :raw
      format = "%d.%m.%Y - %H:%M:%S" if format == :eur

      begin
        return @time.strftime(format)
      rescue
        return ''
      end
    end

    def to_s
      string(:sql)
    end

    def string_ago()
      Aurita::Datetime.time_ago(@time, :round => 6, :format => 'vor %d', :format_less => 'vor weniger als %d')
    end

    def +(seconds)
      @time += seconds
      return self
    end

    def -(seconds)
      @time -= seconds
      return self
    end

    # options
    # :start_date, sets the time to measure against, defaults to now
    # :later, changes the adjective and measures time forward
    # :round, sets the unit of measure 1 = seconds, 2 = minutes, 3 hours, 4 days, 5 weeks, 6 months, 7 years (yuck!)
    # :max_seconds, sets the maximimum practical number of seconds before just referring to the actual time
    # :date_format, used with <tt>to_formatted_s<tt>
    #
    # Modified usage, like: 
    #  puts time_ago(Time.now-100, :round => 5, :format => 'vor %d', :format_less => 'vor weniger als %d')
    #
    def self.time_ago(original, options = {})
      start_date = options.delete(:start_date) || Time.now
      later = options.delete(:later) || false
      round = options.delete(:round) || 7
      max_seconds = options.delete(:max_seconds) || 32556926
      date_format = options.delete(:date_format) || :default

      # array of time period chunks
      chunks = [
        [60 * 60 * 24 * 365 , "Jahr", 'Jahren'],
        [60 * 60 * 24 * 30 , "Monat", 'Monaten'],
        [60 * 60 * 24 * 7, "Woche", 'Wochen'],
        [60 * 60 * 24 , "Tag", 'Tagen'],
        [60 * 60 , "Stunde", 'Stunden'],
        [60 , "Minute", 'Minuten'],
        [1 , "Sekunde", 'Sekunden']
      ]

      if later
        since = original.to_i - start_date.to_i
      else
        since = start_date.to_i - original.to_i
      end
      time = []

      if since < max_seconds
        # Loop trough all the chunks
        totaltime = 0

        for chunk in chunks[0..round]
          seconds    = chunk[0]
          count = ((since - totaltime) / seconds).floor
          name       = chunk[1] if count == 1
          name       = chunk[2] if count > 1

          time << (count.to_s + ' ' + name) unless count == 0

          totaltime += count * seconds
        end

        if time.empty?
          options[:format_less].gsub('%d', '1 ' << chunks[round-1][1])
        else
          options[:format].gsub('%d',time[0..1].join(', '))
        end
      else
        ''
      end
    end

  end # class


end # module


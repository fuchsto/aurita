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
def time_ago(original, options = {})
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

#     time << pluralize(count, name) unless count == 0
      time << (count.to_s + ' ' + name) unless count == 0

      totaltime += count * seconds
    end

    if time.empty?
      options[:format_less].gsub('%d', '1 ' << chunks[round-1][1])
    else
#      "#{time.join(', ')} #{later ? 'later' : 'ago'}"
      options[:format].gsub('%d',time[0..1].join(', '))
    end
  else
    original.to_formatted_s(date_format)
  end
end


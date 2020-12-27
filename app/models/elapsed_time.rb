module ElapsedTime

  MINUTES_PER_HOUR = 60
  MINUTES_PER_DAY = 1440
  MINUTES_PER_WEEK = 10080
  MINUTES_PER_YEAR = 525600

  def simple_elapsed_time(date)
    minutes_elapsed = (Time.now - date) / 60
    elapsed = case minutes_elapsed
              when 0...MINUTES_PER_HOUR then "#{minutes_elapsed.round}m"
              when MINUTES_PER_HOUR...MINUTES_PER_DAY then "#{(minutes_elapsed / 60).round}h"
              when MINUTES_PER_DAY...MINUTES_PER_WEEK then "#{(minutes_elapsed / 60 / 24).round}d"
              when MINUTES_PER_WEEK...MINUTES_PER_YEAR then "#{(minutes_elapsed / 60 / 24 / 7).round}w"
              else "#{(minutes_elapsed / 60 / 24 / 365).round}y"
              end
  end
end
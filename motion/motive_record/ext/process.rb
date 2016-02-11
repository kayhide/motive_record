module Process
  CLOCK_REALTIME = :GETTIMEOFDAY_BASED_CLOCK_REALTIME

  def self.clock_gettime clock_id, unit = :float_second
    now = Time.now
    case unit
    when :float_second
      now.to_f
    when :float_millisecond
      now.to_f * 1000
    when :float_microsecond
      now.to_f * 1000_000
    when :float_nanosecond
      now.to_f * 1000_000_000
    when :second
      now.to_i
    when :millisecond
      now.to_i * 1000 + now.usec / 1000
    when :microsecond
      now.to_i * 1_000_000 + now.usec
    when :nanosecond
      now.to_i * 1_000_000_000 + now.nsec
    end
  end
end

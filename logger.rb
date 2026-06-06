module Logger
  LOG_FILE = "app.log"

  def log_info(message)
    write_log("info", message)
  end

  def log_warning(message)
    write_log("warning", message)
  end

  def log_error(message)
    write_log("error", message)
  end

  private

  def write_log(type, message)
    File.open(LOG_FILE, "a") do |file|
      file.puts "#{Time.now.iso8601} -- #{type} -- #{message}"
    end
  end
end
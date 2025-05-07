# frozen_string_literal: true

class CsvResponse
  def initialize(rows, headers, filename, response)
    @rows = rows
    @headers = headers
    @filename = filename
    @response = response
  end

  def send
    set_response_headers
    write_headers
    write_records
  ensure
    @response.stream.close
  end

  private

  def set_response_headers
    @response.headers.merge!(
      'Content-Type' => 'text/csv',
      'Content-Disposition' => "attachment; filename=\"#{@filename}\"",
      'X-Accel-Buffering' => 'no',
      'Cache-Control' => 'no-cache',
      'Last-Modified' => Time.current.httpdate
    )
    @response.headers.delete('Content-Length')
  end

  def write_headers
    @response.stream.write CSV.generate_line(@headers)
  end

  def write_records
    @rows.each do |row|
      @response.stream.write CSV.generate_line(row)
    end
  end
end

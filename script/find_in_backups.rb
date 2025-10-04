# frozen_string_literal: true

require_relative '../config/environment'
require 'optparse'
require 'date'
require 'json'

class BackupSearcher
  def initialize(search_from:, search_command:, search_to: Time.zone.today)
    @search_from = Date.parse(search_from.to_s)
    @search_to = Date.parse(search_to.to_s)
    @search_command = search_command
    @config = Rails.application.credentials.postgres_backups
  end

  # rubocop:disable Metrics/MethodLength
  def run
    puts "Searching for matches between #{@search_from} and #{@search_to}"
    puts "Search command: #{@search_command}"
    puts

    available_backups = fetch_available_backups
    if available_backups.empty?
      puts 'No backups found in the specified date range'
      return
    end

    puts "Found #{available_backups.length} backups in date range"

    latest_match = binary_search_for_latest_match(available_backups)

    if latest_match
      puts "\nLatest backup with matches: #{latest_match}"
    else
      puts "\nNo backups contain matches for the search command"
    end
  end

  private

  def fetch_available_backups
    credentials = aws_credentials_string

    # List all backups and filter by date range
    all_backups_json = `#{credentials} aws s3api list-objects-v2 --bucket #{@config[:aws_s3_bucket]} \
      --query 'Contents[].{Key:Key,LastModified:LastModified}' \
      --output json`.strip

    all_backups = JSON.parse(all_backups_json)

    # Filter backups by date range and extract dates
    date_pattern = /(\d{4}-\d{2}-\d{2})/
    filtered_dates = all_backups.filter_map do |backup|
      match = backup['Key'].match(date_pattern)
      if match
        backup_date = Date.parse(match[1])
        backup_date if backup_date.between?(@search_from, @search_to)
      end
    end

    filtered_dates.uniq.sort
  end

  def binary_search_for_latest_match(available_dates)
    left = 0
    right = available_dates.length - 1
    latest_match = nil

    while left <= right
      mid = (left + right) / 2
      test_date = available_dates[mid]

      puts "Testing backup from #{test_date}..."

      if backup_contains_matches?(test_date)
        puts "✓ Found matches in #{test_date}"
        latest_match = test_date
        left = mid + 1 # Search for later dates
      else
        puts "✗ No matches in #{test_date}"
        right = mid - 1 # Search for earlier dates
      end
    end

    latest_match
  end
  # rubocop:enable Metrics/MethodLength

  def backup_contains_matches?(date)
    # Use the existing rake task to fetch the backup
    system("DATE=#{date} bundle exec rake fetch_backup > /dev/null 2>&1")

    unless File.exist?('backup/export')
      puts "Failed to fetch backup for #{date}"
      return false
    end

    # Test if the search command finds matches
    search_result = system("pg_restore -f - backup/export 2>/dev/null | #{@search_command} > /dev/null 2>&1")

    # Clean up the backup
    system('rm -rf backup > /dev/null 2>&1')

    search_result
  end

  def aws_credentials_string
    "AWS_ACCESS_KEY_ID=#{@config[:aws_access_key_id]} AWS_SECRET_ACCESS_KEY=#{@config[:aws_secret_access_key]}"
  end
end

# Parse command line arguments
options = {}
OptionParser.new do |opts|
  opts.banner = <<~BANNER
    Usage: ruby script/find_in_backups.rb [options]

    Finds the most recent PostgreSQL backup containing matches for a given search command.
    Can be used to find when a specific record was last present in the database.

  BANNER

  opts.on('--from DATE', 'Start date for search (required, format: YYYY-MM-DD)') do |date|
    options[:search_from] = date
  end

  opts.on('--to DATE', 'End date for search (optional, defaults to today, format: YYYY-MM-DD)') do |date|
    options[:search_to] = date
  end

  opts.on('--command COMMAND', 'Search command to pipe pg_restore output to (required)') do |command|
    options[:search_command] = command
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

# Validate required arguments
if options[:search_from].nil? || options[:search_command].nil?
  puts 'Error: --from and --command are required'
  puts "Example: ruby script/find_in_backups.rb --from='2024-01-01' --command='rg \"\\d+\\s+PC62297\"'"
  exit 1
end

# Run the search
searcher = BackupSearcher.new(
  search_from: options[:search_from],
  search_to: options[:search_to] || Time.zone.today,
  search_command: options[:search_command]
)

searcher.run

# frozen_string_literal: true

require 'English'
require 'tempfile'

class HealthController < ApplicationController
  # Used to test that the error notification system is working
  # GET /fail
  def fail
    raise 'I should send an exception notification email'
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  # Check that we have a recent backup in the last 24 hours
  # GET /check_for_recent_backup
  def check_recent_backup
    config = Rails.application.credentials.postgres_backups
    aws_bucket = config[:aws_s3_bucket]
    aws_access_key_id = config[:aws_access_key_id]
    aws_secret_access_key = config[:aws_secret_access_key]
    Rails.logger.debug { "Checking for recent backup in #{aws_bucket}" }

    Tempfile.create do |s3_list|
      check_command = "AWS_ACCESS_KEY_ID=#{aws_access_key_id} " \
                      "AWS_SECRET_ACCESS_KEY=#{aws_secret_access_key} " \
                      'aws s3api list-objects-v2 ' \
                      "--bucket #{aws_bucket} " \
                      "--query 'Contents[?LastModified>=`#{24.hours.ago.iso8601}`].Key' " \
                      "--output json > #{s3_list.path}"
      Rails.logger.debug { "Running command: #{check_command}" }
      success = async_run(check_command)
      Rails.logger.debug { "Command success: #{success}" }
      render_down unless success

      result = JSON.parse(s3_list.read)
      Rails.logger.debug { "Result: #{result}" }
      if result.blank? || result.length != 1
        render_down
      else
        render_up
      end
    end
  rescue StandardError => e
    render_down
    raise e
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  # rubocop:disable Metrics/MethodLength
  def async_run(command)
    pid = Process.spawn(command)
    Rails.logger.debug { "Spawned process with PID: #{pid}" }
    begin
      Timeout.timeout(10) do
        Rails.logger.debug { "Waiting for process with PID: #{pid}" }
        Process.wait(pid)
        Rails.logger.debug do
          "Process with PID: #{pid} exited with status: #{$CHILD_STATUS}, success: #{$CHILD_STATUS.success?}"
        end

        $CHILD_STATUS.success?
      end
    rescue Timeout::Error
      Rails.logger.debug { "Timed out waiting for process with PID: #{pid}" }
      Process.kill('KILL', pid)
      Process.wait(pid)
      false
    end
  end
  # rubocop:enable Metrics/MethodLength

  def render_up
    render html: html_status(color: 'green')
  end

  def render_down
    render html: html_status(color: 'red'), status: :internal_server_error
  end

  # rubocop:disable Rails/OutputSafety
  def html_status(color:)
    %(<!DOCTYPE html><html><body style="background-color: #{color}"></body></html>).html_safe
  end
  # rubocop:enable Rails/OutputSafety
end

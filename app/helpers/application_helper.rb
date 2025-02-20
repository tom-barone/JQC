# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  # rubocop:disable Metrics/MethodLength
  def flash_with_links(*segments)
    safe_join(
      segments.map do |segment|
        case segment
        when String
          segment
        when Hash
          if segment['link_to'].present?
            link_to(segment['text'], segment['link_to'])
          else
            segment['text']
          end
        end
      end
    )
  end
  # rubocop:enable Metrics/MethodLength
end

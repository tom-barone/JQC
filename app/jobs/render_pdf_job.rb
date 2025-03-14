# frozen_string_literal: true

class RenderPdfJob < ApplicationJob
  queue_as :default

  def perform(html, host, protocol)
    FerrumPdf.browser(process_timeout: 10, browser_options: { 'no-sandbox': nil })
    result = FerrumPdf.render_pdf(
      html: html,
      host: host,
      protocol: protocol,
      pdf_options: pdf_render_options
    )
    FerrumPdf.quit
    result
  end

  private

  def pdf_render_options
    {
      landscape: true, # paper orientation
      scale: 0.6, # Scale of the webpage rendering
      paper_width: 8.3, # Paper width in inches
      paper_height: 11.7, # Paper height in inches
      margin_top: 1
    }
  end
end

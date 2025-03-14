# frozen_string_literal: true

module FerrumPdfExtension
  def quit
    @browser&.quit
    @browser = nil
  end
end

# Apply the monkey patch to the FerrumPdf module
FerrumPdf.singleton_class.prepend(FerrumPdfExtension)

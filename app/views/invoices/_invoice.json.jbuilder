json.extract! invoice, :id, :InvoiceNo, :Stage, :Fee, :GST, :DAC, :Lodgement, :InsLevy, :PercentInvoiced, :InvoiceDate, :Paid, :ApplicationID_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)

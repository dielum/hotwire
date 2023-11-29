class QuoteMailer < ApplicationMailer
  def new_quote
    quote_id = params[:quote]
    @quote = Quote.find(quote_id)
    mail(to: 'example@example.com', subject: 'New Quote')
  end
end

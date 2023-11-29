class QuoteMailer < ApplicationMailer
  def new_quote
    @quote = params[:quote]
    mail(to: 'example@example.com', subject: 'New Quote')
  end
end

module Stores
  class CallsController < ApplicationController
    def create
      render :layout => "empty"

      messages = [ "You just made a sale. Let's make it rain" ]
      @message = messages[rand(messages.count)]
    end

    def new
      @client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
      @account = @client.account
      @call = @account.calls.create({:from => '5866904041',
        :to => '5862914303', :url => store_calls_url })
      puts @message
      redirect_to store_calls_url
    end

    def index
    end

  end
end
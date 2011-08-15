module MessagesHelper
	def get_messages_by_sender(from)
    	messages = Message.find_by_from(from)
	end

	def count_messages_by_sender(from)
		get_messages_by_sender.count
	end

	def send_over_use_message(to)
		send_message('You have used all of your faxes on Faxzorz. Thanks for using the service.', to)
	end

	def send_message(message, to) 
		@account_sid	= ENV['TWILIO_ACCOUNT_SID'].to_s
		@auth_token		= ENV['TWILIO_AUTH_TOKEN'].to_s

		@client = Twilio::Rest::Client.new(@account_sid, @auth_token)

		@account = @client.account
		@message = @account.sms.messages.create({:from => '+14155992671', :to => to, :body => message})
		puts @message
	end
end

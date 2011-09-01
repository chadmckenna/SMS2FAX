class Message < ActiveRecord::Base

	def send_fax
		pamfaxr = PamFaxr.new :username => ENV['PAMFAXR_USERNAME'].to_s, 
		                      :password => ENV['PAMFAXR_SECRET'].to_s

		@recipient = get_recipient
		
		unless @recipient.eql? nil
		  self.Body.gsub!(/(\(\+[0-9]{11}\)\s)/, "")
      
		  #puts @recipient
		  #puts self.Body
		  #puts self.From
		   
		  # Create a new FaxJob
		  pamfaxr.create_fax_job
		   
		  # Add the cover sheet
		  covers = pamfaxr.list_available_covers
		  pamfaxr.set_cover(covers['Covers']['content'][1]['id'], self.Body)
		  
		  #puts self.Body
		  #puts @recipient
		   
		  # Add files
		  #pamfaxr.add_remote_file('https://s3.amazonaws.com/pamfax-test/Tropo.pdf')
		  #pamfaxr.add_file('examples/Tropo.pdf')
		   
		  # Add a recipient
		  #pamfaxr.add_recipient(@recipient)
		   
		  # Loop until the fax is ready to send
		  loop do
		    fax_state = pamfaxr.get_state
		    break if fax_state['FaxContainer']['state'] == 'ready_to_send'
		    sleep 5
		  end
		   
		  # Send the fax
		  result = pamfaxr.send_fax
		  #if result['result']['count'] > 0
		  	# For LULZ and Testing Purposes
		  	Message.send_fax_sent_message(self.From, @recipient)
		  #else
		  	#Message.send_fax_died_message(self.From, @recipient)
		  #end

		end
	end

	def get_recipient
		return self.Body.match(/((\+[0-9]{11}))/)
	end

	def self.get_messages_by_sender(from)
    	messages = Message.find(:all, :conditions => { :From => from })
	end

	def self.count_messages_by_sender(from)
		Message.get_messages_by_sender(from).count
	end

	def self.send_fax_sent_message(to, recipient)
		Message.send_message("We have successfully sent your fax to #{recipient}. Thanks for using Faxzorz.", to)
	end

	def self.send_fax_died_message(to, recipient)
		Message.send_message("We could not send your fax to #{recipient} for some reason. Try again laterz.", to)
	end

	def self.send_over_use_message(to)
		Message.send_message('You have used all of your faxes on Faxzorz. Thanks for using the service.', to)
	end

	def self.send_message(message, to) 
		require 'twilio-ruby'

		@account_sid	= ENV['TWILIO_ACCOUNT_SID'].to_s
		@auth_token		= ENV['TWILIO_AUTH_TOKEN'].to_s

		@client = Twilio::REST::Client.new(@account_sid, @auth_token)

		@account = @client.account
		@message = @account.sms.messages.create({:from => '+17205499985', :to => to, :body => message})
	end
end

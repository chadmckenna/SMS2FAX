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
		  
		  puts self.Body
		  puts @recipient
		   
		  # Add files
		  #pamfaxr.add_remote_file('https://s3.amazonaws.com/pamfax-test/Tropo.pdf')
		  #pamfaxr.add_file('examples/Tropo.pdf')
		   
		  # Add a recipient
		  pamfaxr.add_recipient(@recipient)
		   
		  # Loop until the fax is ready to send
		  loop do
		    fax_state = pamfaxr.get_state
		    break if fax_state['FaxContainer']['state'] == 'ready_to_send'
		    sleep 5
		  end
		   
		  # Send the fax
		  # SANDBOX MODE
		  #pamfaxr.send_fax
	  end
	end

	def get_recipient
		return self.Body.match(/((\+[0-9]{11}))/)
	end
end

class Message < ActiveRecord::Base
	def send_fax
		pamfaxr = PamFaxr.new :username => 'chad.mckenna', 
		                      :password => 'rosetta'

		@recipient = get_recipient

		#puts @recipient
		#puts self.Body
		#puts self.From
		 
		# Create a new FaxJob
		pamfaxr.create_fax_job
		 
		# Add the cover sheet
		covers = pamfaxr.list_available_covers
		pamfaxr.set_cover(covers['Covers']['content'][1]['id'], self.Body + ' @ ' + self.From)
		 
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
		pamfaxr.send_fax
		puts 'sent'
	end

	def get_recipient
		return self.Body.match(/((\+[0-9]{11}))/)
	end
end

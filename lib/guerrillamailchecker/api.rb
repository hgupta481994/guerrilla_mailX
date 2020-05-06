# require 'json'
# require 'fileutils'
require 'rest-client'
# require 'clipboard'
require 'rspec'

module GuerrillamailChecker
  class API
  	def self.get_email_address(email_id = nil)
	    response = send_request("POST", "https://api.guerrillamail.com/ajax.php?f=get_email_address")
	    sid_token= response[:body][:sid_token]
	    email_got = response[:body][:email_addr]
	    if email_id.present?
	      set_email_url = "https://api.guerrillamail.com/ajax.php?f=set_email_user&email_user=#{email_id}&lang=en&sid_token=#{sid_token}"
	      response = send_request("POST",set_email_url)
	      email_got = response[:body][:email_addr]
	    end
	    return {email: email_got, sid_token: sid_token}
	    
	  end

	  def self.verify_sent_email rspec: rspec, sid_token: nil, wait: 120, body: nil, subject: nil

	    get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=0&sid_token=#{sid_token}"
	    
	    start_minute = Time.now
	    while Time.now <= start_minute + wait.seconds
	      sleep(5)
	      response = send_request("POST",get_email_list_url)
	      mail_id = response[:body][:list][0][:mail_id]
	      fetch_email_url = "https://api.guerrillamail.com/ajax.php?f=fetch_email&email_id=#{mail_id}&sid_token=#{sid_token}"
	      email_response = send_request("POST",fetch_email_url)
	      break if (email_response[:body][:mail_subject]).include?(subject.to_s) 
	    end
      rspec.expect(email_response[:body][:mail_subject]).to rspec.include(subject)
	    if body.present?
	      rspec.expect(email_response[:body][:mail_body]).to rspec.include(body)
	    end
	    
	  end

	  def self.forget_email(sid_token)
	    forget_sid_url = "https://api.guerrillamail.com/ajax.php?f=forget_me&sid_token=#{sid_token}"
	    response = send_request("POST",forget_sid_url)
	  end
	end
end
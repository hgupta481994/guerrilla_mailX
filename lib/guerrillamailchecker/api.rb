# require 'json'
# require 'fileutils'
require 'rest-client'
require 'json'
require 'pry'
# require 'clipboard'
# require 'rspec'

module GuerrillamailChecker
  class API
  	def self.send_request(method, url, params={})
	    response = RestClient::Request.execute(method: method, url: url, payload: params)
	    if !response.nil? && response.code == 200
	      {code: response.code, body: response.body.nil? ? '' : JSON.parse(response.body, symbolize_names: true) }
	    else
	      {:code=>response.code, :body=>{:person=>{}}}
	    end 
	end

  	def self.get_email_address(email_id = nil)
	    response = send_request("POST", "https://api.guerrillamail.com/ajax.php?f=get_email_address")
	    sid_token= response[:body][:sid_token]
	    email_got = response[:body][:email_addr]
	    if !email_id.nil?
	      set_email_url = "https://api.guerrillamail.com/ajax.php?f=set_email_user&email_user=#{email_id}&lang=en&sid_token=#{sid_token}"
	      response = send_request("POST",set_email_url)
	      email_got = response[:body][:email_addr]
	    end
	    return {email: email_got, sid_token: sid_token}
	    
	  end

	  def self.verify_sent_email sid_token: nil, wait: 120, body: nil, subject: nil

	    get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=0&sid_token=#{sid_token}"
	    result =[]
	    start_minute = Time.now
	    while Time.now <= start_minute + wait
	      sleep(5)
	      response = send_request("POST",get_email_list_url)
	      mail_id = response[:body][:list][0][:mail_id]
	      fetch_email_url = "https://api.guerrillamail.com/ajax.php?f=fetch_email&email_id=#{mail_id}&sid_token=#{sid_token}"
	      email_response = send_request("POST",fetch_email_url)
	      break if (email_response[:body][:mail_subject]).include?(subject.to_s) 
	    end
	    if email_response[:body][:mail_subject].include?(subject)
	    	result << "subject present"
	    else
	    	result << "subject not present"
	    end
	    if !body.nil?
	    	if email_response[:body][:mail_body].include?(body)
		    	result << "body present"
		    else
		    	result << "body not present"
		    end
	    end
	    return result
	  end

	  def self.forget_email(sid_token)
	    forget_sid_url = "https://api.guerrillamail.com/ajax.php?f=forget_me&sid_token=#{sid_token}"
	    response = send_request("POST",forget_sid_url)
	  end
	end
end
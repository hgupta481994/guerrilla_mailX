# require 'json'
# require 'fileutils'
require 'rest-client'
require 'json'
require 'date'
require 'rainbow'
require 'active_support'
require 'active_support/core_ext'

require 'pry'
# require 'clipboard'
# require 'rspec'

module Guerrilla
	def self.get_email_address(email_id = nil)
		response = send_request("POST", "https://api.guerrillamail.com/ajax.php?f=get_email_address")
	  sid_token = response[:body][:sid_token]
	
    if email_id.present?
			set_email_url = "https://api.guerrillamail.com/ajax.php?f=set_email_user&email_user=#{email_id}&lang=en&sid_token=#{sid_token}"
			response = send_request("POST",set_email_url)
			
	    	# site_id = response[:body][:site_id]
	    	# site = response[:body][:site]
	  end
	  email_got = response[:body][:email_addr]
		alias_id  = response[:body][:alias]
		timestamp = response[:body][:email_timestamp]
  	time      = Time.at(timestamp).to_datetime.to_s
    valid_till = Time.at(timestamp+3600).to_datetime.to_s
    return {email: email_got, sid_token: sid_token, time: time, alias_id: alias_id, valid_till: valid_till}
	end

  def self.verify_last_sent_mail sid_token: nil, wait: 120, body: nil, subject: nil

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
    if body.present?
    	if email_response[:body][:mail_body].include?(body)
	    	result << "body present"
	    else
	    	result << "body not present"
	    end
    end
    return result
  end

  def self.verify_mail sid_token: nil, email_id: nil, offset: nil, wait: 120, body: nil, subject: nil

    if !email_id.present?
      if offset.present?
        get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=#{offset}&sid_token=#{sid_token}"
      else
        get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=0&sid_token=#{sid_token}"
      end
    end

    result =[]
    start_minute = Time.now
    while Time.now <= start_minute + wait
      sleep(5)
      if !email_id.present?
        response = send_request("POST",get_email_list_url)
        mail_id = response[:body][:list][0][:mail_id]
      else
        mail_id = email_id
      end
      fetch_email_url = "https://api.guerrillamail.com/ajax.php?f=fetch_email&email_id=#{mail_id}&sid_token=#{sid_token}"
      email_response = send_request("POST",fetch_email_url)
      break if (email_response[:body][:mail_subject]).include?(subject.to_s) 
    end
    if email_response[:body][:mail_subject].include?(subject)
      result << "subject present"
    else
      result << "subject not present"
    end
    if body.present?
      if email_response[:body][:mail_body].include?(body)
        result << "body present"
      else
        result << "body not present"
      end
    end
    return result
  end

  def self.check_email(sid_token, seq = 0)
  	check_email_url = "https://api.guerrillamail.com/ajax.php?f=check_email&seq=#{seq}&sid_token=#{sid_token}"
  	response = send_request("POST",check_email_url)
  	return response
  end

  def self.get_email_list(sid_token: nil, offset: 0, seq: 0)
  	get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=#{offset}&seq=#{seq}&sid_token=#{sid_token}"
  	response = send_request("POST",get_email_list_url)
  	return response
  end

  def self.fetch_email(sid_token: nil, email_id: nil)
    fetch_email_url = "https://api.guerrillamail.com/ajax.php?f=fetch_email&sid_token=#{sid_token}&email_id=#{email_id}"
    response = send_request("POST",fetch_email_url)
  end

	def self.forget_me(sid_token: nil, email_addr: nil)
		forget_sid_url = "https://api.guerrillamail.com/ajax.php?f=forget_me&sid_token=#{sid_token}&email_addr=#{email_addr}"
		response = send_request("POST",forget_sid_url)
	end

  def self.del_email(sid_token: nil, email_ids: nil)
    email_s = ""
    if email_ids.present?
      email_ids.each do |e|
      email_s += "&email_ids[]=#{e}"  
    end
    del_email_url = "https://api.guerrillamail.com/ajax.php?f=del_email&sid_token=#{sid_token}#{email_s}"
    response = send_request("POST",del_email_url)
  end

  def self.get_older_list(sid_token: nil, seq: nil, limit: nil)
    get_older_list_url = "https://api.guerrillamail.com/ajax.php?f=get_older_list&sid_token=#{sid_token}&seq=#{seq}&limit=#{limit}"
    response = send_request("POST",get_older_list_url)
  end

	private
  	def self.send_request(method, url, params={})
	    response = RestClient::Request.execute(method: method, url: url, payload: params)
	    if response.present? && response.code == 200
	      {code: response.code, body: response.body.blank? ? '' : JSON.parse(response.body, symbolize_names: true) }
	    else
	      {:code=>response.code, :body=>{:person=>{}}}
	    end 
		end
end
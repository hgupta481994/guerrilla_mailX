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

class Guerrilla
  @sid_token
  @email
  @time
  @timestamp
  @alias_id
  @valid_till


  attr_accessor :sid_token, :email, :time, :timestamp, :alias_id, :valid_till

  def initialize(email_id = nil, sid_token: nil)
    if !sid_token.present?
      response = send_request("POST", "https://api.guerrillamail.com/ajax.php?f=get_email_address")
      @sid_token = sid_token = response[:body][:sid_token]
    else
      @sid_token = sid_token
    end
  
    if email_id.present?
      set_email_url = "https://api.guerrillamail.com/ajax.php?f=set_email_user&email_user=#{email_id}&lang=en&sid_token=#{sid_token}"
      response = send_request("POST",set_email_url)
        # site_id = response[:body][:site_id]
        # site = response[:body][:site]
    end
    @email = response[:body][:email_addr]
    @alias_id  = response[:body][:alias]
    @timestamp = response[:body][:email_timestamp]
    @time      = Time.at(timestamp).to_datetime.to_s
    @valid_till = Time.at(timestamp+3600).to_datetime.to_s
  end

	def self.get_email_address
		response = send_request("POST", "https://api.guerrillamail.com/ajax.php?f=get_email_address")
  end

  def set_email_user(sid_token: nil, email_user: nil, lang: 'en', site: nil)
    if !sid_token.present?
      sid_token = @sid_token
    end
    set_email_url = "https://api.guerrillamail.com/ajax.php?f=set_email_user&email_user=#{email_user}&lang=#{lang}&sid_token=#{sid_token}&site=#{site}"
    response = send_request("POST",set_email_url)
  end

  def verify_last_sent_mail sid_token: nil, wait: 120, body: nil, subject: nil
    if !subject.present?
      return "ATTRIBUTE REQUIRED: No subject given"
    end

    if !sid_token.present?
      sid_token = @sid_token
    end
    get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=0&sid_token=#{sid_token}"
    result = {}
    start_minute = Time.now
    while Time.now <= start_minute + wait
      sleep(5)
      response = send_request("POST",get_email_list_url)
      return "No Mail Present" if response[:body][:list][0] == nil
      mail_id = response[:body][:list][0][:mail_id]
      fetch_email_url = "https://api.guerrillamail.com/ajax.php?f=fetch_email&email_id=#{mail_id}&sid_token=#{sid_token}"
      email_response = send_request("POST",fetch_email_url)
      break if (email_response[:body][:mail_subject]).include?(subject.to_s) 
    end
    if email_response[:body][:mail_subject].include?(subject)
    	result[:subject] = true
    else
      result[:subject] = false
    end
    if body.present?
    	if email_response[:body][:mail_body].include?(body)
        result[:body] = true
	    else
        result[:body] = false
	    end
    end
    return result
  end

  def verify_mail sid_token: nil, email_id: nil, offset: nil, wait: 120, body: nil, subject: nil
    if !subject.present?
      return "ATTRIBUTE REQUIRED: No subject given"
    end
    
    if !sid_token.present?
      sid_token = @sid_token
    end

    if !email_id.present?
      if offset.present?
        get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=#{offset}&sid_token=#{sid_token}"
      else
        get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=0&sid_token=#{sid_token}"
      end
    end

    result ={}
    start_minute = Time.now
    while Time.now <= start_minute + wait
      sleep(5)
      if !email_id.present?
        response = send_request("POST",get_email_list_url)
        return "No Mail Present" if response[:body][:list][0] == nil
        mail_id = response[:body][:list][0][:mail_id]
      else
        mail_id = email_id
      end
      fetch_email_url = "https://api.guerrillamail.com/ajax.php?f=fetch_email&email_id=#{mail_id}&sid_token=#{sid_token}"
      email_response = send_request("POST",fetch_email_url)
      break if (email_response[:body][:mail_subject]).include?(subject.to_s) 
    end
    if email_response[:body][:mail_subject].include?(subject)
      result[:subject] = true
    else
      result[:subject] = false
    end
    if body.present?
      if email_response[:body][:mail_body].include?(body)
        result[:body] = true
      else
        result[:body] = false
      end
    end
    return result
  end

  def check_email(seq: 0, sid_token: nil)
    if !sid_token.present?
      sid_token = @sid_token
    end
  	check_email_url = "https://api.guerrillamail.com/ajax.php?f=check_email&seq=#{seq}&sid_token=#{sid_token}"
  	response = send_request("POST",check_email_url)
  	return response
  end

  def get_email_list(sid_token: nil, offset: 0, seq: 0)
    if !sid_token.present?
      sid_token = @sid_token
    end
  	get_email_list_url = "https://api.guerrillamail.com/ajax.php?f=get_email_list&offset=#{offset}&seq=#{seq}&sid_token=#{sid_token}"
  	response = send_request("POST",get_email_list_url)
  	return response
  end

  def fetch_email(sid_token: nil, mail_id: nil)
    if !mail_id.present?
      return "ATTRIBUTE REQUIRED: No mail_id given"
    end
    if !sid_token.present?
      sid_token = @sid_token
    end
    fetch_email_url = "https://api.guerrillamail.com/ajax.php?f=fetch_email&sid_token=#{sid_token}&email_id=#{mail_id}"
    response = send_request("POST",fetch_email_url)
  end

	def forget_me(sid_token: nil, email_addr: nil)
    if !sid_token.present?
      sid_token = @sid_token
    end
		forget_sid_url = "https://api.guerrillamail.com/ajax.php?f=forget_me&sid_token=#{sid_token}&email_addr=#{email_addr}"
		response = send_request("POST",forget_sid_url)
	end

  def del_email(sid_token: nil, email_ids: nil)
    if !sid_token.present?
      sid_token = @sid_token
    end
    email_s = ""
    if email_ids.present?
      email_ids.each do |e|
        email_s += "&email_ids[]=#{e}"  
      end
    end
    del_email_url = "https://api.guerrillamail.com/ajax.php?f=del_email&sid_token=#{sid_token}#{email_s}"
    response = send_request("POST",del_email_url)
  end

  def get_older_list(sid_token: nil, seq: nil, limit: nil)
    if !sid_token.present?
      sid_token = @sid_token
    end
    get_older_list_url = "https://api.guerrillamail.com/ajax.php?f=get_older_list&sid_token=#{sid_token}&seq=#{seq}&limit=#{limit}"
    response = send_request("POST",get_older_list_url)
  end

	private
  	def send_request(method, url, params={})
	    response = RestClient::Request.execute(method: method, url: url, payload: params)
	    if response.present? && response.code == 200
	      {code: response.code, body: response.body.blank? ? '' : JSON.parse(response.body, symbolize_names: true) }
	    else
	      {:code=>response.code, :body=>{:person=>{}}}
	    end 
		end
end
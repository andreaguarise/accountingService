######################################################################
#
# File: auth_tkt.rb
# Developed by: MESO Web Scapes, Sascha Hanssen
# www.meso.net/auth_tkt_rails | hanssen@meso.net
# Date: 2008-04-29
#
######################################################################

######################################################################
#
# This file defines functions to generate cookie tickets compatible
# with the "mod_auth_tkt" apache module.
#
# Save this file to your RailsApplication/lib folder.
# Include functionallity with "include AuthTkt" into your controller.
#
######################################################################

module AuthTkt
  # set path to auth_tkt config file, where TKTAuthSecret is set
  SECRET_KEY_FILE = "/tmp/auth_tkt.conf";

  # set root domain to be able to single sign on (SSO)
  # (access all subdomains with one valid ticket)
  DOMAIN = ".infn.it"

  # sets the auth_tkt cookie, returns the signed cookie string
  def set_auth_tkt_cookie(options)
    # get signed cookie string
    tkt_hash = get_tkt_hash(options)

    cookie_data = { :value => tkt_hash }

    # set domain for cookie, if wanted
    cookie_data[:domain] = options[:domain] if options[:domain]

    # store data into cookie
    cookies[:auth_tkt] = cookie_data

    # return signed cookie
    return tkt_hash
  end

  # returns a string that contains the signed cookie content
  def get_tkt_hash(user_options)
    options = { :user       => '',
                :token_list => '',
                :user_data  => '',
                :encode     => false,
                :ignore_ip  => false }.merge(user_options)

    # set timestamp and binary string for timestamp and ip packed together
    timestamp  = Time.now.to_i
    ip_address = options[:ignore_ip] ? '0.0.0.0' : remote_ip
    ip_timestamp = [ip2long(ip_address), timestamp].pack("NN")

    # creating the cookie signature
    digest0 = Digest::MD5.hexdigest(ip_timestamp + get_secret_key + options[:user] +
                                    "\0" + options[:token_list] + "\0" + options[:user_data])

    digest  = Digest::MD5.hexdigest(digest0 + get_secret_key)

    # concatenating signature, timestamp and payload
    cookie = digest + timestamp.to_s(16) + options[:user] + '!' +
             options[:token_list] + '!' + options[:user_data]

    # base64 encode cookie, if needed
    if options[:encode]
      require 'base64'
      cookie = Base64.encode64(cookie).gsub("\n", '').strip
    end

    return cookie
  end

  # returns forward ip address if it was set by apache
  # or user ip address otherwise
  def remote_ip
    return request.env['HTTP_X_FORWARDED_FOR'] if request.env['HTTP_X_FORWARDED_FOR']
    return request.remote_ip
  end
  
  # returns token list previously saved in auth_tkt cookie
  def get_auth_tkt_token_list
    cookie_decoded = Base64.decode64(cookies[:auth_tkt])
    return cookie_decoded.split('!')[1]
  end

  # returns user data previously saved in auth_tkt cookie
  def get_auth_tkt_user_data
    cookie_decoded = Base64.decode64(cookies[:auth_tkt])
    return cookie_decoded.split('!')[2]
  end

  # destroys the auth_tkt, to log an user out
  def destroy_auth_tkt_cookie
    # reset ticket value of cookie, to log out even if deleting cookie fails
    cookies[:auth_tkt] = { :value => '', :expire => Time.at(0), :domain => DOMAIN }
    cookies.delete :auth_tkt
  end

  # returns the shared secret string used to sign the cookie
  # read from the scret key file, returns empty string on errors
  def get_secret_key
    secret_key = ''
    return '' unless File.file? SECRET_KEY_FILE
    open(SECRET_KEY_FILE) do |file|
      file.each do |line|
        if line.include? 'TKTAuthSecret'
          secret_key = line.gsub('TKTAuthSecret', '').strip.gsub("\"", '')
          break
        end
      end
    end
    secret_key
  end

  # function adapted according to php: generates an IPv4 Internet network address
  # from its Internet standard format (dotted string) representation.
  def ip2long(ip)
    long = 0
    ip.split( /\./ ).reverse.each_with_index do |x, i|
      long += x.to_i << ( i * 8 )
    end
    long
  end
end


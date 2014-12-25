#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module LibMail

  require 'mail'

  # -----------------------------------------------------------------------------------------------
  #
  # simple SMTP implementation using the ruby mail library
  #
  class SMTP
    def initialize

      @mail = Mail.new

    end

    def set_delivery_options(address, port, domain, user_name, password, authentication, enable_starttls_auto)

      @mail.delivery_method :smtp, {
        :address => address,
        :port => port,
        :domain => domain,
        :user_name => user_name,
        :password => password,
        :authentication => authentication,
        :enable_starttls_auto => enable_starttls_auto
      }

    end

    def set_header(to, from, subject)

      @mail[:to] = to
      @mail[:from] = from
      @mail[:subject] = subject

    end

    def set_body(body)

      @mail[:body] = body

    end

    def attach_file(file)

      @mail.add_file(file)

    end

    def send_mail

      @mail.deliver!

    end

  end

  # -----------------------------------------------------------------------------------------------
  #
  # placeholder POP3 implementation using the ruby mail library
  #
  module POP3
  end

end

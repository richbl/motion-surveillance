#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

# ----------------------------------------------------------------------------
# email configuration file
#
module MotionMailConfig
  # ---------------------------------------------------------------------------
  # enable (1) or disable (0) application logging
  #
  # NOTE: passing in 2 sets logging to STDOUT
  #
  LOGGING = 0

  # ----------------------------------------------------------------------------
  # logging filename
  #
  # ignored if LOGGING == 0
  #
  LOG_FILENAME = 'motion_mail.log'.freeze

  # ----------------------------------------------------------------------------
  # location of logfile (full path)
  # by default, this is in the motion_mail folder (e.g.,
  # /etc/motion_surveillance/motion_mail)
  #
  # ignored if LOGGING == 0
  #
  LOG_LOCATION = File.expand_path(File.dirname(__FILE__)).freeze

  # ----------------------------------------------------------------------------
  # email sender
  #
  EMAIL_FROM = 'motion@businesslearninginc.com'.freeze

  # ----------------------------------------------------------------------------
  # email recipient
  #
  EMAIL_TO = 'user@gmail.com'.freeze

  # ----------------------------------------------------------------------------
  # email body
  #
  # NOTE that reserved words use the syntax !ALLCAPS and are replaced in the
  # application
  #
  EMAIL_BODY = 'Motion detected an event of importance. The event (#!EVENT) '\
  'shows !PIXELS pixels changed, and was captured by Camera #!CAMERA.'.freeze

  # ----------------------------------------------------------------------------
  # mail (smtp) configuration details
  #
  # NOTE that these default values are typical of a standard gmail.com account
  # configuration
  #
  SMTP_ADDRESS = 'smtp.gmail.com'.freeze
  SMTP_PORT = '587'.freeze
  SMTP_DOMAIN = 'localhost'.freeze
  SMTP_USERNAME = 'user'.freeze
  SMTP_PASSWORD = 'password'.freeze
  SMTP_AUTHENTICATION = 'plain'.freeze
  SMTP_ENABLE_STARTTLS_AUTO = 'true'.freeze
end

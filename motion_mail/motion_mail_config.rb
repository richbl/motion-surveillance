#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module MotionMailConfig

  # -----------------------------------------------------------------------------------------------
  #
  # enable (1) or disable (0) application logging
  #
  LOGGING = 0

  # -----------------------------------------------------------------------------------------------
  #
  # logging filename
  #
  # ignored if LOGGING == 0
  #
  LOG_FILENAME = "motion_mail.log"

  # -----------------------------------------------------------------------------------------------
  #
  # location of logfile (full path)
  # by default, this is in the motion_mail folder (e.g., /etc/motion_surveillance/motion_mail)
  #
  # ignored if LOGGING == 0
  #
  LOG_LOCATION = File.expand_path(File.dirname(__FILE__))

  # -----------------------------------------------------------------------------------------------
  #
  # email sender
  #
  EMAIL_FROM = "motion@businesslearninginc.com"

  # -----------------------------------------------------------------------------------------------
  #
  # email recipient
  #
  EMAIL_TO = "user@gmail.com"

  # -----------------------------------------------------------------------------------------------
  #
  # email body
  #
  # NOTE that reserved words use the syntax !ALLCAPS and are replaced in the application
  #
  EMAIL_BODY = "Motion detected an event of importance. The event (#!EVENT) shows !PIXELS pixels changed, and was captured by Camera #!CAMERA."

  # -----------------------------------------------------------------------------------------------
  #
  # mail (smtp) configuration details
  #
  # NOTE that these default values are typical of a standard gmail.com account configuration
  #
  SMTP_ADDRESS = "smtp.gmail.com"
  SMTP_PORT = "587"
  SMTP_DOMAIN = "localhost"
  SMTP_USERNAME = "user"
  SMTP_PASSWORD = "password"
  SMTP_AUTHENTICATION = "plain"
  SMTP_ENABLE_STARTTLS_AUTO = "true"

end

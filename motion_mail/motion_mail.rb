#
# Copyright (C) 2014 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

class MotionMail

  require 'mail'
  require 'time'
  require 'logger'
  require 'pathname'

  require_relative 'lib_mail'
  require_relative 'mail_config'

  # -----------------------------------------------------------------------------------------------
  #
  # self.get_event_details(media_filename) creates the following event details based on
  # media_filename:
  #
  #   event_number - Motion-generated event number
  #   event_date - Motion-generated event datetime
  #
  # NOTE that this method assumes that media_filename follows the default Motion file-naming
  # convention of %v-%Y%m%d%H%M%S (for movies) or %v-%Y%m%d%H%M%S-%q (for pictures), where:
  #
  #   %v - Motion-generated event number
  #   %Y%m%d%H%M%S - ISO 8601 date, with hours, minutes, seconds notion
  #   %q - frame number (value ignored)
  #

  def self.get_event_details(media_filename)

    event_number, t = File.basename(media_filename).split(/-/)
    datetime=Time.new(t[0..3], t[4..5], t[6..7], t[8..9], t[10..11], t[12..13])

    event_date = datetime.strftime("%Y-%m-%d at %T")
    return event_number, event_date

  end

  # -----------------------------------------------------------------------------------------------
  #
  # self.create_logfile() creates the application log file
  #
  # see logger documentation for logfile management options
  #
  # NOTE: this log file is recreated whenever >50MB in size
  #

  def self.create_logfile

    if MailConfig::LOGGING.eql? 1

      $LOGGING = 1
      $LOG = Logger.new(File.expand_path(File.dirname(__FILE__)) + '/motion_mail.log', 0, 50 * 1024 * 1024)

    else

      $LOGGING = 0

    end

  end

  # -----------------------------------------------------------------------------------------------
  #
  # self.parse_event creates an event by parsing the following command line arguments passed in
  # via the on_picture_save or the on_movie_end command:
  #
  #  ARGV[0] pixels detected
  #  ARGV[1] media filename
  #  ARGV[2] device (camera) number
  #

  def self.parse_event

    if ARGV.count != 3 then

      if $LOGGING
        $LOG.error "Missing arguments passed. Exiting."
      end

      exit 1

    else

      pixels_detected = ARGV[0]
      media_filename = ARGV[1]

      if !File.exist?(media_filename)

        if $LOGGING
          $LOG.error "Media filename argument (" + media_filename +  ") does not exist. Exiting."
        end

        exit 1

      end

      camera_number = ARGV[2]

      # given media_filename, parse for event details
      #
      event_number, event_date = get_event_details(media_filename)

      if $LOGGING
        $LOG.info "Arguments passed into routine are " + ARGV.inspect
      end

    end

    event_details = {:number => event_number, :date => event_date, :camera_number => camera_number, :pixels_detected => pixels_detected}
    event_media = {:media => media_filename}

    return event_details, event_media

  end

  # -----------------------------------------------------------------------------------------------
  #
  # self.generate_smtp_email(event_details, event_media) generates and mails an smtp
  # email
  #
  # see mail documentation for mail management options (e.g., POP3)
  #

  def self.generate_smtp_email(event_details, event_media)

    mail = LibMail::SMTP.new

    # assign SMTP values
    #
    mail.set_delivery_options(
      MailConfig::SMTP_ADDRESS,
      MailConfig::SMTP_PORT.to_i,
      MailConfig::SMTP_DOMAIN,
      MailConfig::SMTP_USERNAME,
      MailConfig::SMTP_PASSWORD,
      MailConfig::SMTP_AUTHENTICATION,
      MailConfig::SMTP_ENABLE_STARTTLS_AUTO
    )

    # generate email header
    #
    mail.set_header(
      MailConfig::EMAIL_TO,
      MailConfig::EMAIL_FROM,
      'Motion Detected on Camera #' + event_details[:camera_number] + " at " + event_details[:date]
    )

    # attach media to email
    #
    mail.attach_file(event_media[:media])

    # perform string replace on email body and include body in email
    #
    replacement_string = {
      "!EVENT" => event_details[:number],
      "!PIXELS" => event_details[:pixels_detected],
      "!CAMERA" => event_details[:camera_number]
    }

    replacement_string.each { |k, v| MailConfig::EMAIL_BODY.sub!(k, v)}

    mail.set_body(MailConfig::EMAIL_BODY)
    mail.send_mail

    if $LOGGING
      $LOG.info "Email sent to " + MailConfig::EMAIL_TO + "."
    end

  end

  # -----------------------------------------------------------------------------------------------

  create_logfile
  event_details, event_media = parse_event
  generate_smtp_email(event_details, event_media)

end

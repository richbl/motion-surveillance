#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

require 'mail'
require 'time'
require 'logger'
require 'pathname'

require_relative '../lib/lib_mail'
require_relative '../lib/lib_log'
require_relative 'motion_mail_config'

class MotionMail

  # -----------------------------------------------------------------------------------------------
  #
  # self.get_event_details(media_filename) creates the following event details based on
  # media_filename:
  #
  #   event_number - Motion-generated event number
  #   event_date - Motion-generated event datetime
  #
  # NOTE: this method assumes that media_filename follows the default Motion file-naming
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
  # self.parse_event creates an event by parsing the following command line arguments passed in
  # via the on_picture_save or the on_movie_end command:
  #
  #  ARGV[0] pixels detected
  #  ARGV[1] media filename
  #  ARGV[2] device (camera) number
  #
  def self.parse_event

    if ARGV.count != 3 then

      if $LOG
        $LOG.error "Missing arguments passed. Exiting."
      end

      exit 1

    else

      pixels_detected = ARGV[0]
      media_filename = ARGV[1]

      if !File.exist?(media_filename)

        if $LOG
          $LOG.error "Media filename argument (" + media_filename +  ") does not exist. Exiting."
        end

        exit 1

      end

      camera_number = ARGV[2]

      # given media_filename, parse for event details
      #
      event_number, event_date = get_event_details(media_filename)

      if $LOG
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
      MotionMailConfig::SMTP_ADDRESS,
      MotionMailConfig::SMTP_PORT.to_i,
      MotionMailConfig::SMTP_DOMAIN,
      MotionMailConfig::SMTP_USERNAME,
      MotionMailConfig::SMTP_PASSWORD,
      MotionMailConfig::SMTP_AUTHENTICATION,
      MotionMailConfig::SMTP_ENABLE_STARTTLS_AUTO
    )

    # generate email header
    #
    mail.set_header(
      MotionMailConfig::EMAIL_TO,
      MotionMailConfig::EMAIL_FROM,
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

    replacement_string.each { |k, v| MotionMailConfig::EMAIL_BODY.sub!(k, v)}

    mail.set_body(MotionMailConfig::EMAIL_BODY)
    mail.send_mail

    if $LOG
      $LOG.info "Email sent to " + MotionMailConfig::EMAIL_TO + "."
    end

  end

  # -----------------------------------------------------------------------------------------------

  LibLog::create_logfile(MotionMailConfig::LOGGING, MotionMailConfig::LOG_LOCATION, MotionMailConfig::LOG_FILENAME)

  event_details, event_media = parse_event
  generate_smtp_email(event_details, event_media)

end

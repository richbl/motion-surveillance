#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

require 'mail'
require 'time'
require 'pathname'

require_relative '../lib/lib_mail'
require_relative '../lib/lib_log'
require_relative 'motion_mail_config'

include LibLog

# ----------------------------------------------------------------------------
# email methods
#
class MotionMail
  # ----------------------------------------------------------------------------
  # self.get_event_details(media_filename) creates the following event details
  # based on media_filename:
  #
  #   event_number - Motion-generated event number
  #   event_date - Motion-generated event datetime
  #
  # NOTE: this method assumes that media_filename follows the default Motion
  # file-naming convention of %v-%Y%m%d%H%M%S (for movies) or %v-%Y%m%d%H%M%S-%q
  # (for pictures), where:
  #
  #   %v - Motion-generated event number
  #   %Y%m%d%H%M%S - ISO 8601 date, with hours, minutes, seconds notion
  #   %q - frame number (value ignored)
  #
  def self.get_event_details(media_filename)
    event_number, t = File.basename(media_filename).split(/-/)
    datetime = Time.new(t[0..3], t[4..5], t[6..7], t[8..9], t[10..11],
                        t[12..13])

    event_date = datetime.strftime('%Y-%m-%d at %T')
    [event_number, event_date]
  end

  # ---------------------------------------------------------------------------
  # simple logging wrapper
  #
  def self.logging(type, message)
    return if MotionMailConfig::LOGGING.zero?

    case type
    when 'info'
      logger.info message
    when 'warn'
      logger.warn message
    when 'error'
      logger.error message
    end
  end

  # ----------------------------------------------------------------------------
  # check args passed in
  #
  def self.check_args
    if ARGV.count != 3
      logging('error', 'Missing arguments passed. Exiting.')
      exit 1
    end

    unless File.exist?(ARGV[1])
      logging('error', 'Media filename argument (' + ARGV[1] + ') does '\
        'not exist. Exiting.')
      exit 1
    end
  end

  # ----------------------------------------------------------------------------
  # self.parse_event creates an event by parsing the following command line
  # arguments passed in via the on_picture_save or the on_movie_end command:
  #
  #  ARGV[0] pixels detected
  #  ARGV[1] media filename
  #  ARGV[2] device (camera) number
  #
  def self.parse_event
    # check args before proceeding
    check_args

    # given media_filename, parse for event details
    event_number, event_date = get_event_details(ARGV[1])
    logging('info', 'Arguments passed into routine are ' + ARGV.inspect)

    event_details = { number: event_number, date: event_date, camera_number:
                       ARGV[2], pixels_detected: ARGV[0] }
    event_media = { media: ARGV[1] }
    [event_details, event_media]
  end

  # ----------------------------------------------------------------------------
  # compose the mail.header object
  #
  def self.mail_header(mail, event_details)
    mail.header(MotionMailConfig::EMAIL_TO, MotionMailConfig::EMAIL_FROM,
                'Motion Detected on Camera #' + event_details[:camera_number] +
                ' at ' + event_details[:date])
  end

  # ----------------------------------------------------------------------------
  # compose the mail.delivery_options object
  #
  def self.mail_delivery_options(mail)
    mail.delivery_options(
      MotionMailConfig::SMTP_ADDRESS,
      MotionMailConfig::SMTP_PORT.to_i,
      MotionMailConfig::SMTP_DOMAIN,
      MotionMailConfig::SMTP_USERNAME,
      MotionMailConfig::SMTP_PASSWORD,
      MotionMailConfig::SMTP_AUTHENTICATION,
      MotionMailConfig::SMTP_ENABLE_STARTTLS_AUTO
    )
  end

  # ----------------------------------------------------------------------------
  # performs a replace of the email body with replacement_string
  #
  def self.create_email_body(event_details)
    replacement_string = {
      '!EVENT' => event_details[:number],
      '!PIXELS' => event_details[:pixels_detected],
      '!CAMERA' => event_details[:camera_number]
    }

    replacement_string.each do |k, v|
      MotionMailConfig::EMAIL_BODY.dup.sub!(k, v)
    end
  end

  # ----------------------------------------------------------------------------
  # self.generate_smtp_email(event_details, event_media) generates and mails an
  # smtp email
  #
  # see mail documentation for mail management options
  #
  def self.generate_smtp_email(event_details, event_media)
    # initialize SMTP values
    mail = LibMail::SMTP.new

    # set email options
    mail_delivery_options(mail)
    mail_header(mail, event_details)
    mail.attach_file(event_media[:media])
    mail.body(create_email_body(event_details))

    mail.send_mail

    logging('info', 'Email sent to ' + MotionMailConfig::EMAIL_TO)
  end

  # ----------------------------------------------------------------------------

  LibLog.create_logfile(MotionMailConfig::LOGGING,
                        MotionMailConfig::LOG_LOCATION,
                        MotionMailConfig::LOG_FILENAME)

  event_details, event_media = parse_event
  generate_smtp_email(event_details, event_media)
end

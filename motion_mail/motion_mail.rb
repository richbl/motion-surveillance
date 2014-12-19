#
# Copyright (C) 2014 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

class MotionMail

  require 'mail'
  require 'time'
  require 'inifile'
  require 'logger'
  require 'pathname'

  require_relative 'lib_mail'

  CFG_FILE_PATH = "/etc/motion_mail"

  # ---------------------------------------------------------------
  #
  # create the following event details based on media_filename:
  #
  #   event_number - Motion-generated event number
  #   event_date - Motion-generated event datetime
  #
  # NOTE that this method assumes that media_filename follows the
  # default Motion file-naming convention of %v-%Y%m%d%H%M%S (for movies)
  # or %v-%Y%m%d%H%M%S-%q (for pictures), where:
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

  # ---------------------------------------------------------------
  #
  # parse configuration file (.cfg)
  #

  def self.parse_cfg_file

    ini_file = IniFile.load(CFG_FILE_PATH + '/motion_mail.cfg')

    if ini_file.nil?

      puts "No configuration file found. Exiting."
      exit 1

    end

    general_data = ini_file['General']
    email_data = ini_file['Email']

    if general_data.empty? or email_data.empty?

      puts "Corrupt configuration file. Exiting."
      exit 1

    end

    return {:cfg_section_general => general_data, :cfg_section_email => email_data}

  end

  # ---------------------------------------------------------------
  #
  # create application log file
  #
  # see logger documentation for logfile management options
  #
  # NOTE that this log file is recreated whenever >50MB in size
  #

  def self.create_logfile(cfg_data)

    if cfg_data[:cfg_section_general]["logging_enable"].eql? "1"

      $LOGGING = 1
      $LOG = Logger.new(cfg_data[:cfg_section_general]["logfile_path"] + '/motion_mail.log', 0, 50 * 1024 * 1024)

    else

      $LOGGING = 0

    end

  end

  # ---------------------------------------------------------------
  #
  # create event by parsing the following command line arguments
  # passed in via the on_picture_save or the on_movie_end command:
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

  # ---------------------------------------------------------------
  #
  # generate smtp email
  #
  # see mail documentation for mail management options (e.g., POP3)
  #

  def self.generate_smtp_email(cfg_data, event_details, event_media)

    mail = LibMail::SMTP.new

    # assign SMTP values
    #
    mail.set_delivery_options(
    cfg_data[:cfg_section_email]["smtp_address"],
    cfg_data[:cfg_section_email]["smtp_port"].to_i,
    cfg_data[:cfg_section_email]["smtp_domain"],
    cfg_data[:cfg_section_email]["smtp_username"],
    cfg_data[:cfg_section_email]["smtp_password"],
    cfg_data[:cfg_section_email]["smtp_authentication"],
    cfg_data[:cfg_section_email]["smtp_enable_starttls_auto"]
    )

    # generate email header
    #
    mail.set_header(
    cfg_data[:cfg_section_email]["email_to"],
    cfg_data[:cfg_section_email]["email_from"],
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

    replacement_string.each { |k, v| cfg_data[:cfg_section_email]["email_body"].sub!(k, v)}
    mail.set_body(cfg_data[:cfg_section_email]["email_body"])

    mail.send_mail

    if $LOGGING
      $LOG.info "Email sent to " + cfg_data[:cfg_section_email]["email_to"] + "."
    end

  end

  # ---------------------------------------------------------------
  #

  cfg_data = parse_cfg_file
  create_logfile(cfg_data)
  event_details, event_media = parse_event
  generate_smtp_email(cfg_data, event_details, event_media)

end

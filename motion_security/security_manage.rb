#
# Copyright (C) 2014 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

class SecurityManage

  require 'logger'

  require_relative 'lib_motion'
  require_relative 'lib_network'
  require_relative 'lib_audio'

  require_relative 'security_config'

  # -----------------------------------------------------------------------------------------------
  #
  # self.create_logfile() creates the application log file
  #
  # see logger documentation for logfile management options
  #
  # NOTE: this log file is recreated whenever >50MB in size
  #

  def self.create_logfile

    if SecurityConfig::LOGGING.eql? 1

      $LOGGING = 1
      $LOG = Logger.new(File.expand_path(File.dirname(__FILE__)) + '/motion_security.log', 0, 50 * 1024 * 1024)

    else

      $LOGGING = 0

    end

  end

  # -----------------------------------------------------------------------------------------------
  #
  # self.daemon_running checks to see if the DAEMON_NAME process is running and returns true/false
  #

  def self.daemon_running

    if $LOGGING
      $LOG.info "check for daemon start"
    end

    results = !(IO.popen("ps -ef | grep '#{SecurityConfig::RUBY_EXEC}' | grep '#{SecurityConfig::DAEMON_NAME}' | grep -v grep").read).empty?

    if $LOGGING
      $LOG.info "check for daemon end"
    end

    return (results)

  end

  # -----------------------------------------------------------------------------------------------
  #
  # called by a system cron job, it scans to see if certain devices
  # defined by their MAC address are on the LAN and:
  #
  #   -- If found, stop the process defined in service_motion
  #   -- If not, start a process defined in service_motion
  #
  # check to see if spawned service_motion process already running
  #

  create_logfile

  if daemon_running
    exit
  end

  # freshen local arp cache to guarantee good results when attempting to find
  # devices by MAC address
  #
  if $LOGGING
    $LOG.info "ping hosts"
  end

  LibNetwork::ping_hosts(SecurityConfig::IP_BASE, SecurityConfig::IP_RANGE)

  # remaining logic checks for device(s) existence on LAN and either starts
  # or stops the process defined in service_motion
  #
  if $LOGGING
    $LOG.info "look for device macs"
  end

  if !LibNetwork::find_macs(SecurityConfig::MACS_TO_FIND)

    if $LOGGING
      $LOG.info "no device macs found, so start service_motion if not running"
    end

    if LibMotion::service_motion('start').eql? true

      if SecurityConfig::PLAY_AUDIO.eql? 1
        LibAudio::play_audio(SecurityConfig::AUDIO_MOTION_START)
      end

    end

    # this process emulates a cron job, but at a faster refresh interval (as defined in
    # SecurityConfig::CHECK_INTERVAL) as cron is only good down to one minute intervals
    #
    spawn(SecurityConfig::RUBY_EXEC + " " + SecurityConfig::DAEMON_NAME)

  else

    if $LOGGING
      $LOG.info "device macs found, so stop service_motion if running"
    end

    if LibMotion::service_motion('stop').eql? true

      if SecurityConfig::PLAY_AUDIO.eql? 1
        LibAudio::play_audio(SecurityConfig::AUDIO_MOTION_STOP)
      end

    end

  end

end

#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

class MotionMonitorManage

  require 'logger'

  require_relative '../lib/lib_motion'
  require_relative '../lib/lib_network'
  require_relative '../lib/lib_audio'
  require_relative '../lib/lib_logging'

  require_relative 'motion_monitor_config'

  # -----------------------------------------------------------------------------------------------
  #
  # self.monitor_daemon_running checks to see if the DAEMON_NAME process is running and returns
  # true/false
  #
  def self.monitor_daemon_running

    if $LOG
      $LOG.info "check for daemon start"
    end

    results = !(IO.popen("ps -ef | grep '#{MotionMonitorConfig::RUBY_EXEC}' | grep '#{MotionMonitorConfig::DAEMON_NAME}' | grep -v grep").read).empty?

    if $LOG
      $LOG.info "check for daemon end"
    end

    return (results)

  end

  # -----------------------------------------------------------------------------------------------
  #
  # called by a system cron job, it scans to see if certain devices defined by their MAC address
  # are on the LAN and:
  #
  #   -- if found, stop the process defined in motion_daemon
  #   -- if not, start a process defined in motion_daemon
  #
  # check to see if spawned motion_daemon process already running
  #
  LibLogging::create_logfile(MotionMonitorConfig::LOGGING, MotionMonitorConfig::LOG_LOCATION, MotionMonitorConfig::LOG_FILENAME)

  if monitor_daemon_running
    exit
  end

  # freshen local arp cache to guarantee good results when attempting to find devices by MAC
  # address
  #
  if $LOG
    $LOG.info "ping hosts"
  end

  LibNetwork::ping_hosts(MotionMonitorConfig::IP_BASE, MotionMonitorConfig::IP_RANGE)

  # remaining logic checks for device(s) existence on LAN and either starts or stops the process
  # defined in motion_daemon
  #
  if $LOG
    $LOG.info "look for device macs"
  end

  if !LibNetwork::find_macs(MotionMonitorConfig::MACS_TO_FIND)

    if $LOG
      $LOG.info "no device macs found, so start motion_daemon if not running"
    end

    if LibMotion::motion_daemon('start').eql? true

      if MotionMonitorConfig::PLAY_AUDIO.eql? 1
        LibAudio::play_audio(MotionMonitorConfig::AUDIO_MOTION_START)
      end

    end

    # this process emulates a cron job, but at a faster refresh interval (as defined in
    # MotionMonitorConfig::CHECK_INTERVAL) as cron is only good down to one minute intervals
    #
    spawn(MotionMonitorConfig::RUBY_EXEC + " " + MotionMonitorConfig::DAEMON_NAME)

  else

    if $LOG
      $LOG.info "device macs found, so stop motion_daemon if running"
    end

    if LibMotion::motion_daemon('stop').eql? true

      if MotionMonitorConfig::PLAY_AUDIO.eql? 1
        LibAudio::play_audio(MotionMonitorConfig::AUDIO_MOTION_STOP)
      end

    end

  end

end

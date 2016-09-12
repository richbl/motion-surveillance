#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

require_relative '../lib/lib_config'
require_relative '../lib/lib_motion'
require_relative '../lib/lib_network'
require_relative '../lib/lib_audio'
require_relative '../lib/lib_log'
require_relative 'motion_monitor_config'

include LibLog

# ---------------------------------------------------------------------------
# motion monitor methods
#
class MotionMonitorManager
  # ---------------------------------------------------------------------------
  # simple logging wrapper
  #
  def self.logging(message)
    return if MotionMonitorConfig::LOGGING.zero?
    logger.info message
  end

  # ---------------------------------------------------------------------------
  # self.monitor_daemon_running checks to see if the DAEMON_NAME process is
  # running and returns true/false
  #
  def self.monitor_daemon_running
    logging 'check for monitor_daemon'

    !IO.popen("'#{LibConfig::PS}' -ef | '#{LibConfig::GREP}' \
    '#{MotionMonitorConfig::RUBY_EXEC}' | '#{LibConfig::GREP}' \
    '#{MotionMonitorConfig::DAEMON_NAME}' | \
    '#{LibConfig::GREP}' -v grep").read.empty?
  end

  # ---------------------------------------------------------------------------
  # start the motion daemon
  #
  def self.start_motion_daemon
    if LibMotion.motion_daemon('start').eql? true

      LibAudio.play_audio(MotionMonitorConfig::AUDIO_MOTION_START) if
        MotionMonitorConfig::PLAY_AUDIO == 1

      logging 'BEGIN monitor_daemon'
    end

    # this process emulates a cron job, but at a faster refresh interval (as
    # defined in MotionMonitorConfig::CHECK_INTERVAL) as cron is only good
    # down to one minute intervals
    spawn(MotionMonitorConfig::RUBY_EXEC + ' ' +
          MotionMonitorConfig::DAEMON_NAME)
  end

  # ---------------------------------------------------------------------------
  # self.time_in_range checks to see if the current time is within bounds of
  # the 'always on' range
  #
  def self.time_in_range
    return false if MotionMonitorConfig::SCAN_FOR_TIME.zero?

    logging 'scan for time in range'

    cur_time = Time.new
    start_motion_daemon if cur_time.strftime('%H%M') >=
                           MotionMonitorConfig::ALWAYS_ON_START_TIME &&
                           cur_time.strftime('%H%M') <
                           MotionMonitorConfig::ALWAYS_ON_END_TIME
  end

  # ---------------------------------------------------------------------------
  # self.mac_scan checks to see if device macs exist on LAN and start daemon
  #
  def self.mac_scan
    # freshen local arp cache to guarantee good results when attempting to find
    # devices by MAC address

    logging 'ping hosts'

    LibNetwork.ping_hosts(MotionMonitorConfig::IP_BASE,
                          MotionMonitorConfig::IP_RANGE)

    logging 'look for device macs'

    start_motion_daemon unless
      LibNetwork.find_macs(MotionMonitorConfig::MACS_TO_FIND)
  end

  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # called by a system cron job, scans to see if the current time is within
  # the configured 'always on' range, or if certain devices defined by their
  # MAC address are on the LAN and:
  #
  #   -- if found, stop the process defined in motion_daemon
  #   -- if not, start a process defined in motion_daemon
  #
  LibLog.create_logfile(MotionMonitorConfig::LOGGING,
                        MotionMonitorConfig::LOG_LOCATION,
                        MotionMonitorConfig::LOG_FILENAME)

  logging 'BEGIN motion_monitor_manager'

  if monitor_daemon_running
    logging 'monitor_daemon already running'
    logging 'END motion_monitor_manager'
    exit
  end

  # determine whether to start motion_daemon based on time or mac scan
  mac_scan unless time_in_range
end

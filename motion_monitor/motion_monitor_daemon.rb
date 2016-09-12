#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

require_relative '../lib/lib_motion'
require_relative '../lib/lib_network'
require_relative '../lib/lib_audio'
require_relative '../lib/lib_log'
require_relative 'motion_monitor_config'

include LibLog

# -----------------------------------------------------------------------------
# motion monitor methods
#
class MotionMonitorDaemon
  # ---------------------------------------------------------------------------
  # simple logging wrapper
  #
  def self.logging(message)
    return if MotionMonitorConfig::LOGGING.zero?
    logger.info message
  end

  # ---------------------------------------------------------------------------
  # stop the motion daemon
  #
  def self.stop_motion_daemon
    if LibMotion.motion_daemon('stop').eql? true
      LibAudio.play_audio(MotionMonitorConfig::AUDIO_MOTION_STOP) if
        MotionMonitorConfig::PLAY_AUDIO == 1

      logging 'END monitor_daemon'
      exit
    end
  end

  # ---------------------------------------------------------------------------
  # self.time_out_of_range checks to see if the current time is out of
  # 'always on' range
  #
  def self.time_out_of_range
    return true if MotionMonitorConfig::SCAN_FOR_TIME.zero?

    logging 'scan for time out of range'

    cur_time = Time.new
    cur_time.strftime('%H%M') < MotionMonitorConfig::ALWAYS_ON_START_TIME ||
      cur_time.strftime('%H%M') >= MotionMonitorConfig::ALWAYS_ON_END_TIME
  end

  # ---------------------------------------------------------------------------
  # self.mac_scan checks to see if device macs exist on LAN and start daemon
  #
  def self.mac_scan
    logging 'ping hosts'

    # freshen local arp cache to guarantee good results when attempting to find
    # devices by MAC address
    #
    LibNetwork.ping_hosts(MotionMonitorConfig::IP_BASE,
                          MotionMonitorConfig::IP_RANGE)

    logging 'scan for device macs'

    stop_motion_daemon if
    LibNetwork.find_macs(MotionMonitorConfig::MACS_TO_FIND)
  end

  # ---------------------------------------------------------------------------

  # ---------------------------------------------------------------------------
  # message pump called by MotionMonitorManager, scans to see if the current
  # time is outside of the configured 'always on' range, or if certain
  # devices defined by their MAC address are on the LAN and:
  #
  #   -- if found, stop the process defined in motion_daemon
  #   -- if not, sleep and repeat scan
  #
  LibLog.create_logfile(MotionMonitorConfig::LOGGING,
                        MotionMonitorConfig::LOG_LOCATION,
                        MotionMonitorConfig::LOG_FILENAME)

  logging 'BEGIN monitor_daemon'

  # if current time is out of configured 'always on' range (or disabled),
  # perform mac scan, then go back to sleep
  loop do
    mac_scan if time_out_of_range
    sleep MotionMonitorConfig::CHECK_INTERVAL
  end
end

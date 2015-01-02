#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

require 'logger'

require_relative '../lib/lib_motion'
require_relative '../lib/lib_network'
require_relative '../lib/lib_audio'
require_relative '../lib/lib_log'
require_relative 'motion_monitor_config'

class MotionMonitorDaemon

  LibLog::create_logfile(MotionMonitorConfig::LOGGING, MotionMonitorConfig::LOG_LOCATION, MotionMonitorConfig::LOG_FILENAME)

  # -----------------------------------------------------------------------------------------------
  #
  # message pump called by MotionMonitorManager, scans to see if certain devices defined by their MAC
  # address are on the LAN and:
  #
  #   -- if found, stop the process defined in motion_daemon
  #   -- if not, sleep and repeat scan
  #
  while true

    # freshen local arp cache to guarantee good results when attempting to find devices by MAC
    # address
    #
    LibNetwork::ping_hosts(MotionMonitorConfig::IP_BASE, MotionMonitorConfig::IP_RANGE)

    # remaining logic checks for device(s) existence on LAN and either stops the process defined
    # in motion_daemon or sleeps and repeats scan
    #
    if LibNetwork::find_macs(MotionMonitorConfig::MACS_TO_FIND)

      if LibMotion::motion_daemon('stop').eql? true

        if $LOG
          $LOG.info "monitor_daemon stopping"
        end

        if MotionMonitorConfig::PLAY_AUDIO.eql? 1
          LibAudio::play_audio(MotionMonitorConfig::AUDIO_MOTION_STOP)

        end

      end

      exit

    end

    sleep MotionMonitorConfig::CHECK_INTERVAL

  end

end

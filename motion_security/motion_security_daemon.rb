#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

class MotionSecurityDaemon

  require 'logger'

  require_relative '../lib/lib_motion'
  require_relative '../lib/lib_network'
  require_relative '../lib/lib_audio'
  require_relative '../lib/lib_logging'

  require_relative 'motion_security_config'

  LibLogging::create_logfile(MotionSecurityConfig::LOGGING, MotionSecurityConfig::LOG_LOCATION, MotionSecurityConfig::LOG_FILENAME)

  # -----------------------------------------------------------------------------------------------
  #
  # message pump called by ManageSecurity, scans to see if certain devices defined by their MAC
  # address are on the LAN and:
  #
  #   -- if found, stop the process defined in motion_daemon
  #   -- if not, sleep and repeat scan
  #
  while true

    # freshen local arp cache to guarantee good results when attempting to find devices by MAC
    # address
    #
    LibNetwork::ping_hosts(MotionSecurityConfig::IP_BASE, MotionSecurityConfig::IP_RANGE)

    # remaining logic checks for device(s) existence on LAN and either stops the process defined
    # in motion_daemon or sleeps and repeats scan
    #
    if LibNetwork::find_macs(MotionSecurityConfig::MACS_TO_FIND)

      if (MotionSecurityConfig::PLAY_AUDIO.eql? 1)
        LibAudio::play_audio(MotionSecurityConfig::AUDIO_MOTION_STOP)
      end

      if $LOG
        $LOG.info "security_daemon found device macs, so stop motion_daemon if running"
      end

      LibMotion::motion_daemon('stop')
      exit

    end

    sleep MotionSecurityConfig::CHECK_INTERVAL

  end

end

#
# Copyright (C) 2014 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

class SecurityDaemon

  require_relative '../ruby_libs/lib_motion'
  require_relative '../ruby_libs/lib_network'
  require_relative '../ruby_libs/lib_audio'

  require_relative 'security_config'

  # -----------------------------------------------------------------------------------------------
  #
  # message pump called by ManageSecurity, scans to see if certain devices defined by their MAC
  # address are on the LAN and:
  #
  #   -- if found, stop the process defined in service_motion
  #   -- if not, sleep and repeat scan
  #

  while true

    # freshen local arp cache to guarantee good results when attempting to find devices by MAC
    # address
    #
    LibNetwork::ping_hosts(SecurityConfig::IP_BASE, SecurityConfig::IP_RANGE)

    # remaining logic checks for device(s) existence on LAN and either stops the process defined
    # in service_motion or sleeps and repeats scan
    #
    if LibNetwork::find_macs(SecurityConfig::MACS_TO_FIND)

      if (SecurityConfig::PLAY_AUDIO.eql? 1)
        LibAudio::play_audio(SecurityConfig::AUDIO_MOTION_STOP)
      end

      LibMotion::service_motion('stop')
      exit

    end

    sleep SecurityConfig::CHECK_INTERVAL

  end

end

#
# Copyright (C) 2014 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module SecurityConfig

  # -----------------------------------------------------------------------------------------------
  #
  # enable (1) or disable (0) application logging
  #
  LOGGING = 1

  # -----------------------------------------------------------------------------------------------
  #
  # logging filename
  #
  # ignored if LOGGING == 0
  #
  LOGFILENAME = "motion_security.log"  

  # -----------------------------------------------------------------------------------------------
  #
  # pathname of the current ruby binary
  #
  RUBY_EXEC = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name']).sub(/.*\s.*/m, '"\&"')

  # -----------------------------------------------------------------------------------------------
  #
  # the command used to spawn the security process when motion is active
  #
  # additionally, this variable is used to uniquely identify the active ruby process using the
  # shell grep to determine if the process is running
  #
  DAEMON_NAME = File.expand_path(File.dirname(__FILE__)) + '/security_daemon.rb'

  # -----------------------------------------------------------------------------------------------
  #
  # enable (1) or disable (0) the play-back of audio on motion service start/stop
  #
  PLAY_AUDIO = 1

  # -----------------------------------------------------------------------------------------------
  #
  # the audio file played when the motion service is activated
  #
  # ignored if PLAY_AUDIO == 0
  #
  AUDIO_MOTION_START = File.expand_path(File.dirname(__FILE__)) + '/motion_start.wav'

  # -----------------------------------------------------------------------------------------------
  #
  # the audio file played when the motion service is deactivated
  #
  # ignored if PLAY_AUDIO == 0
  #
  AUDIO_MOTION_STOP = File.expand_path(File.dirname(__FILE__)) + '/motion_stop.wav'

  # -----------------------------------------------------------------------------------------------
  #
  # interval (in seconds) to scan for device(s) MAC addresses after motion is activated
  #
  CHECK_INTERVAL = 15

  # -----------------------------------------------------------------------------------------------
  #
  # network configuration variables that characterize the LAN where devices will be scanned for to
  # determine when motion should be run
  #
  # where:
  #
  #   IP_BASE = first three address octets defining the LAN (e.g., 192.168.1.)
  #   IP_RANGE = fourth address octet defined as a range (e.g., 1..254)
  #
  IP_BASE = '10.10.10.'
  IP_RANGE = 100..254

  # -----------------------------------------------------------------------------------------------
  #
  # MAC addresses of device(s) to search for on the LAN
  #
  # NOTE: the assumption is that these devices are active on the LAN, else they won't be detected
  # when ping'd
  #
  MACS_TO_FIND = ['80:96:b1:93:5b:41', '80:96:b1:94:d7:a5']

end

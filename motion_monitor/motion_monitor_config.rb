#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module MotionMonitorConfig
  # ---------------------------------------------------------------------------
  # enable (1) or disable (0) application logging
  #
  # NOTE: passing in 2 sets logging to STDOUT
  #
  LOGGING = 0

  # ---------------------------------------------------------------------------
  # logging filename
  #
  # ignored if LOGGING == 0
  #
  LOG_FILENAME = 'motion_monitor.log'.freeze

  # ---------------------------------------------------------------------------
  # location of logfile (full path)
  #
  # by default, this is in the local folder (e.g.,
  # /etc/motion_surveillance/motion_monitor)
  #
  # ignored if LOGGING == 0
  #
  LOG_LOCATION = File.expand_path(File.dirname(__FILE__))

  # ---------------------------------------------------------------------------
  # pathname of the current ruby binary
  #
  RUBY_EXEC = File.join(RbConfig::CONFIG['bindir'],
                        RbConfig::CONFIG['ruby_install_name'])
                  .sub(/.*\s.*/m, '"\&"')

  # ---------------------------------------------------------------------------
  # the command used to spawn the monitor process when motion is active
  #
  # by default, this is in the local folder (e.g.,
  # /etc/motion_surveillance/motion_monitor)
  #
  # additionally, this variable is used to uniquely identify the active ruby
  # process using the shell grep to determine if the process is running
  #
  DAEMON_NAME = File.expand_path(File.dirname(__FILE__)) +
                '/motion_monitor_daemon.rb'

  # ---------------------------------------------------------------------------
  # enable (1) or disable (0) the play-back of audio on motion daemon
  # start/stop
  #
  PLAY_AUDIO = 1

  # ---------------------------------------------------------------------------
  # this audio file played when the motion daemon is activated
  #
  # by default, this is in the local folder (e.g.,
  # /etc/motion_surveillance/motion_monitor)
  #
  # ignored if PLAY_AUDIO == 0
  #
  AUDIO_MOTION_START = File.expand_path(File.dirname(__FILE__)) +
                       '/motion_start.wav'

  # ---------------------------------------------------------------------------
  # this audio file played when the motion daemon is deactivated
  #
  # by default, this is in the local folder (e.g.,
  # /etc/motion_surveillance/motion_monitor)
  #
  # ignored if PLAY_AUDIO == 0
  #
  AUDIO_MOTION_STOP = File.expand_path(File.dirname(__FILE__)) +
                      '/motion_stop.wav'

  # ---------------------------------------------------------------------------
  # enable (1) or disable (0) motion daemon based on time-of-day
  #
  SCAN_FOR_TIME = 1

  # ---------------------------------------------------------------------------
  # start and end times (24-hour format) for motion to always be enabled
  #
  # ignored if SCAN_FOR_TIME == 0
  #
  ALWAYS_ON_START_TIME = '2300'.freeze
  ALWAYS_ON_END_TIME = '0400'.freeze

  # ---------------------------------------------------------------------------
  # interval (in seconds) to scan for device(s) MAC addresses after motion is
  # activated
  #
  CHECK_INTERVAL = 15

  # ---------------------------------------------------------------------------
  # network configuration variables that characterize the LAN where devices
  # will be scanned for to determine when motion should be run
  #
  # where:
  #
  #   IP_BASE = first three address octets defining the LAN (e.g., 192.168.1.)
  #   IP_RANGE = fourth address octet defined as a range (e.g., 1..254)
  #
  IP_BASE = '10.10.10.'.freeze
  IP_RANGE = 100..254

  # ---------------------------------------------------------------------------
  # MAC addresses of device(s) to search for on the LAN
  #
  # NOTE: the assumption is that these devices are on the LAN, else they won't
  # be detected when ping'd
  #
  MACS_TO_FIND = ['24:da:9b:0d:53:8f', 'f8:cf:c5:d2:bb:9e'].freeze
end

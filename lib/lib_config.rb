#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

# ----------------------------------------------------------------------------
# configuration library
#
module LibConfig
  # ----------------------------------------------------------------------------
  # fullpath of various system commands
  #
  # NOTE: these commands can be executed from a cron job, so absolute paths
  # should be specified
  #
  APLAY = '/usr/bin/aplay'.freeze
  ARP = '/usr/sbin/arp'.freeze
  GREP = '/bin/grep'.freeze
  KILLALL = '/usr/bin/killall'.freeze
  PING = '/bin/ping'.freeze
  PS = '/bin/ps'.freeze
end

#
# Copyright (C) Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

require_relative 'lib_config'

# ----------------------------------------------------------------------------
# motion library
#
module LibMotion
  # ----------------------------------------------------------------------------
  # self.running_motion determines whether motion is running using shell
  # ps/grep commands
  #
  def self.running_motion
    results = `#{LibConfig::PS} -A| #{LibConfig::GREP} motion`
    !results.empty?
  end

  # ----------------------------------------------------------------------------
  # self.motion_daemon(command) enable/disables motion using motion command
  # (daemon)
  #
  def self.motion_daemon(command)
    case command

    when 'start'
      return false if running_motion
      `motion`
      return true

    when 'stop'
      return false unless running_motion
      `#{LibConfig::KILLALL} motion`
      return true

    end
  end
end

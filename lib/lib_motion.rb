#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

require_relative 'lib_config'

module LibMotion

  # -----------------------------------------------------------------------------------------------
  #
  # self.running_motion determines whether motion is running using shell ps/grep commands
  #
  def self.running_motion

    results = %x[#{LibConfig::PS} -A| #{LibConfig::GREP} motion]
    return (!results.empty?)

  end

  # -----------------------------------------------------------------------------------------------
  #
  # self.motion_daemon(command) enable/disables motion using motion command (daemon)
  #
  def self.motion_daemon(command)

    case command
    when "start"

      if !running_motion

        %x[motion]
        return true

      else

        return false

      end

    when "stop"

      if running_motion

        %x[#{LibConfig::KILLALL} motion]
        return true

      else

        return false

      end

    end

  end

end

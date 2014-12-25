#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module LibMotion

  # -----------------------------------------------------------------------------------------------
  #
  # self.running_motion determines whether motion is running using shell ps/grep commands
  #
  def self.running_motion

    results = %x[ps -A| grep motion]
    return (!results.empty?)

  end

  # -----------------------------------------------------------------------------------------------
  #
  # self.motion_daemon(command) enable/disables motion using motion command (daemon)
  #
  # alternatively could implement lwp-request as motion uses a restful interface (http)
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

        %x[killall motion]
        return true

      else

        return false

      end

    end

  end

end

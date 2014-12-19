#
# Copyright (C) 2014 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module LibMotion
  
  # ---------------------------------------------------------------
  #
  # determine whether motion is running using shell ps/grep commands
  #
  
  def self.running_motion

    results = %x[ps -A| grep motion]
    return (!results.empty?)

  end

  # ---------------------------------------------------------------
  #
  # enable/disable motion using motion command (daemon)
  #
  # TODO: alternatively could implement lwp-request as
  # motion uses a restful interface (http)
  #
  
  def self.service_motion(command)

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
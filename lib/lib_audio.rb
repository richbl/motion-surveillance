#
# Copyright (C) 2014 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module LibAudio

  # ---------------------------------------------------------------
  #
  # use shell aplay command (system default) to play audio_file
  # returning bool on success/failure
  #
  #  
  def self.play_audio(audio_file)
    
    results = system("aplay -q " + audio_file)
    return (results)
    
  end
  
end
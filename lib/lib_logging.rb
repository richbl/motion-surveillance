#
# Copyright (C) 2014 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module LibLogging

  # -----------------------------------------------------------------------------------------------
  #
  # self.create_logfile() creates the application log file
  #
  # see logger documentation for logfile management options
  #
  # NOTE: this log file is recreated whenever >50MB in size
  #

  def self.create_logfile(bLogging, logFilename)

    if bLogging.eql? 1

      $LOG = Logger.new(File.expand_path(File.dirname(__FILE__)) + '/' + logFilename, 0, 50 * 1024 * 1024)

    end

  end

end

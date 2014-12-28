#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

module LibLog

  # -----------------------------------------------------------------------------------------------
  #
  # self.create_logfile(bLogging, logLocation, logFilename) creates an application log file
  #
  # see logger documentation (http://www.ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html)
  # for logfile management options
  #
  # NOTE: this log file is recreated whenever >50MB in size
  #
  def self.create_logfile(bLogging, logLocation, logFilename)

    if bLogging.eql? 1

      $LOG = Logger.new(logLocation + '/' + logFilename, 0, 50 * 1024 * 1024)

    end

  end

end

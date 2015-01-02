#
# Copyright (C) 2015 Business Learning Incorporated (www.businesslearninginc.com)
#
# Use of this source code is governed by an MIT-style license
# that can be found in the LICENSE file
#

require 'thread'
require 'thwait'

require_relative 'lib_config'

module LibNetwork

  # -----------------------------------------------------------------------------------------------
  #
  # self.ping_hosts uses shell ping (ICMP) to ping the address range passed in and freshen up
  # the local arp cache
  #
  def self.ping_hosts(ip_base, ip_range)

    threads = []

    ip_range.each do |n|

      address = ip_base + n.to_s
      threads << Thread.new{%x[#{LibConfig::PING} -q -c1 -W1 #{address}]}

    end

    ThreadsWait.all_waits(*threads)

  end

  # -----------------------------------------------------------------------------------------------
  #
  # self.find_macs uses shell arp to find mac addressed passed in
  #
  # NOTE: returns true if any mac passed in is found (e.g., mac1 | mac2 | mac3)
  #
  def self.find_macs(macs_to_find)

    mac_list_regex =''

    macs_to_find.each_with_index do |val, idx|

      mac_list_regex += val

      if idx < (macs_to_find.count - 1)
        mac_list_regex += '\|'
      end

    end

    results = %x[#{LibConfig::ARP} -n | #{LibConfig::GREP} -E #{mac_list_regex}]
    return (!results.empty?)

  end

end

#**MotionSurveillance**

MotionSurveillance is a Ruby-based video surveillance system using the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") motion detection software package. 

##Features

 - Movement detection support of IP cameras and webcams (courtesy of [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion")). See [this list](http://www.lavrsen.dk/foswiki/bin/view/Motion/WorkingDevices "Device Compatibility") for current device compatibility
 - Automated email notification on motion detection events
	 - Optionally Include event image or video clip
	 - SMTP-support for compatibility with most webmail services (*e.g.*, Gmail)
	 - POP3-support [planned]
 - Automated enabling/disabling of security system based on Internet of Things ([IoT](http://en.wikipedia.org/wiki/Internet_of_Things "Internet of Things")) device existence
	 - [MAC](http://en.wikipedia.org/wiki/MAC_address "MAC address") address sensing
		 - Multiple devices can be specified
		 - IPv4 protocol support
		 - IPv6 protocol support [planned]
	 - Bluetooth sensing (RSSI) [planned]
	 - Optionally play an audio file on surveillance system enable/disable
 - Event logging/management
 
##How It Works

MotionSurveillance works by periodically scanning a network for the existence of a specified device(s). This device can be anything that is a member of a network that exposes its MAC address (*e.g.*, a mobile phone on a home LAN). In the default case, if that device is identified as a member of a given network, it's assumed that "someone is home" and so, the security system is not enabled. If that device it no longer a member of the network, it's assumed that "nobody is home" and the security system is enabled. Similar logic is used in the reverse case: when a device is once again "back home," the security system is disabled.

Operationally, MotionSurveillance is comprised of three components: 

- **System**: a system cron job that periodically wakes up the **Security Manager** component
- **Security Manager**: checks to see if **Security Daemon** is running, and if it isn't, determine whether it should. The **Security Manager** component is responsible for starting the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software package
- **Security Daemon**: while the security system is active, periodically checks to see if it should continue to run. The **Security Daemon** is responsible for stopping the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software package

The activity diagram below shows the work flow for each of these components:

![MotionSurveillance Activity Diagram](https://raw.githubusercontent.com/richbl/motion-surveillance/master/security_activity_diagram.png "MotionSurveillance Activity Diagram")

## Requirements

 - A Linux-based operating system
	 - While MotionSurveillance was written and tested under Linux (Ubuntu 14.04 LTS), there should be no reason why this won't work just fine under other Linux distributions. Specific Unix-like tools used by MotionSurveillance include:
		 - [ps](http://en.wikipedia.org/wiki/Ps_%28Unix%29): process status
		 - [arp](http://en.wikipedia.org/wiki/Address_Resolution_Protocol): address resolution protocol
		 - [grep](http://en.wikipedia.org/wiki/Grep): globally search a regular expression and print
		 - [ping](http://en.wikipedia.org/wiki/Ping_(networking_utility)): ICMP network packet echo/response tool
		 - [aplay](http://en.wikipedia.org/wiki/Aplay): ALSA audio player (optional)
 - [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") correctly installed and configured with appropriate video devices
 - [Ruby](https://www.ruby-lang.org/en/ "Ruby") (2.0+) correctly installed and configured
	 - [Rubygems](https://rubygems.org/ "Rubygems") installed and configured with the following gems:
		 - [mail](https://rubygems.org/gems/mail) (2.5.4+)
		 - [thread](https://rubygems.org/gems/thread) (0.1.4+)

## Installation
TBD
	
## Basic Usage
TBD

## License

The MIT License (MIT)

Copyright (c) 2015 Business Learning Incorporated

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

MotionSurveillance
===================

MotionSurveillance is a Ruby-based video surveillance system using the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") motion detection software package. 

##Features

 - Motion detection of numerous IP and webcams (courtesy of [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion")). See [this list](http://www.lavrsen.dk/foswiki/bin/view/Motion/WorkingDevices "Device Compatibility") for device compatibility
 - Automated email notification on valid motion detection event
	 - Include or exclude motion image or video clip
	 - SMTP-based (e.g, Gmail)
 - Automated enabling/disabling of security system based on Internet of Things ([IoT](http://en.wikipedia.org/wiki/Internet_of_Things "Internet of Things")) device existence
	 - [MAC](http://en.wikipedia.org/wiki/MAC_address "MAC address") address (IPv4-based)
		 - A device that joins/leaves a home LAN will trigger security system status
		 - Multiple devices can be specified
	 - Bluetooth sensing
		 - [planned]
	 - Optionally play audio file on security system enable/disable events
 - Event logging/management
 
##How It Works

MotionSurveillance works by periodically scanning a network for the existence of a specified device(s). This device can be anything that is a member of a network that exposes its MAC address (*e.g.*, a mobile phone on a home LAN). In the default case, if that device is identified to be a part of a given network, it's assumed that "someone is home" and so, the security system is not enabled. If that device is absent from the network, it's assumed that "nobody is home" and the security system is enabled. Similar logic is used in the reverse case, so that when a device is once again "back home," the security system is disabled.

Operationally, MotionSurveillance is comprised of three primary components: 

- **System**: a system cron job that periodically wakes up the **Security Manager** component
- **Security Manager**: checks to see if **Security Daemon** is running, and If it isn't, determine whether it should. The **Security Manager** component is responsible for starting the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software package
- **Security Daemon**: while the security system is active, periodically checks to see if it should continue to run. The **Security Daemon** is responsible for stopping the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software package

The UML activity diagram below shows the flow of activity for each of these components.

![MotionSurveillance Activity Diagram](https://raw.githubusercontent.com/richbl/motion-surveillance/master/security_activity_diagram.png)

## Requirements

 - A Linux-based operating system
	 - While MotionSurveillance was written and tested under Linux (Ubuntu 14.04 LTS), there should be no reason why this won't work just fine under other Linux distributions
 - [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") correctly installed and configured with appropriate video devices
 - [Ruby](https://www.ruby-lang.org/en/ "Ruby") correctly installed and configured
	 - [Rubygems](https://rubygems.org/ "Rubygems") installed and configured
 - Supplemental Ruby packages ("gems"):
	 - mail gem: https://rubygems.org/gems/mail
	 - inifile gem: https://rubygems.org/gems/inifile
	 - logger gem: https://rubygems.org/gems/logger
	 - thread gem: https://rubygems.org/gems/thread

## Installation
TBD
	
## Basic Usage
TBD

## License

The MIT License (MIT)

Copyright (c) 2014 Business Learning Incorporated

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

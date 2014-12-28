##Motion-Surveillance

Motion-Surveillance is a Ruby-based video surveillance system using the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") motion detection software package. Motion-Surveillance includes the following package components:

   - Motion-Monitor: integrated system services that monitor the status of devices on a given network, and start/stop the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") package as appropriate.
   - Motion-Mail: a configurable component for sending an email whenever [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") generates a motion-related event.

> **Note:** either of the two package components (Motion-Monitor and Motion-Mail) can be installed separately: it's only important to install the shared component libraries (Lib) when installing either component.

##Features

 - [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") Software Package
 
	- Movement detection support of video cameras. See [this list](http://www.lavrsen.dk/foswiki/bin/view/Motion/WorkingDevices "Device Compatibility") for video device compatibility.
 - Motion-Monitor Component
	 - Automated enabling/disabling of the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") detection software program based on the presence of Internet of Things ([IoT](http://en.wikipedia.org/wiki/Internet_of_Things "Internet of Things")) devices on a network (*e.g.*, [LAN](http://en.wikipedia.org/wiki/Local_area_network "Local Area Network")).
	 
		 - [MAC](http://en.wikipedia.org/wiki/MAC_address "MAC address") address sensing
			 - Multiple [IoT](http://en.wikipedia.org/wiki/Internet_of_Things "Internet of Things") device support
			 - IPv4 protocol support
			 - IPv6 protocol support [planned]
		 - Bluetooth sensing (RSSI) [planned]
		 - Optionally play an audio file on surveillance system enable/disable
		 - Event logging
 - Motion-Mail Component
 
	 - Automated email notification on movement detection events
	 
		 - Configurable message body
		 - Optionally attach event image or video in email
		 - SMTP-support for compatibility with most webmail services (*e.g.*, [Gmail](http://gmail.com "Google Gmail"))
		 - POP3-support [planned]
		 - Event logging
 
##How Motion-Surveillance Works

Each of the Motion-Surveillance package components perform independent services that are integrated with the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software package.

###Motion-Monitor Operation
Motion-Monitor is responsible for starting/stopping the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software package. 

It does this by periodically scanning a network for the existence of a monitored device(s). This device can be anything that exposes its MAC address on the network (*e.g.*, a mobile phone on a home LAN). In the default case, if that device is found on the network, it's assumed that "someone is home" and so, [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") is not started (or stopped if already running). If that device it no longer joined network, it's assumed that "nobody is home" and [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") is started (if not already running). Similar logic is used in the reverse case: when a monitored device is once again "back home," [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") is stopped.

Operationally, Motion-Monitor is comprised of three component objects (or actors): 

- **System**: a system cron job that periodically wakes up the **MotionMonitorManager** component
- **MotionMonitorManager**: checks to see if **MotionMonitorDaemon** is running, and if it isn't, determines whether it should. The **MotionMonitorManager** component is responsible for starting the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software package
- **MotionMonitorDaemon**: while [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") is active, periodically checks to see if it should continue to run, and stops it if necessary 

The activity diagram below shows the work flow for each of these components:

![Motion-Surveillance Activity Diagram](https://raw.githubusercontent.com/richbl/motion-surveillance/master/security_activity_diagram.png "Motion-Surveillance Activity Diagram")

> **Note:** additional information about the Motion-Monitor component can be found in the Motion-Surveillance installation file ([INSTALL.md](https://github.com/richbl/motion-surveillance/blob/master/INSTALL.md "INSTALL.md")).

###Motion-Mail Operation

Motion-Mail is the Motion-Surveillance component responsible for sending an email whenever a valid movement event is triggered in [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion").

These events are triggered through the [*on_picture_save* command ](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigOptionOnPictureSave "on_picture_save command") and the [on_movie_end command](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigOptionOnMovieEnd "on_movie_end command") in [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") and are how Motion-Mail gets called. 

The syntax for these [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") commands are:
  
	<on_picture_save|on_movie_end> <absolute path to ruby> <absolute path to motion_mail.rb> <%D %f %t>

These commands are managed through the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") configuration file called `motion.conf`.

Once configured, Motion-Mail will respond to these [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") event [hooks](http://en.wikipedia.org/wiki/Hooking "Hooking"), and an email will be generated and sent along with an optional image file or video clip.

> **Note:** additional information about the Motion-Mail component can be found in the Motion-Surveillance installation file ([INSTALL.md](https://github.com/richbl/motion-surveillance/blob/master/INSTALL.md "INSTALL.md")).

## Motion-Surveillance Requirements

 - A Linux-based operating system
	 - While Motion-Surveillance was written and tested under Linux (Ubuntu 14.04 LTS), there should be no reason why this won't work just fine under other Linux distributions. Specific Unix-like tools used by Motion-Surveillance include:
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

## Motion-Surveillance Installation
For complete details on Motion-Surveillance installation, see the installation file ([INSTALL.md](https://github.com/richbl/motion-surveillance/blob/master/INSTALL.md "INSTALL.md")).

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

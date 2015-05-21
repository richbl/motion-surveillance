##Motion-Surveillance Installation
The installation of the Motion-Surveillance package includes:

 1. The installation and configuration of the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software program
 2. The installation and configuration of the Motion-Surveillance package components which include:
 
   - Motion-Monitor
   - Motion-Mail
   - Shared component libraries (Lib)

 3. The integration of Motion-Surveillance Components with [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion")

> **Note:** either of the two package components (Motion-Monitor and Motion-Mail) can be installed separately: it's only important to install the shared component libraries (Lib) when installing either component.

### 0. Confirm That All Motion-Surveillance Requirements are Met Before Proceeding

 1. Review the Motion-Surveillance requirements section in `README.md` located [here](https://github.com/richbl/motion-surveillance#motion-surveillance-requirements "Requirements").
 
	To summarize these requirements: the operating system is Unix-like (*e.g.*, Linux); the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software program should be installed; and Ruby all required gems should be installed and fully operational.

### 1. Confirm the Installation and Configuration of the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") Software Program

 1. Confirm the installation of the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software program package.

	Before installing Motion-Surveillance, the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software program should to be correctly installed, configured and operational.  Details for [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") installation can be found on the [Motion website](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion").
 
 2. Configure [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") to run as a daemon.

	For proper operation with Motion-Surveillance, [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") should be set to run in daemon mode (which permits [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") to run as a background process). This is achieved through an edit made to the `motion.conf` file located in the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") folder (*e.g.,* `/etc/motion`).

	In the section called Daemon, set the `daemon` variable to `on` as noted below:

	    ############################################################
	    # Daemon
	    ############################################################
	    
	    # Start in daemon (background) mode and release terminal (default: off)
	    daemon on

### 2. Download and Install the Motion-Surveillance Package

 1. Download the repository zip file from the [Motion-Surveillance repository](https://github.com/richbl/motion-surveillance "Motion-Surveillance") and unzip into a temporary folder.

 3. Delete non-essential top-level files, but preserve all three component directories: `lib`, `motion_mail`, and `motion_monitor`.

	The top-level informational files (*e.g.*, `README.MD`, `INSTALL.MD`, *etc.*) are not required to properly configure and run the Motion-Surveillance package. They may be safely deleted.

	As indicated above, Motion-Surveillance is organized into three separate package components. The organization of these components is represented in the structure of the parent `motion-surveillance` folder. 

	> 	**Note:** the location of this folder structure is not important, but the relative folder structure and names must be preserved (or changed in all component configuration files).

 2. Copy the `motion-surveillance` folder into an appropriate local folder.

	As an example, since the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") software program installs into the `/etc` folder (as `/etc/motion`) on a Debian-based system, Motion-Surveillance can also be installed into the `/etc` folder, as indicated below:

	```
	/etc/motion-surveillance/
	|
	├── lib
	│   ├── lib_audio.rb
	│   ├── lib_config.rb
	│   ├── lib_log.rb
	│   ├── lib_mail.rb
	│   ├── lib_motion.rb
	│   ├── lib_network.rb
	│   └── test_libs.rb
	|
	├── motion_mail
	│   ├── motion_mail_config.rb
	│   └── motion_mail.rb
	|
	└── motion_monitor
	    ├── motion_monitor_config.rb
	    ├── motion_monitor_daemon.rb
	    ├── motion_monitor_manager.rb
	    ├── motion_start.wav
	    └── motion_stop.wav
	```
			    
## 3. Configure Motion-Surveillance Package Components

1. Edit Motion-Surveillance `*_config.rb` configuration files.

	All three package components--Motion-Mail, Motion-Monitor, and the shared components library (Lib)--should be configured for proper operation. Each component includes a separate `*_config.rb` file which serves the purpose of isolating user-configurable parameters from the rest of the code:
	
	- 	`motion_monitor_config.rb`, found in the `/etc/motion-surveillance/motion_monitor` folder, is used for configuring component logging options and for setting network parameters used to automate the management of the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") daemon.
	- `motion_mail_config.rb`, found in the `/etc/motion-surveillance/motion_mail` folder, is used primarily to configure SMTP mail settings, as well as component logging options.
	- `lib_config.rb`, found in the `/etc/motion-surveillance/lib` folder, is used to configure the location of system-level commands (*e.g.*, /bin/ping). In general, these settings will not need to be changed.

	Each configuration file is self-documenting and in most cases, provides examples of common default values.

##4. Integrate Motion-Mail with [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion")

Motion-Mail is the Motion-Surveillance component responsible for sending an email whenever a valid movement event is triggered in [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion"). These events are triggered through the [*on_picture_save* command ](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigOptionOnPictureSave "on_picture_save command") and the [on_movie_end command](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigOptionOnMovieEnd "on_movie_end command") in [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") and are how Motion-Mail gets called. 

The syntax for these [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") commands are:
  
	<on_picture_save|on_movie_end> <absolute path to ruby> <absolute path to motion_mail.rb> <%D %f %t>

These commands are saved in the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") configuration file called `motion.conf` (located in `/etc/motion`).

> **Note:** the parameters passed on this command (<%D %f %t>) are called *conversion specifiers* and are described in detail in the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") documentation on [ConversionSpecifiers](http://www.lavrsen.dk/foswiki/bin/view/Motion/ConversionSpecifiers "ConversionSpecifiers").

1. Update the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") `motion.conf` file to call Motion-Mail on picture save (or movie end).

	The easiest way to edit this file is to append the `on_picture_save` or `on_movie_end` command at the end of the `motion.conf` file. For example:

		$ echo 'on_picture_save /usr/bin/ruby /etc//motion_mail/motion_mail.rb %D %f %t' >> /etc/motion/motion.conf

2. Restart [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") to have the update to `motion.conf` take effect. 

		$ sudo /etc/init.d/motion restart
		
	or

		$ sudo service motion restart
		
Motion-Mail will now generate and send an email whenever [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") generates an `on_picture_save` or `on_movie_end` command.

##5. Integrate Motion-Monitor with [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion")

Motion-Monitor is responsible for the starting/stopping of the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") daemon in response to the presence of Internet of Things ([IoT](http://en.wikipedia.org/wiki/Internet_of_Things "Internet of Things")) device IDs (*i.e.*, MAC addresses) on a given network. To integrate this package with [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion"), a separate job scheduler is needed to periodically "wake up" the Motion-Monitor component to check the status of devices on the monitored network. This is done through the implementation of a [cron job](http://en.wikipedia.org/wiki/Cron "Cron") that periodically executes the `motion_monitor_manager.rb` file.

 1. Create a cron job to run Motion-Monitor.

	Edit the system *crontab* (cron table) and add a line that executes the `motion_monitor_manager.rb` file at a regular interval (*e.g.*, every 3 minutes). The example below shows how a *crontab* might be edited on a Debian system:

		$ sudo crontab -e

	This command will open the *crontab* editor. Once in the editor, create a new line that will run `motion_monitor_manager.rb` every 2 minutes as shown in the example below:

		# For more information see the manual pages of crontab(5) and cron(8)
		#
		# m h  dom mon dow   command
	\*/2 * * * * /usr/bin/ruby2.1 /etc/motion-surveillance/motion_monitor/motion_monitor_manager.rb

	> 	**Note:** the location of the Ruby binary may differ depending on the OS distribution. Also use the actual Ruby binary name, and not a symbolic link to the binary (*e.g.*, a call to `which ruby` will return a symbolic link and not the actual Ruby binary name). A quick way to confirm the actual Ruby binary location and name is to run `RbConfig::CONFIG['bindir']` and `RbConfig::CONFIG['ruby_install_name']` in the Ruby interpreter (IRB).

	After saving the updated *crontab*, Motion-Monitor (by way of `motion_monitor_manager.rb`) will "wake up" every 2 minutes to check the state of defined [IoT](http://en.wikipedia.org/wiki/Internet_of_Things "Internet of Things") devices on the network, and start the [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") daemon.
	
##6. Final

At this point, the Motion-Surveillance package should now be properly installed and configured. Once the cron job has been created, Motion-Surveillance should:
 1. Watch for relevant device IDs present on the network at a regular interval.
 2. Start/stop [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") when relevant device IDs leave/join the network.
 3. Generate and send an email when an event of interest is generated by [Motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome "Motion") (assuming that the Motion-Mail component has been installed).

The simplest means for testing the Motion-Surveillance package is to remove a device from the network (*i.e.*, disable the device's networking capability), and watch (or listen, if so configured) Motion-Sureillance processes start/stop. Recall also that individual Motion-Surveillance components can be configured to generate execution log files.

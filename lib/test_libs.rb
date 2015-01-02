require 'test/unit'
require 'logger'

require_relative 'lib_audio'
require_relative 'lib_log'

require_relative '../motion_monitor/motion_monitor_config'

class TestLibs < Test::Unit::TestCase

  # -----------------------------------------------------------------------------------------------
  #
  def test_lib_config

    assert_equal File.file?(LibConfig::APLAY), true
    assert_equal File.file?(LibConfig::ARP), true
    assert_equal File.file?(LibConfig::GREP), true
    assert_equal File.file?(LibConfig::KILLALL), true
    assert_equal File.file?(LibConfig::PING), true
    assert_equal File.file?(LibConfig::PS), true

  end

  # -----------------------------------------------------------------------------------------------
  #
  def test_lib_audio

    assert_equal LibAudio::play_audio(MotionMonitorConfig::AUDIO_MOTION_START), true

  end

  # -----------------------------------------------------------------------------------------------
  #
  def test_lib_log

    LibLog::create_logfile(1, File.expand_path(File.dirname(__FILE__)), "test_lib.log")
    File.delete(File.expand_path(File.dirname(__FILE__)) + '/test_lib.log') if File.exist?(File.expand_path(File.dirname(__FILE__)) + '/test_lib.log')

    assert_not_nil $LOG

  end

end

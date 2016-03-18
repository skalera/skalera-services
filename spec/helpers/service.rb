# Copyright 2015 Skalera Corporation
# All Rights Reserved

# TODO: add logging
# Helper class to run a service during testing (e.g. redis)
class Service
  def initialize(command, args = nil)
    @command = command
    @args = args
    @pid = nil
  end

  def start
    fail "#{@command} is already running with pid #{@pid}" if @pid
    # TODO: check that we can find the command (i.e. `which`)
    @tmpdir = Dir.mktmpdir
    command = [@command, @args].join(' ')
    # @pid = Process.spawn(command, out: :close, err: :close, in: :close, chdir: @tmpdir)
    @pid = Process.spawn(command, in: :close, chdir: @tmpdir)
    wait_until_running
  end

  def stop
    pid = @pid
    @pid = nil

    if running?(pid)
      signal_process('TERM', pid)
      wait_for_exit(pid)
    end
    FileUtils.rm_rf(@tmpdir)
  end

  def wait_until_running
    uri = URI('http://localhost:8500/v1/status/leader')
    Timeout.timeout(10) do
      loop do
        return if leader?(uri)
        sleep(1)
      end
    end
  end

  def leader?(uri)
    response = Net::HTTP.get_response(uri)
    response.is_a?(Net::HTTPSuccess) && response.body != '""'
  rescue Errno::ECONNREFUSED
    false
  end

  def running?(pid)
    pid && Process.kill(0, pid)
  rescue Errno::ESRCH
    false
  rescue Errno::EPERM
    false
  end

  def signal_process(signal, pid)
    Process.kill(signal, pid)
  rescue Errno::ESRCH, Errno::EPERM
    # nothing to do
    true
  end

  def wait_for_exit(pid)
    Timeout.timeout(20) do
      Process.wait(pid)
    end
  rescue Timeout::Error
    signal_process('KILL', pid)
  end
end

# frozen_string_literal: true

# Class of subscribers on PostgreSQL notifications
class DBSubscriber
  include Singleton

  # Initializes instance
  def initialize
    @control_channel = generate_control_channel_name
    @mutex = Thread::Mutex.new
    @channels = {}
  end

  # Shutdowns current notification controller and starts new one
  def start
    shutdown
    sync { @thread = Thread.new { Controller.new(channels, control_channel) } }
  end

  # @!method restart
  #   Shutdowns current notification controller and starts new one
  alias_method :restart, :start

  # Shutdowns current notification controller
  def shutdown
    channels.each_key { |channel| notify(:unsubscribe, channel) }
    sync { channels.clear }
    notify(:shutdown)
  end

  # Adds subscription on channel with provided block as a handler of
  # notifications
  # @param [String] channel
  #   name of the channel
  # @yieldparam [String] payload
  #   payload of notification
  def subscribe(channel, &block)
    channel = channel.to_s
    sync { channels[channel] = block.to_proc }
    notify(:subscribe, channel)
  end

  # Removes subscription on channel
  # @param [String] channel
  #   name of the channel
  def unsubscribe(channel)
    channel = channel.to_s
    sync { channels.delete(channel) }
    notify(:unsubscribe, channel)
  end

  private

  # Synchronization object
  # @return [Thread::Mutex]
  #   synchronization object
  attr_reader :mutex

  # Associative array in which names of channels are keys and notificiation
  # handlers are values
  # @return [Hash{String => Proc}]
  #   associative array in which names of channels are keys and notificiation
  #   handlers are values
  attr_reader :channels

  # Name of control channel
  # @return [String]
  #   name of control channel
  attr_reader :control_channel

  # Template of control channel name
  CONTROL_CHANNEL_TEMPLATE = 'control_channel_%s'

  # Generates and returns new name of control channel
  # @return [String]
  #   new name of control channel
  def generate_control_channel_name
    id = SecureRandom.hex(16).freeze
    format(CONTROL_CHANNEL_TEMPLATE, id).freeze
  end

  # Yields synchronizely
  def sync
    mutex.synchronize { yield }
  end

  # Sends notification to channel with {control_channel} name and payload made
  # from the provided action name and its parameter
  # @param [#to_s] action
  #   action name
  # @param [Object] param
  #   parameter of the action
  def notify(action, param = nil)
    ActiveRecord::Base.connection_pool.with_connection do |connection|
      payload = Payload.generate(action, param)
      payload = connection.quote_string(payload)
      sql = SQL::Builder.notify(control_channel, payload)
      connection.execute(sql).clear
    end
  end
end

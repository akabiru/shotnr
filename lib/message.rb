class Message
  attr_reader :message

  def initialize(flash, status, message)
    @message = message
    @status = status
    @flash = flash
  end

  def set_flash
    @flash[@status.to_sym] = @message
  end
end

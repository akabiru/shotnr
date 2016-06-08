class Message
  def initialize(flash)
    @flash = flash
  end

  def authentication_error
    set_flash("danger", "An error occured while trying to sign you in.")
  end

  private

  def set_flash(status, message)
    @flash[status.to_sym] = message
  end
end

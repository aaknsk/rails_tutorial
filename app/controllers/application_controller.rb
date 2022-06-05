class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "Hello world!"
  end
  
  def hey
    render html: "Hey Hey Hey!"
  end
end

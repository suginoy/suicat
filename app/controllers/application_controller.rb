class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_iphone_format

  private
  def set_iphone_format
    request.formats.insert(0, Mime::Type.new('text/html', :iphone)) if iphone_request?
  end

  def iphone_request?
    request.user_agent =~ /(Mobile.+Safari)/
  end
end

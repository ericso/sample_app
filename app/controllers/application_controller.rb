class ApplicationController < ActionController::Base
  protect_from_forgery

  # SessionsHelper module has code for handling sessions; not included in controllers by default
  include SessionsHelper
end

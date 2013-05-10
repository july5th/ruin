require "ruin_base"

class AdminController < ApplicationController
  def index
  end

  def email
	@emails = Email.all
  end

  def proxy
	@num = Proxy.all.length
	@proxys = Proxy.page(params[:page]).per(30)
  end
end

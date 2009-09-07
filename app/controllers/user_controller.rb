class UserController < ApplicationController
  before_filter :login_required, :except => [ :index ]

  def index
  end

end

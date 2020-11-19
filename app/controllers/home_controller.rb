class HomeController < ApplicationController
  def index
    puts 'The current user is: ', current_user
    if user_signed_in?
      puts 'User login'
      redirect_to groups_path
    else
      puts 'User not login'
    end
  end
end

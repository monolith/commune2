class RatingController < ApplicationController
  before_filter :login_required, :except => [ ]

  def rate
    #do not allow author or idea to rate the idea
    scorecard = params[:scorecard].to_i
    stars = params[:stars].to_i
    s = Scorecard.find scorecard
    
    unless s.scorable.author? current_user

      #need add code to catch errors in case paramets are sent wrong
      
      # this allows only logged in user to vote
      r = current_user.ratings.find_or_create_by_scorecard_id scorecard  
      
      
      previously_rated = true if r.stars
      
      r.stars = stars

      if r.save!
        if previously_rated
          flash[:notice]="Your rating has been updated."
        else
          flash[:notice]="Thank you for rating."
        end
      else
        flash[:error] = "Could not save your rating, sorry."
      end


    else
        flash[:error] = "You cannot modify your own #{s.scorable.class.to_s.downcase} rating, sorry."           
    end # unless


          
     # probably should clean this, with redirect_to scorable, or polymorphic_url
     redirect_back_or_default :back
 
 
  end # rate

end

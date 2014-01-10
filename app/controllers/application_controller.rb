class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :admin?, :embed_video

  protected

  def authorize
    unless user_signed_in?
      flash[:alert] = "Unauthorized access! Please log in first."
      redirect_to root_path
      false
    end
  end

  # given a link to a vimeo video, return the id number for the video to
  # be used in the embed code in the view
  def embed_video( link )
    vimeo_id = /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/.match(link)[6]
    return "<iframe src=\"//player.vimeo.com/video/#{vimeo_id}\" width=\"500\"
    height=\"375\" frameborder=\"0\" webkitallowfullscreen
    mozallowfullscreen allowfullscreen></iframe>".html_safe
  end
end

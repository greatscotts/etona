module UsersHelper

  def gravatar_for(user, options = { :size=> 48 })    
    default_url = "http://icons.iconarchive.com/icons/custom-icon-design/pretty-office-4/48/man-icon.png"
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}" 
    image_tag(gravatar_url)
  end


  def gravatar_edit(user, options = { :size=> 500 })
    default_url = "http://icons.iconarchive.com/icons/custom-icon-design/pretty-office-4/256/man-icon.png"
  	gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=500&d=#{CGI.escape(default_url)}"  
    image_tag(gravatar_url)
end
end

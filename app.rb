require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }


#############
# FUNCTIONS #
#############
helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

def valid_params?(params)
  !params[:name].empty? && !params[:description].empty? && !params[:location].empty?
end

##########
# ROUTES #
##########
get '/' do
  @meetups = Meetup.all
  erb :index
end

get '/show/:id' do
  @meetup   = Meetup.find(params[:id])
  @members  = @meetup.users
  @comments = @meetup.comments
  erb :show, locals: { user_id: session[:user_id] }
end

get '/new' do
  erb :new
end

post '/new' do
  if valid_params?(params)
    Meetup.create!(name: params[:name], description: params[:description], location: params[:location])
    flash[:notice] = "Meetup created successfully"
    last_id = Meetup.all.last.id
    redirect "/show/#{last_id}"
  else
    flash[:notice] = "You need to fill up the fields"
    redirect "/new"
  end
end

get '/join_meetup' do
  new_meetup = UserMeetup.new(params)
  if new_meetup.save
    flash[:notice] = "You joined the group!"
  else
    flash[:notice] = "You are already a member of this group!"
  end

  redirect "/show/#{params[:meetup_id]}"
end

get '/leave_group' do
  UserMeetup.where(user_id: session[:user_id], meetup_id: params[:meetup_id]).destroy_all
  flash[:notice] = "You have left this group!"

  redirect "/show/#{params[:meetup_id]}"
end

post '/new_comment' do
  new_comment = Comment.new(params)
  if new_comment.save
    flash[:notice] = "Post successful"
  else
    flash[:notice] = "The comment cant be blank"
  end

  redirect "/show/#{params[:meetup_id]}"
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end

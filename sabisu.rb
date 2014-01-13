# load gems
require 'sinatra'
require 'redis'
require 'couchrest'
require 'cgi'
require 'json'
require 'pp'

# load shared library
require_relative 'lib'

# load classes
require_relative 'classes/init'

# load routes
require_relative 'routes/init'

# load configuration settings
require_relative 'config'

# URL Routing
before '/:name' do
  force_session_auth unless params[:name] == 'login'
end

get '/' do
  redirect '/login'
end

get '/login' do
  if logged_in?
    redirect '/events'
  else
    clear_session
    haml :login, locals: { remember_me: session[:remember_me] }
  end
end

post '/login' do
  if validate(params[:username], params['password'])
    session[:logged_in] = true
    session[:username] = params[:username]
    session[:remember_me] = params[:username] if params[:remember_me] == 'on'
    redirect '/events'
  else
    haml :login, locals: { message: 'Incorrect username and/or password' }
  end
end

get '/logout' do
  clear_session
  redirect '/login'
end

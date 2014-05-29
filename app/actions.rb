# Homepage (Root path)
helpers do
  # Usable in ERB templates everywhere, and in any action below
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

get '/' do
  erb :index
end

#Login ===========================================

post '/' do
  @user = User.find_by(email: params[:email], password: params[:password])

  if @user
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'auth/login'
  end
end

post '/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/users/show' do
  @projects = current_user.projects
  erb :'users/show'
end
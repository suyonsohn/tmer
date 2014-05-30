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

get '/users/show/:id' do
  @skills = Skill.all
  @projects = current_user.projects
  erb :'users/show'
end

post '/users/show/:id' do
  # binding.pry
  on_boxes = params.select{|k,v| v == "on"}
  on_boxes.each_key do |key|
    UserSkill.create(user_id: current_user.id, skill_id: key.to_s)
  end
  redirect "users/show/#{params[:id]}"
end

get '/project/new' do
  @skills = Skill.all
  erb :'/project/new'
end

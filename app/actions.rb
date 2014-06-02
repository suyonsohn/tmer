# Homepage (Root path)
helpers do
  # Usable in ERB templates everywhere, and in any action below
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def current_project
    @current_project ||= Project.find(session[:project_id]) if session[:project_id]
  end
end

get '/' do
  erb :index, layout: :'homepage'
end

#Login ===========================================

get '/sign_up' do
  erb :sign_up, layout: :'homepage'
end

post '/sign_up' do
  User.create(
    email: params[:email], 
    password: params[:password], 
    first_name: params[:first_name],
    last_name: params[:last_name],
    git_username: params[:git_username],
    password: params[:password]
  )
  session[:user_id] = User.last.id
  redirect "/users/show/#{current_user[:id]}"
end

post '/' do
  @user = User.find_by(email: params[:email], password: params[:password])

  if @user
    session[:user_id] = @user.id
    redirect "/users/show/#{session[:user_id]}"
  else
    erb :'auth/login'
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/users/show/:id' do
  @skills = Skill.all
  @projects = current_user.projects
  erb :'users/show'
end

get '/project/show/:id' do
  session[:project_id] = params[:id]
  @skills = Skill.all
  erb :'project/show'
end

#=============================================================================================
post '/project/show/:id' do
  # session[:project_id] = params[:id]
  current_project.update(description: params[:description])
  ProjectSkill.where(project_id: current_project.id).destroy_all
  on_boxes = params.select{|k,v| v == "on"}
  on_boxes.each_key do |key|
    ProjectSkill.create(project_id: current_project.id, skill_id: key.to_s)
  end
  redirect "project/show/#{params[:id]}"  
end

post '/users/show/:id' do
  UserSkill.where(user_id: current_user.id).destroy_all
  on_boxes = params.select{|k,v| v == "on"}
  on_boxes.each_key do |key|
    UserSkill.create(user_id: current_user.id, skill_id: key.to_s)
  end
  redirect "users/show/#{params[:id]}"
end

get '/project/new' do
  @skills = Skill.all
  session[:project_id] = nil
  erb :'/project/new'#, layout: :'project'
end

post '/project/new' do
  checked_boxes = params.select { |k, v| v == "on"}
  if !current_project
    project = Project.create(
      name: params[:name],
      description: params[:description],
      team_size: params[:team_size],
      user_id: current_user.id
      )
    session[:project_id] = project.id
    checked_boxes.each_key do |key|
      ProjectSkill.create(project_id: project.id, skill_id: key.to_s)
    end
  end
  redirect '/project/match'
end

get '/project/match' do
  users = User.all

  available_skill_ids = available_skill_ids(users)
  project_skill_ids = current_project.skills.pluck(:skill_id)
  project_skill_ids = project_skill_ids.select{|s| available_skill_ids.include?(s)} #gets rid of ids that no user has
  @matches = []

  while !project_skill_ids.empty? && !available_skill_ids.empty?
    match = find_user_with_most_matches(users, project_skill_ids)
    # if !match then break end
    @matches << match
    project_skill_ids = project_skill_ids - match.skills.pluck(:id)
    users = users.where.not(id: match.id)
    available_skill_ids = available_skill_ids(users)
  end

  erb :'/project/match'
end

def available_skill_ids(users)
  users.collect {|u| u.skills.pluck(:id)}.flatten.uniq 
end

def find_user_with_most_matches(users, skill_id_arr)
  max_skills_owner = nil
  max_skills = 0
  users.each do |user|
    current = user.skills.where(id: [skill_id_arr]).count
    if current > max_skills
      max_skills = current
      max_skills_owner = user
    end
  end
  return max_skills_owner
end











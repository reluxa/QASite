@@login_required = [ "accept", "edit", "vote", "save", "comment", "answer"].join("|")

helpers do
  def authenticated()
    return session['user'] != nil
  end

  def current_user()
    return session['user'];
  end

end

get '/login' do
  haml :"auth/login"
end

post '/check' do
  if params[:user] == params[:password]
    session['user'] = params[:user];
    if (session['forwarded'])
      call env.merge(
        "PATH_INFO" => session["PATH_INFO"],
        "QUERY_STRING" => session["QUERY_STRING"],
        "REQUEST_METHOD" => session["REQUEST_METHOD"],
        "REQUEST_URI" => session["REQUEST_URI"]
      )
    else
      redirect '/'
    end
  else
    redirect '/login'
  end
end

get '/logout' do
  session['user'] = nil;
  haml :"auth/logout"
end

before %r{/(#{@@login_required})/?.*} do
  if (!authenticated)
      session['FORWARDED'] = true;
      session['PATH_INFO'] = request.env['PATH_INFO'];
      session['QUERY_STRING'] = request.env['QUERY_STRING'];
      session['REQUEST_METHOD'] = request.env['REQUEST_METHOD'];
      session['REQUEST_URI'] = request.env['REQUEST_URI'];
      redirect "/login";
  end
end
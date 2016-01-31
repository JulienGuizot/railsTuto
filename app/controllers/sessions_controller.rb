class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      # Crée un message d'erreur et rend le formulaire d'identification.
      flash.now[:error] = "invalid identification : email - password"
      @title = "Sign in"
      render 'new'

    else
      # Authentifie l'utilisateur et redirige vers la page d'affichage.
      sign_in user
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end

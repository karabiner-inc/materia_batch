defmodule MateriaBatchWeb.Router do
  use MateriaBatchWeb, :router

  #pipeline :browser do
  #  plug :accepts, ["html"]
  #  plug :fetch_session
  #  plug :fetch_flash
  #  plug :protect_from_forgery
  #  plug :put_secure_browser_headers
  #end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guardian_auth do
    plug Materia.UserAuthPipeline
  end

  pipeline :guardian_auth_acount do
    plug Materia.AccountAuthPipeline
  end

  pipeline :tmp_user_auth do
    plug Materia.UserRegistrationAuthPipeline
  end

  pipeline :pw_reset_auth do
    plug Materia.PasswordResetAuthPipeline
  end

  pipeline :grant_check do
    repo = Application.get_env(:materia, :repo)
    plug Materia.Plug.GrantChecker, repo: repo
  end

  scope "/api", MateriaWeb do
    pipe_through :api

    post "sign-in", AuthenticatorController, :sign_in
    post "refresh", AuthenticatorController, :refresh
    post "tmp-registration", UserController, :registration_tmp_user
    post "request-password-reset", UserController, :request_password_reset

    # resources "/items", ItemController, except: [:new, :edit]
    # resources "/taxes", TaxController, except: [:new, :edit]

  end

  scope "/api", MateriaBatchWeb do
    pipe_through :api

    resources "/job_mst", JobMasterController, except: [:new, :edit]
    resources "/job_schedules", JobScheduleController, except: [:new, :edit]

  end


end

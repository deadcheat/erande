defmodule Zohyohtanksgiving.Router do
  use Zohyohtanksgiving.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Zohyohtanksgiving do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/questions", QuestionController do
      resources "/solutions", SolutionController
      get "/solutions/:id/mark", SolutionController, :mark
      get "/solutions/:id/unmark", SolutionController, :unmark
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Zohyohtanksgiving do
  #   pipe_through :api
  # end
end

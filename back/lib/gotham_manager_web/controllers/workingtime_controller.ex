defmodule GothamManagerWeb.WorkingtimeController do
  require Logger
  use GothamManagerWeb, :controller

  alias GothamManager.Api
  alias GothamManager.Api.Workingtime

  action_fallback GothamManagerWeb.FallbackController

  def index(conn, %{"userID" => user_id, "end" => end_value, "start" => start_value}) do
    workingtime = Api.get_all_workingtimes_from_user(user_id, end_value, start_value)
    render(conn, "index.json", workingtimes: workingtime)
  end

  def show(conn, %{"userID" => userID, "id" => id}) do
    workingtime = Api.get_one_workingtime_by_user_id(userID, id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def create(conn, %{"workingtime" => workingtime_params, "userID" => id}) do
    id = String.to_integer(id)
    with {:ok, %Workingtime{} = workingtime} <- Api.create_workingtime(id, workingtime_params) do
      conn
      |> put_status(:created)
      #|> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Api.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Api.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Api.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Api.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end

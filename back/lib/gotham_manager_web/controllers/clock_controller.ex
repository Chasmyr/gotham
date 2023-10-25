defmodule GothamManagerWeb.ClockController do
  use GothamManagerWeb, :controller

  alias GothamManager.Api
  alias GothamManager.Api.Clock

  action_fallback GothamManagerWeb.FallbackController

  def index(conn, %{"userID" => id}) do
    id = String.to_integer(id)
    clocks = Api.get_clock_by_user(id)
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params, "userID" => id}) do
    id = String.to_integer(id)
    with {:ok, %Clock{} = clock} <- Api.create_clock(id, clock_params) do
      conn
      |> put_status(:created)
      #|> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Api.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Api.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Api.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Api.get_clock!(id)

    with {:ok, %Clock{}} <- Api.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end

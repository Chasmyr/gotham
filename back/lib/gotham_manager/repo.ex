defmodule GothamManager.Repo do
  use Ecto.Repo,
    otp_app: :gotham_manager,
    adapter: Ecto.Adapters.Postgres
end

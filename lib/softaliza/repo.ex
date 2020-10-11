defmodule Softaliza.Repo do
  use Ecto.Repo,
    otp_app: :softaliza,
    adapter: Ecto.Adapters.Postgres
end

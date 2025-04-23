defmodule Cooptour.Repo do
  use Ecto.Repo,
    otp_app: :cooptour,
    adapter: Ecto.Adapters.Postgres
end

defmodule Diceville.Repo do
  use Ecto.Repo,
    otp_app: :diceville,
    adapter: Ecto.Adapters.Postgres
end

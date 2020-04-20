defmodule LiveViewStudio.Repo do
  use Ecto.Repo,
    otp_app: :live_view_studio,
    adapter: Ecto.Adapters.Postgres
end

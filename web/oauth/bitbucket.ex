defmodule Bitbucket do
  @moduledoc """
  An OAuth2 strategy for Bitbucket.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  defp config do
    [strategy: Bitbucket,
     site: "https://api.bitbucket.org/2.0",
     authorize_url: "https://bitbucket.org/site/oauth2/authorize",
     token_url: "https://bitbucket.org/site/oauth2/access_token"]
  end

  defp auth_header(%{client_id: id, client_secret: secret} = client) do
    put_header(client, "Authorization", "Basic " <> Base.encode64(id <> ":" <> secret))
  end

  # Public API

  def client do
    Application.get_env(:oauth2_example, Bitbucket)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), params)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> auth_header
    |> AuthCode.get_token(params, headers)
  end
end

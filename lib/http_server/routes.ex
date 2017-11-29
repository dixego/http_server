defmodule HttpServer.Routes do
  def get_route(route) do
    case Map.get(table(), route) do
      nil -> {:not_found, "404.html"}
      filename -> {:ok, filename}
    end
  end

  def table do
    %{
      "/" => "index.html",
      "/index" => "index.html",
      "/favicon.ico" => "favicon.ico"
    }
  end

end

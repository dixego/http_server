defmodule HttpServer.Command do
  def parse(line) do
    case String.split(line) do
      ["GET", route | tail] -> {:get, route}
      _ -> {:error, :invalid_request}
    end
  end
end

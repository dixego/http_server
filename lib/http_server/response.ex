defmodule HttpServer.Response do

  def build_response({:get, filename}, root) do
    {status, f} = HttpServer.Routes.get_route(filename)
    status_code = case status do
      :ok -> "200 OK"
      :not_found -> "404 Not Found"
    end
    file = File.read! Path.absname(f, root)
    "HTTP/1.1 #{status_code}\r\n\r\n#{file}"
  end

  def build_response({:error, :invalid_request}, _root) do
    "HTTP/1.1 400 Bad Request\r\n\r\n"
  end
end

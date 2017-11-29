require Logger
defmodule HttpServer do
  def accept(port) do
    opts = [:binary, active: false, reuseaddr: true, packet: :raw]
    {:ok, socket} = :gen_tcp.listen(port, opts)
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(HttpServer.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    msg = 
      with {:ok, data} <- read_req(socket),
           req <- HttpServer.Command.parse(data),
           resp <- HttpServer.Response.build_response(req, root())
      do
        IO.inspect data, label: "Incoming request"
        IO.inspect req, label: "Sending response"
        resp
      end
    write_resp(msg, socket)
    serve(socket)
  end

  defp read_req(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_resp({:error, :closed}, _sock) do
    exit(:shutdown)
  end

  defp write_resp(data, socket) do
    :gen_tcp.send(socket, data)
  end

  defp root do
    Path.absname(Application.fetch_env!(:http_server, :root))
  end
end

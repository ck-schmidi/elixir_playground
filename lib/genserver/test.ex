defmodule Test do
  use GenServer

  # Client

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def run_test(pid) do
    GenServer.call(pid, :run_test)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, pid} = Worker.start_link(self())
    {:ok, Map.put(state, :worker_pid, pid)}
  end

  @impl true
  def handle_call(:run_test, _from, %{worker_pid: worker_pid} = state) do
    IO.puts("run genserver test")
    IO.inspect(worker_pid)

    Worker.do_work(worker_pid, 5)
    Worker.do_work(worker_pid, 3)
    Worker.do_work(worker_pid, 3)
    Worker.do_work(worker_pid, 3)

    Worker.state(worker_pid) |> IO.inspect()
    Worker.send_result_after(worker_pid, 3000)

    {:reply, state, state}
  end

  @impl true
  def handle_info({:receive_result, result}, state) do
    IO.puts("received message")
    result |> IO.inspect()
    {:noreply, state}
  end
end

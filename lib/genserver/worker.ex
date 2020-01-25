defmodule Worker do
  use GenServer

  # api
  def start_link(spid) do
    GenServer.start_link(__MODULE__, %{spid: spid, res: 0})
  end

  def do_work(pid, n) do
    GenServer.cast(pid, {:do_work, n})
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  def send_result_after(pid, timeout) do
    GenServer.cast(pid, {:send_result_after, timeout})
  end

  # callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_call(:state, _, state) do
    {:reply, state, state}
  end

  def handle_cast({:do_work, n}, state) do
    {:noreply, %{state | res: state.res + n}}
  end

  def handle_cast({:send_result_after, timeout}, %{spid: spid} = state) do
    Process.send_after(spid, {:receive_result, state.res}, timeout)
    {:noreply, state}
  end
end

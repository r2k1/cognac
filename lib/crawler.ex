defmodule Crawler do
  require Logger
  use GenServer
  @moduledoc """
  Web spider
  """

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.info('Init crawler')
    schedule_work() # Schedule work to be performed on start
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the desired work here
    # Logger.info('Loop')
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1 * 1000) # In 2 hours
  end

  defp initial_queue() do
  end
end
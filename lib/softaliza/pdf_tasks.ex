defmodule Softaliza.PdfJobs do
  use GenServer

  # client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: PdfJobs)
  end

  def lookup(key) do
    state = GenServer.call(PdfJobs, :lookup)

    with {^key, value} <- List.keyfind(state, key, 0) do
      case value do
        :processing ->
          {:error, :processing}

        _ ->
          {:ok, value}
      end
    else
      _ -> {:error, :not_found}
    end
  end

  def insert(key, value) do
    Task.async(fn -> gen_pdf(key, value) end)
  end

  # tasks

  def gen_pdf(key, value) do
    GenServer.cast(PdfJobs, {:insert, key, :processing})

    :timer.sleep(10000)

    GenServer.cast(PdfJobs, {:insert, key, value})
  end

  # server

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:lookup, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:insert, key, value}, state) do
    {:noreply, [{key, value} | state]}
  end
end

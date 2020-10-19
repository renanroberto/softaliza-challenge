defmodule Softaliza.PdfJobs do
  use GenServer

  # client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: PdfJobs)
  end

  def lookup(key) do
    state = GenServer.call(PdfJobs, :lookup)

    with {:ok, value} <- Map.fetch(state, key) do
      if value == :processing do
        {:error, :processing}
      else
        GenServer.cast(PdfJobs, {:delete, key})

        {:ok, value}
      end
    else
      :error -> {:error, :not_found}
    end
  end

  def insert(key, value) do
    Task.async(fn -> gen_pdf(key, value) end)
  end

  # tasks

  def gen_pdf(key, cert) do
    GenServer.cast(PdfJobs, {:insert, key, :processing})

    html = """
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    </head>
    <body>
    <center><h1>Certification</h1></center>
    <p><b>Event:</b> #{cert.event}</p>
    <p><b>Name:</b> #{cert.name}</p>
    </body>
    </html>
    """

    {:ok, pdf} = PdfGenerator.generate_binary(html)
    :timer.sleep(10000)
    GenServer.cast(PdfJobs, {:insert, key, pdf})
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
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_cast({:delete, key}, state) do
    {:noreply, Map.delete(state, key)}
  end
end
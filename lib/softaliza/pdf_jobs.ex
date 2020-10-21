defmodule Softaliza.PdfJobs do
  use GenServer

  # TODO as PDF generation takes less then 1 second, then
  # we can simply generate de PDf on the request process

  # TODO replace cast by call whenever is possible

  # CLIENT

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: PdfJobs)
  end

  def lookup(key) do
    with {:ok, value} <- GenServer.call(PdfJobs, {:lookup, key}) do
      if value == :processing do
        {:error, :processing}
      else
        # TODO if user never ask for PDF, then PDF is never deleted
        GenServer.cast(PdfJobs, {:delete, key})

        {:ok, value}
      end
    else
      :error -> {:error, :not_found}
    end
  end

  def insert(key, cert = %{event: _event, name: _name}) do
    GenServer.call(PdfJobs, {:gen_pdf, key, cert})
  end

  def insert(_key, _cert), do: :error

  # SERVER

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:lookup, key}, _from, state) do
    {:reply, Map.fetch(state, key), state}
  end

  @impl true
  def handle_call({:gen_pdf, key, cert}, _from, state) do
    # TODO fix errors:
    # [error] [message: {#Reference<0.3110335546.3954966532.103079>, :ok},
    # module: Softaliza.PdfJobs, name: PdfJobs]
    # [error] [message: {:DOWN, #Reference<0.3110335546.3954966532.103079>,
    # :process, #PID<0.498.0>, :normal}, module: Softaliza.PdfJobs,
    # name: PdfJobs]

    Task.async(fn -> gen_pdf(key, cert) end)

    {:reply, :ok, state}
  end

  @impl true
  def handle_cast({:insert, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_cast({:delete, key}, state) do
    {:noreply, Map.delete(state, key)}
  end

  # TASKS

  def gen_pdf(key, cert) do
    GenServer.cast(PdfJobs, {:insert, key, :processing})

    # TODO move it to a .html.eex and render with
    # Phoenix.View.render_to_string/3
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

    # TODO handle PDF generation error
    {:ok, pdf} = PdfGenerator.generate_binary(html, delete_temporary: true)

    GenServer.cast(PdfJobs, {:insert, key, pdf})
  end
end

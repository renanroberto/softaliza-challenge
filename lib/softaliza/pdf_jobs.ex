defmodule Softaliza.PdfJobs do
  use GenServer

  # TODO as PDF generation takes less then 1 second, then
  # we can simply generate de PDf on the request process

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
        GenServer.call(PdfJobs, {:delete, key})

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
  def handle_call({:insert, key, value}, _from, state) do
    {:reply, {key, value}, Map.put(state, key, value)}
  end

  @impl true
  def handle_call({:delete, key}, _from, state) do
    {:reply, Map.get(state, key), Map.delete(state, key)}
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

  # TASKS

  def gen_pdf(key, cert) do
    GenServer.call(PdfJobs, {:insert, key, :processing})

    html =
      Phoenix.View.render_to_string(
        SoftalizaWeb.PageView,
        "certificate.html",
        %{cert: cert}
      )

    with {:ok, pdf} <-
           PdfGenerator.generate_binary(html, delete_temporary: true) do
      GenServer.call(PdfJobs, {:insert, key, pdf})
    else
      {:error, _} ->
        GenServer.call(PdfJobs, {:delete, key})
    end
  end
end

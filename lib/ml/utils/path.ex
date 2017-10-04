defmodule ML.Utils.Path do
  @moduledoc """
  A module for creating file paths.
  Useful for instances where you have a large number of classes and need to
  create folders for each class.

  Genserver maintains a `MapSet` of created paths to increase efficiency.
  """
 use GenServer

  # Client
  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def create_path_if_not_exists(path) do
    GenServer.call(__MODULE__, {:mkdir_p, path})
  end

  # Server (callbacks)
  def init(_) do
    {:ok, MapSet.new}
  end

  def handle_call({:mkdir_p, path}, _from, state) do
      File.mkdir_p!(path)
      {:reply, :ok, state}
  end

end

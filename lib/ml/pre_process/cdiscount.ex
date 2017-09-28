defmodule ML.PreProcess.CDiscount do
  @moduledoc """
  Module for preprocessing the CDiscount dataset from the cdiscount kaggle
  competition.
  """

  @doc """
  Time the parsing of bson
  """
  def time_parse_bson do
    {micro_sec, :ok} = :timer.tc(&parse_bson/0)
    IO.puts "Successfully parsed bson in #{micro_sec / 1_000_000}s"
  end


  @doc """
  Asynchronously parse a large bson file
  """
  def parse_bson(path \\ "../data/train.bson") do
    path
    |> BSONEach.stream
    |> Task.async_stream(&parse_document/1, max_concurrency: 8, ordered: false)
    |> Stream.run
  end


  @doc """
  Parse a single bson document and write the resulting img into the correct
  class directory
  """
  def parse_document(%{"_id" => id, "category_id" => cat, "imgs" => imgs}) do
    path = "./output/#{cat}"
    ML.FS.mkdir_p(path)

    imgs
    |> Stream.map(&Map.get(&1, "picture"))
    |> Stream.with_index
    |> Enum.map(fn {i, %BSON.Types.Binary{binary: value}} ->
      File.write("#{path}/#{id}_#{i}.jpg", value)
    end)
  end

end



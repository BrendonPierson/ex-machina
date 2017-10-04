defmodule ML.PreProcess.CDiscount do
  @moduledoc """
  Module for preprocessing the CDiscount dataset from the cdiscount kaggle
  competition.
  """
  alias NimbleCSV.RFC4180, as: CSV

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
  def parse_bson(path \\ "../data") do
    path <> "/train.bson"
    |> BSONEach.stream
    |> Task.async_stream(&parse_document(&1, path <> "/output"), ordered: false, timeout: 30_000)
    |> Stream.run
  end

  @doc """
  Create directories for each category
  """
  def create_category_dirs(output_dir, path_to_cat_names \\ "../data/category_names.csv") do
    path_to_cat_names
    |> File.stream!
    |> CSV.parse_stream
    |> Stream.map(&List.first/1)
    |> Stream.map(fn cat -> output_dir <> "/" <> cat end)
    |> Enum.map(&File.mkdir_p!/1)
  end

  @doc """
  Parse a single bson document and write the resulting img into the correct
  class directory
  """
  def parse_document(%{
    "_id" => id,
    "category_id" => cat,
    "imgs" => imgs,
  }, output_dir) do
    path = "#{output_dir}/#{cat}"

    imgs
    |> Stream.map(&Map.get(&1, "picture"))
    |> Stream.with_index
    |> Enum.map(fn {%BSON.Types.Binary{binary: value}, i} ->
      File.write("#{path}/#{id}_#{i}.jpg", value)
    end)
  end

end



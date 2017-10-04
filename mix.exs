defmodule ML.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ml,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ML, []}
    ]
  end

  defp deps do
    [
      {:bsoneach, "~> 0.4.1"},
      {:nimble_csv, "~> 0.2.0"},
    ]
  end
end

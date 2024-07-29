defmodule Perlin.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo_url "https://github.com/elliotekj/perlin"

  def project do
    [
      app: :perlin,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Elliot Jackson"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp description do
    """
    Ken Perlin's improved Perlin noise algorithm.
    """
  end

  defp docs do
    [
      name: "Perlin",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/perlin",
      source_url: @repo_url
    ]
  end
end

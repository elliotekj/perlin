# Perlin

[![Hex.pm Version](http://img.shields.io/hexpm/v/perlin.svg?style=flat)](https://hex.pm/packages/perlin)
[![Hex Docs](https://img.shields.io/badge/hex%20docs-blue)](https://hexdocs.pm/perlin)
[![Hex.pm License](http://img.shields.io/hexpm/l/perlin.svg?style=flat)](https://hex.pm/packages/perlin)

An implementation of Ken Perlin's improved Perlin noise algorithm in Elixir.

This library provides functions to generate 3D Perlin noise, which can be used
for procedural generation of textures, terrains, and other natural-looking
patterns. It includes both single-octave noise generation and multi-octave noise
for more complex and detailed results.

The implementation is based on Ken Perlin's improved noise function from 2002,
which addressed some of the visual artifacts present in his original 1985
algorithm.

## Features

- 🌐 3D noise generation
- 🔁 Optional repetition of noise pattern
- 🏔️ Multi-octave noise for more natural-looking results
- 🎛️ Configurable persistence for octave-based noise

## Installation

The package can be installed by adding `perlin` to your list of dependencies in
mix.exs:

```elixir
def deps do
  [
    {:perlin, "~> 0.1.0"}
  ]
end
```

## Usage

### Generate noise

```elixir
iex> Perlin.noise(3.14, 42.0, 7.0)
0.5684599793920001
```

### Generate multi-octave noise

```elixir
iex> Perlin.octave(3.14, 42.0, 7.0, 4, 0.5)
0.5530014285141335
```

## License

`Perlin` is released under the [`Apache License 2.0`](https://github.com/elliotekj/perlin/blob/main/LICENSE).

## About

This package was written by [Elliot Jackson](https://elliotekj.com).

- Blog: [https://elliotekj.com](https://elliotekj.com)
- Email: elliot@elliotekj.com

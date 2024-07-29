defmodule Perlin do
  @moduledoc """
  An implementation of Ken Perlin's improved Perlin noise algorithm in Elixir.

  This module provides functions to generate 3D Perlin noise, which can be used
  for procedural generation of textures, terrains, and other natural-looking
  patterns. It includes both single-octave noise generation and multi-octave
  noise for more complex and detailed results.

  The implementation is based on Ken Perlin's improved noise function from 2002,
  which addressed some of the visual artifacts present in his original 1985
  algorithm.

  Key features:
  - 3D noise generation
  - Optional repetition of noise pattern
  - Multi-octave noise for more natural-looking results
  - Configurable persistence for octave-based noise
  """

  import Bitwise

  @permutation [
    151,
    160,
    137,
    91,
    90,
    15,
    131,
    13,
    201,
    95,
    96,
    53,
    194,
    233,
    7,
    225,
    140,
    36,
    103,
    30,
    69,
    142,
    8,
    99,
    37,
    240,
    21,
    10,
    23,
    190,
    6,
    148,
    247,
    120,
    234,
    75,
    0,
    26,
    197,
    62,
    94,
    252,
    219,
    203,
    117,
    35,
    11,
    32,
    57,
    177,
    33,
    88,
    237,
    149,
    56,
    87,
    174,
    20,
    125,
    136,
    171,
    168,
    68,
    175,
    74,
    165,
    71,
    134,
    139,
    48,
    27,
    166,
    77,
    146,
    158,
    231,
    83,
    111,
    229,
    122,
    60,
    211,
    133,
    230,
    220,
    105,
    92,
    41,
    55,
    46,
    245,
    40,
    244,
    102,
    143,
    54,
    65,
    25,
    63,
    161,
    1,
    216,
    80,
    73,
    209,
    76,
    132,
    187,
    208,
    89,
    18,
    169,
    200,
    196,
    135,
    130,
    116,
    188,
    159,
    86,
    164,
    100,
    109,
    198,
    173,
    186,
    3,
    64,
    52,
    217,
    226,
    250,
    124,
    123,
    5,
    202,
    38,
    147,
    118,
    126,
    255,
    82,
    85,
    212,
    207,
    206,
    59,
    227,
    47,
    16,
    58,
    17,
    182,
    189,
    28,
    42,
    223,
    183,
    170,
    213,
    119,
    248,
    152,
    2,
    44,
    154,
    163,
    70,
    221,
    153,
    101,
    155,
    167,
    43,
    172,
    9,
    129,
    22,
    39,
    253,
    19,
    98,
    108,
    110,
    79,
    113,
    224,
    232,
    178,
    185,
    112,
    104,
    218,
    246,
    97,
    228,
    251,
    34,
    242,
    193,
    238,
    210,
    144,
    12,
    191,
    179,
    162,
    241,
    81,
    51,
    145,
    235,
    249,
    14,
    239,
    107,
    49,
    192,
    214,
    31,
    181,
    199,
    106,
    157,
    184,
    84,
    204,
    176,
    115,
    121,
    50,
    45,
    127,
    4,
    150,
    254,
    138,
    236,
    205,
    93,
    222,
    114,
    67,
    29,
    24,
    72,
    243,
    141,
    128,
    195,
    78,
    66,
    215,
    61,
    156,
    180
  ]

  @doc """
  Generates 3D Perlin noise for given coordinates.

  ## Parameters

    * `x` - X coordinate in the noise space
    * `y` - Y coordinate in the noise space
    * `z` - Z coordinate in the noise space
    * `repeat` - Optional. The interval at which the noise pattern repeats. Default is -1 (no repetition).

  ## Returns

  A float value between 0 and 1 representing the noise at the given coordinates.

  ## Example

      iex> Perlin.noise(3.14, 42.0, 7.0)
      0.5684599793920001

      iex> Perlin.noise(3.14, 42.0, 7.0, 5)
      0.44100014719999997
  """
  @spec noise(float(), float(), float(), integer()) :: float()
  def noise(x, y, z, repeat \\ -1) do
    p =
      Enum.reduce(0..(512 - 1), {}, fn x, acc ->
        Tuple.append(acc, Enum.at(@permutation, rem(x, 256)))
      end)

    x = if repeat > 0, do: :math.fmod(x, repeat), else: x
    y = if repeat > 0, do: :math.fmod(y, repeat), else: y
    z = if repeat > 0, do: :math.fmod(z, repeat), else: z

    xi = floor(x) &&& 255
    yi = floor(y) &&& 255
    zi = floor(z) &&& 255

    xf = x - floor(x)
    yf = y - floor(y)
    zf = z - floor(z)

    u = fade(xf)
    v = fade(yf)
    w = fade(zf)

    aaa = elem(p, elem(p, elem(p, xi) + yi) + zi)
    aba = elem(p, elem(p, elem(p, xi) + inc(yi, repeat)) + zi)
    aab = elem(p, elem(p, elem(p, xi) + yi) + inc(zi, repeat))
    abb = elem(p, elem(p, elem(p, xi) + inc(yi, repeat)) + inc(zi, repeat))
    baa = elem(p, elem(p, elem(p, inc(xi, repeat)) + yi) + zi)
    bba = elem(p, elem(p, elem(p, inc(xi, repeat)) + inc(yi, repeat)) + zi)
    bab = elem(p, elem(p, elem(p, inc(xi, repeat)) + yi) + inc(zi, repeat))
    bbb = elem(p, elem(p, elem(p, inc(xi, repeat)) + inc(yi, repeat)) + inc(zi, repeat))

    x1 = lerp(grad(aaa, xf, yf, zf), grad(baa, xf - 1, yf, zf), u)
    x2 = lerp(grad(aba, xf, yf - 1, zf), grad(bba, xf - 1, yf - 1, zf), u)
    y1 = lerp(x1, x2, v)

    x1 = lerp(grad(aab, xf, yf, zf - 1), grad(bab, xf - 1, yf, zf - 1), u)
    x2 = lerp(grad(abb, xf, yf - 1, zf - 1), grad(bbb, xf - 1, yf - 1, zf - 1), u)
    y2 = lerp(x1, x2, v)

    (lerp(y1, y2, w) + 1) / 2
  end

  @doc """
  Generates Perlin noise with multiple octaves.

  ## Parameters

    * `x` - X coordinate in the noise space
    * `y` - Y coordinate in the noise space
    * `z` - Z coordinate in the noise space
    * `octaves` - Number of octaves to sum
    * `persistence` - Amplitude multiplier for each octave

  ## Returns

  A float value between 0 and 1 representing the noise at the given coordinates.

  ## Example

      iex> Perlin.octave(3.14, 42.0, 7.0, 4, 0.5)
      0.5530014285141335
  """
  @spec octave(float(), float(), float(), integer(), float()) :: float()
  def octave(x, y, z, octaves, persistence) do
    {total, max_value, _frequency, _amplitude} =
      Enum.reduce(0..(octaves - 1), {0.0, 0.0, 1.0, 1.0}, fn _,
                                                             {total, max_value, frequency,
                                                              amplitude} ->
        total = total + noise(x * frequency, y * frequency, z * frequency) * amplitude
        max_value = max_value + amplitude
        amplitude = amplitude * persistence
        frequency = frequency * 2
        {total, max_value, frequency, amplitude}
      end)

    total / max_value
  end

  defp fade(t) do
    t * t * t * (t * (t * 6 - 15) + 10)
  end

  defp lerp(a, b, x) do
    a + x * (b - a)
  end

  defp inc(int, repeat) do
    int = int + 1
    if repeat > 0, do: rem(int, repeat), else: int
  end

  defp grad(hash, x, y, z) do
    case hash &&& 0xF do
      0x0 -> x + y
      0x1 -> -x + y
      0x2 -> x - y
      0x3 -> -x - y
      0x4 -> x + z
      0x5 -> -x + z
      0x6 -> x - z
      0x7 -> -x - z
      0x8 -> y + z
      0x9 -> -y + z
      0xA -> y - z
      0xB -> -y - z
      0xC -> y + x
      0xD -> -y + z
      0xE -> y - x
      0xF -> -y - z
      _ -> 0
    end
  end
end

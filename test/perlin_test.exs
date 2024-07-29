defmodule PerlinTest do
  use ExUnit.Case
  doctest Perlin

  describe "noise/4" do
    test "basic noise values" do
      assert Perlin.noise(1.0, 1.0, 1.0) == 0.5
      assert Perlin.noise(3.14, 42.0, 7.0) == 0.5684599793920001
      assert Perlin.noise(3.14, 42.0, 7.0, 5) == 0.44100014719999997
    end

    test "noise values with repeat value" do
      repeat = 10

      noise1 = Perlin.noise(5.7, 3.1, 2.5, repeat)
      noise2 = Perlin.noise(15.7, 13.1, 12.5, repeat)

      assert noise1 >= 0.0 and noise1 <= 1.0
      assert noise2 >= 0.0 and noise2 <= 1.0

      assert_in_delta noise1, noise2, 1.0e-6
    end

    test "noise values are within expected range" do
      for _ <- 1..100 do
        x = :rand.uniform() * 100
        y = :rand.uniform() * 100
        z = :rand.uniform() * 100
        value = Perlin.noise(x, y, z)
        assert value >= 0.0 and value <= 1.0
      end
    end

    test "noise values are consistent for the same input" do
      assert Perlin.noise(1.5, 2.5, 3.5) == Perlin.noise(1.5, 2.5, 3.5)
    end

    test "noise values change smoothly with small input changes" do
      x = 1.0
      y = 2.0
      z = 3.0
      step = 0.1

      Enum.reduce(1..10, Perlin.noise(x, y, z), fn i, previous ->
        current = Perlin.noise(x + i * step, y, z)
        difference = abs(current - previous)
        assert difference < 0.1
        current
      end)
    end

    test "noise values are different for different inputs" do
      refute Perlin.noise(1.0, 2.0, 3.0) == Perlin.noise(1.1, 2.1, 3.1)
    end
  end

  describe "octave/5" do
    test "basic octave noise calculation" do
      assert Perlin.octave(3.14, 42.0, 7.0, 4, 0.5) == 0.5530014285141335
    end

    test "returns a float between 0 and 1" do
      result = Perlin.octave(3.14, 2.718, 1.414, 4, 0.5)
      assert is_float(result)
      assert result >= 0.0 and result <= 1.0
    end

    test "returns consistent results for the same input" do
      result1 = Perlin.octave(1.618, 0.577, 2.236, 4, 0.5)
      result2 = Perlin.octave(1.618, 0.577, 2.236, 4, 0.5)
      assert result1 == result2
    end

    test "different inputs produce different results" do
      result1 = Perlin.octave(0.123, 4.567, 7.890, 4, 0.5)
      result2 = Perlin.octave(9.876, 5.432, 1.098, 4, 0.5)
      assert result1 != result2
    end

    test "increasing octaves increases detail in noise" do
      result1 = Perlin.octave(2.345, 6.789, 0.246, 1, 0.5)
      result2 = Perlin.octave(2.345, 6.789, 0.246, 4, 0.5)
      assert result1 != result2
    end

    test "persistence affects amplitude decay in octave noise" do
      result1 = Perlin.octave(3.579, 1.357, 9.753, 4, 0.5)
      result2 = Perlin.octave(3.579, 1.357, 9.753, 4, 0.8)
      assert result1 != result2
    end

    test "large coordinate values" do
      result = Perlin.octave(1000.1, 2000.2, 3000.3, 4, 0.5)
      assert is_float(result)
      assert result >= 0.0 and result <= 1.0
    end

    test "negative coordinate values" do
      result = Perlin.octave(-1.23, -4.56, -7.89, 4, 0.5)
      assert is_float(result)
      assert result >= 0.0 and result <= 1.0
    end
  end
end

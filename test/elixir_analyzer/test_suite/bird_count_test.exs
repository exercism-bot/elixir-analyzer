defmodule ElixirAnalyzer.ExerciseTest.BirdCountTest do
  use ElixirAnalyzer.ExerciseTestCase,
    exercise_test_module: ElixirAnalyzer.TestSuite.BirdCount

  test_exercise_analysis "example solution",
    comments: [] do
    defmodule BirdCount do
      def today([]), do: nil
      def today([head | _]), do: head

      def increment_day_count([]), do: [1]
      def increment_day_count([head | tail]), do: [head + 1 | tail]

      def has_day_without_birds?([]), do: false
      def has_day_without_birds?([0 | _]), do: true
      def has_day_without_birds?([_ | tail]), do: has_day_without_birds?(tail)

      def total([]), do: 0
      def total([head | tail]), do: head + total(tail)

      def busy_days([]), do: 0
      def busy_days([head | tail]) when head >= 5, do: busy_days(tail) + 1
      def busy_days([_ | tail]), do: busy_days(tail)
    end
  end

  describe "forbids any method of iteration other than recursion" do
    test_exercise_analysis "detects Enum",
      comments: [Constants.bird_count_use_recursion()] do
      [
        defmodule BirdCount do
          def today(list), do: Enum.at(list, 0)
        end,
        defmodule BirdCount do
          def total(list), do: Enum.sum(list)
        end,
        defmodule BirdCount do
          import Enum
          def total(list), do: sum(list)
        end,
        defmodule BirdCount do
          import Enum, only: [sum: 1]
          def total(list), do: sum(list)
        end,
        defmodule BirdCount do
          alias Enum, as: E
          def total(list), do: E.sum(list)
        end,
        defmodule BirdCount do
          alias Enum, as: E
          def total(list), do: E.sum(list)
          def today(list), do: Enum.at(list, 0)
        end
      ]
    end

    test_exercise_analysis "detects List",
      comments: [Constants.bird_count_use_recursion()] do
      [
        defmodule BirdCount do
          def today(list), do: List.first(list)
        end,
        defmodule BirdCount do
          def total(list), do: List.foldl(list, 0, fn a, b -> a + b end)
        end,
        defmodule BirdCount do
          def total(list), do: List.foldr(list, 0, fn a, b -> a + b end)
        end,
        defmodule BirdCount do
          import List
          def today(list), do: first(list)
        end,
        defmodule BirdCount do
          import List, only: [first: 1]
          def today(list), do: first(list)
        end,
        defmodule BirdCount do
          alias List, as: L
          def today(list), do: L.first(list)
        end
      ]
    end

    test_exercise_analysis "detects Stream",
      comments: [Constants.bird_count_use_recursion()] do
      [
        defmodule BirdCount do
          def today(list), do: Stream.take(list, 1)
        end,
        defmodule BirdCount do
          import Stream
          def today(list), do: take(list, 1)
        end,
        defmodule BirdCount do
          import Stream, only: [take: 2]
          def today(list), do: take(list, 1)
        end,
        defmodule BirdCount do
          alias Stream, as: S
          def today(list), do: S.take(list, 1)
        end
      ]
    end

    test_exercise_analysis "detects list comprehensions",
      comments: [Constants.bird_count_use_recursion()] do
      [
        defmodule BirdCount do
          def has_day_without_birds?(list) do
            [] != for day <- list, day == 0, do: day
          end
        end,
        defmodule BirdCount do
          def has_day_without_birds?(list) do
            [] !=
              for day <- list, day == 0 do
                day
              end
          end
        end,
        defmodule BirdCount do
          def has_day_without_birds?(list) do
            [] !=
              for day <- list, day == 0 do
                :something
                day
              end
          end
        end,
        defmodule BirdCount do
          def has_day_without_birds?(list) do
            [] !=
              for day <- list, day == 0 && is_integer(day) do
                day
              end
          end
        end,
        defmodule BirdCount do
          def has_day_without_birds?(list) do
            [] !=
              for day <- list, day == 0 && is_integer(day) do
                3 + 4
                day
              end
          end
        end,
        defmodule BirdCount do
          def has_day_without_birds?(list) do
            [] !=
              for day <- list, day == 0 && is_integer(day), into: [] do
                day
              end
          end
        end,
        defmodule BirdCount do
          def has_day_without_birds?(list) do
            [] !=
              for day <- list, day == 0 && is_integer(day), into: [] do
                :foo > :bar
                day
              end
          end
        end
      ]
    end
  end
end

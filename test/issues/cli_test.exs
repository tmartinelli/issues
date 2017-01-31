defmodule CliTest do
  use ExUnit.Case
  doctest Issues.CLI

  import Issues.CLI, only: [ parse_args: 1, sort_in_ascending_order: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args([ "-h", "anything" ]) == :help
    assert parse_args([ "--help", "anything" ]) == :help
  end

  test "three values returned if three values given" do
    assert parse_args([ "user", "project", "count" ]) == { "user", "project", "count" }
    assert parse_args([ "user", "project", 99 ]) == { "user", "project", 99 }
  end

  test "count is defaulted if two values given" do
    assert parse_args([ "user", "project" ]) == { "user", "project", 4 }
  end

  test ":help returned if no args given" do
    assert parse_args([]) == :help
  end

  test "sort in ascending order in correct way" do
    issues = ["c", "b", "a"] |> fake_issues |> sort_in_ascending_order
    expected = for issue <- issues, do: issue |> Map.get(:created_at)
    assert expected == ["a", "b", "c"]
  end

  defp fake_issues(values) do
    for value <- values, do: %{ created_at: value, other_value: "xxx" }
  end
end

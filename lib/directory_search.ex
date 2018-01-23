defmodule DirectorySearch do

    def search(name, {:ok, files}) do
        Enum.filter(files, fn x -> x == name end)
    end

    def search(_, _, {:error, reason}) do
        {:error, reason}
    end

    def deep_search(current, {:ok, files}) do
    end

    def deep_search(_, {:error, reason}) do
    end

    def match?(path, name) do
    end

end

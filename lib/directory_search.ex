defmodule DirectorySearch do

    def search(name, { :ok, files }) do
        { :ok, Enum.filter(files, fn(file) -> Regex.match?(~r/.*#{name}.*/, file) end) }
    end

    def search(_, _, { :error, reason }) do
        { :error, reason }
    end

    def directories({ :ok, files }) do
        Enum.filter(files, fn(file) -> File.dir?(file) end)
    end

    def directories({ :error, reason }) do
        { :error, reason }
    end

    def deep_search(path, { :ok, files }) do
        results = Enum.filter(files, fn(file) -> Regex.match?(~r/.*#{name}.*/, file) end)
        directories = files
            |> Stream.filter(fn(file) -> File.dir?(file) end)
            |> Enum.map(fn(file) -> Path.join(path, file)
        { :ok, results, directories }
    end

    def deep_search({ :error, reason }) do
        { :error, reason }
    end

end

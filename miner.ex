defmodule LightMiner do

    import DirectorySearch as DS

    def mine(server) do
        send server, { :ready, self }
        receive do
            { :search, client, name, path } ->
                send client, searched(name, path)
            { :dig, client, path } ->
                send client, dug(path)
            { :exit } ->
                exit(:normal)
        end
    end

    defp searched(name, path) do
        case DS.search(name, File.ls(path)) do
            { :ok, files }     -> { :searched, files }
            { :error, reason } -> { :error, reason }
        end
    end

    defp dug(path) do
        case DS.directories(File.ls(path)) do
            { :ok, directories } ->
                veins = Enum.map(directories, fn(directory) -> Path.join(path, directory)
                { :outcrop, veins }
            { :error, reason } ->
                { :error, reason }
        end
    end

end

defmodule HeavyMiner do

    import DirectorySearch as DS

    def mine(server) do
        send server, { :ready, self }
        receive do
            { :mine, client, name, path } ->
                send client, { :result, DS.deep_search(name, path) }
            { :exit } ->
                exit(:normal)
        end
    end

    def mined(name, path) do
        case DS.deep_search(File.ls(path)) do
            { :ok, results, directories } -> { :mined, results , directories }
            { :error, reason } -> { :error, reason }
    end

end

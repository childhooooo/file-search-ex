defmodule Server do

    def start_light(num_processes, module, function, name, path) do
        (1..num_processes)
        |> Enum.map(fn(_) -> spawn(module, function, [self]) end)
        |> schedule_light_mining(name, [path], [path], [])
    end

    def start_heavy(num_processes, module, function, name, path) do
        (1..num_processes)
        |> Enum.map(fn(_) -> spawn(module, function, [self]) end)
        |> schedule_heavy_mining(name, [path], [])
    end

    defp schedule_light_mining(processes, name, queue_search, queue_dig, queue_result) do
        receive do
            { :ready, pid } when length(queue_result) > 0 ->
                [ next | tail ] = queue_result
                send pid, { :report, self, next }
                schedule_light_mining(processes, name, queue_search, queue_dig, tail)
            { :ready, pid } when length(queue_search) > 0 ->
                [ next | tail ] = search
                send pid, { :search, self, name, next }
                schedule_light_mining(processes, name, tail, queue_dig, queue_result)
            { :ready, pid } when length(queue_dig) > 0 ->
                [ next | tail ] = queue_dig
                send pid, { :dig, self, next }
                schedule_light_mining(processes, name, queue_search, tail, queue_result)
            { :ready, pid } ->
                send pid, { :shutdown }
                if length(processes) > 1 do
                    schedule_light_mining(List.delete(processes, pid), name, queue_search, queue_dig, queue_result)

            { :error, reason } ->
                schedule_light_mining(processes, name, queue_search, queue_dig, reason ++ queue_result)
            { :searched, golds } ->
                schedule_light_minign(processes, name, queue_search, queue_dig, results ++ queue_result)
            { :outcrop, veins } ->
                schedule_light_mining(processes, name, veins ++ queue_search, veins ++ queue_dig, queue_result)
        end
    end

    defp schedule_heavy_mining(processes, name, queue_mine, queue_result) do
        receive do
            { :ready, pid } when length(queue_result) > 0 ->
                [ next | tail ] = queue_result
                send pid, { :report, self, next }
                schedule_heavy_mining(processes, name, queue_mine, tail)
            { :ready, pid } when length(queue_mine) > 0 ->
                [ next | tail ] = queue_mine
                send pid, { :mine, self, next }
                schedule_heavy_mining(processes, name, tail, queue_result)
            { :ready, pid } ->
                if length(processes) > 1 do
                    schedule_heavy_mining(List.delete(processes, pid), name, queue_mine, queue_result)

            { :error, reason } ->
                schedule_heavy_mining(processes, name, queue_mine, reason ++ queue_result)
            { :mined, golds, veins } ->
                schedule_heavy_mining(processes, name, veins ++ queue_mine, golds ++ queue_result)
        end
    end

end

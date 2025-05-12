defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def get_time() do
    date = DateTime.utc_now()
    just_time = DateTime.to_string(date) |> String.split("T") |> List.last()
    just_time |> String.split(".") |> List.first()
  end

  def mount(_params, _session, socket) do
    win_number = Enum.random(1..10)
    IO.inspect(socket)

    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       time: get_time(),
       win_number: Integer.to_string(win_number),
       sucess: false
     )}
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
    <h2>
      {@message} It's {@time}
    </h2>
    <br />
    <%= if !@success do %>
      <h2>
        <%= for n <- 1..10 do %>
          <.link
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
            phx-click="guess"
            phx-value-number={n}
          >
            {n}
          </.link>
        <% end %>
      </h2>
    <% else %>
      <.link
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
        patch={~p"/guess"}
      >
        Restart
      </.link>
    <% end %>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    success = guess == socket.assigns.win_number

    message =
      if success,
        do: "Your guess: #{guess}. Correct! ✨",
        else: "Your guess: #{guess}. Wrong. Guess again. ❌"

    score = if success, do: socket.assigns.score + 1, else: socket.assigns.score - 1

    time = get_time()

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time,
        success: success
      )
    }
  end

  def handle_params(_unsigned_params, _uri, socket) do
    new_win_number = Enum.random(1..10)

    {:noreply, assign(socket, success: false, win_number: Integer.to_string(new_win_number))}
  end
end

defmodule DicevilleWeb.PageLive do
  use DicevilleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Diceville.PubSub, "roll_channel")

    {:ok,
      socket
      |> assign(roll_result: nil)
      |> assign(username: nil)
      |> assign(rollers: %{})
    }
  end

  @impl true
  def handle_event("set_username", params, socket) do
    {:noreply, assign(socket, username: params["username"])}
  end

  @impl true
  def handle_event("roll", _params, socket) do
    roll = Enum.random(1..12)

    Phoenix.PubSub.broadcast(
      Diceville.PubSub,
      "roll_channel",
      {:new_roll, %{roll: roll, username: socket.assigns.username}}
    )

    {:noreply, assign(socket, roll_result: roll)}
  end

  @impl true
  def handle_info({:new_roll, payload}, socket) do
    rollers = Map.put(socket.assigns.rollers, payload.username, payload.roll)

    {:noreply,
      socket
      |> assign(:rollers, rollers)
    }
  end
end

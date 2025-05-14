defmodule PentoWeb.QuestionLive.Show do
  use PentoWeb, :live_view

  alias Pento.Faq

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:question, Faq.get_question!(id))}
  end

  @impl true
  def handle_event("vote_up", _params, socket) do
    with {:ok, updated_question} <-
           Faq.vote_up_question(socket.assigns.question) do
      {:noreply,
       assign(socket, :question, updated_question)
       |> put_flash(:info, "Question voted successfully")}
    else
      _ ->
        {:noreply, socket |> put_flash(:error, "Question cannot be voted")}
    end
  end

  defp page_title(:show), do: "Show Question"
  defp page_title(:edit), do: "Edit Question"
end

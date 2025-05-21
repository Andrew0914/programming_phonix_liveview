defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Rating

  import PentoWeb.CoreComponents

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign_rating() |> clear_form()}
  end

  @impl true
  def handle_event("save", %{"rating" => params}, socket) do
    {:noreply, socket |> save_rating(params)}
  end

  defp assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    assign(socket, rating: %Rating{user_id: user.id, product_id: product.id})
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp clear_form(%{assigns: %{rating: rating}} = socket) do
    assign_form(socket, Survey.change_rating(rating))
  end

  def save_rating(socket, params) do
    case Survey.create_rating(params) do
      {:ok, rating} ->
        product = %{socket.assigns.product | ratings: [rating]}
        send(self(), {:rating_product_created, product, socket.assigns.product_index})
        socket |> clear_form()

      {:error, %Ecto.Changeset{} = changeset} ->
        socket |> assign_form(changeset)
    end
  end
end

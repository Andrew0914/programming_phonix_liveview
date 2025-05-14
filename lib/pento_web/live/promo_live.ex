defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_recipient() |> clear_form()}
  end

  defp assign_recipient(socket) do
    assign(socket, :recipient, %Recipient{})
  end

  defp clear_form(socket) do
    changeset = Promo.change_recipient(socket.assigns.recipient)
    assign_form(socket, changeset)
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"recipient" => params}, socket) do
    changeset =
      Promo.change_recipient(socket.assigns.recipient, params) |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"recipient" => params}, socket) do
    changeset = Promo.change_recipient(socket.assigns.recipient, params)
    IO.inspect(socket.assigns.recipient)

    with true <- changeset.valid?,
         {:ok, _} <- Promo.send_promo(socket.assigns.recipient, params) do
      {:noreply, socket |> put_flash(:info, "Promo code was sent")}
    else
      _ -> {:noreply, socket |> put_flash(:error, "Failed to send promo code")}
    end
  end
end

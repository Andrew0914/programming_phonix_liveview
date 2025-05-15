defmodule Pento.Promo do
  alias Pento.Promo.Recipient
  alias Pento.Accounts.UserNotifier

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(user, attrs) do
    with {:ok, _email} <-
           UserNotifier.deliver_promotion(
             user,
             Map.get(attrs, "email"),
             Map.get(attrs, "first_name")
           ) do
      {:ok, %Recipient{}}
    else
      _ -> {:error, "email_not_sent"}
    end
  end
end

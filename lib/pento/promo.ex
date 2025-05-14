defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(_recipient, _attrs) do
    # send email promo recipient
    # TODO: Implement email sending logic
    IO.puts("Sending email 📧...")
    {:ok, %Recipient{}}
  end
end

defmodule Pento.Faq.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :question, :string
    field :answer, :string
    field :votes, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false

  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question, :answer, :votes])
    |> validate_required([:question])
    |> put_default_votes()
  end

  @doc false
  defp put_default_votes(changeset) do
    case get_field(changeset, :votes) do
      nil -> put_change(changeset, :votes, 0)
      _ -> changeset
    end
  end
end

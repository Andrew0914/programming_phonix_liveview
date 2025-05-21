defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Accounts.User

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    field :education, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :year_of_birth, :user_id, :education])
    |> validate_required([:gender, :year_of_birth, :user_id, :education])
    |> validate_inclusion(:gender, ["male", "female", "prefer not to say"])
    |> validate_inclusion(:year_of_birth, 1920..2025)
    |> validate_inclusion(:education, [
      "high school",
      "bachelor's degree",
      "graduate degree",
      "other",
      "prefer not to say"
    ])
    |> unique_constraint(:user_id)
  end
end

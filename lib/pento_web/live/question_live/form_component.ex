defmodule PentoWeb.QuestionLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Faq

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage question records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="question-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:question]} type="text" label="Question" />
        <.input field={@form[:answer]} type="text" label="Answer" />

        <h3 class="text-lg font-bold">
          Votes: {@question.votes} <.icon name="hero-hand-thumb-up-solid" class="w-5 h-5 mr-2" />
        </h3>
        <:actions>
          <.button phx-disable-with="Saving...">Save Question</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{question: question} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Faq.change_question(question))
     end)}
  end

  @impl true
  def handle_event("validate", %{"question" => question_params}, socket) do
    changeset = Faq.change_question(socket.assigns.question, question_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"question" => question_params}, socket) do
    save_question(socket, socket.assigns.action, question_params)
  end

  defp save_question(socket, :edit, question_params) do
    case Faq.update_question(socket.assigns.question, question_params) do
      {:ok, question} ->
        notify_parent({:saved, question})

        {:noreply,
         socket
         |> put_flash(:info, "Question updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_question(socket, :new, question_params) do
    case Faq.create_question(question_params) do
      {:ok, question} ->
        notify_parent({:saved, question})

        {:noreply,
         socket
         |> put_flash(:info, "Question created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

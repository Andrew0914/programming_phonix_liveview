defmodule PentoWeb.SurveyLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "SurveyLive" do
    setup [:register_and_log_in_user]

    test "Should show demographic data after submiting the form", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/survey")

      form_params = %{
        "demographic" => %{
          year_of_birth: "1993",
          gender: "male",
          education: "graduate degree"
        }
      }

      view
      |> element("#demographic_form")
      |> render_submit(form_params)

      # Because we are sending a message to the parent view from child component
      :timer.sleep(2)

      updated_view = render(view)
      assert updated_view =~ "Demographics"
      assert updated_view =~ "1993"
      assert updated_view =~ "male"
      assert updated_view =~ "graduate degree"
    end
  end
end

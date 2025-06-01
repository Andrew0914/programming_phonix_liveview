defmodule PentoWeb.DashboardLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Pento.{Accounts, Survey, Catalog}

  @create_product_attrs %{
    name: "Test Game",
    description: "test description",
    unit_price: 120.5,
    sku: 797_877
  }

  @create_user_attrs %{
    email: "test1@examplex.com",
    password: "password1234",
    username: "testuserx"
  }

  @create_user_attrs2 %{
    email: "test2@examplex.com",
    password: "password5678",
    username: "testuserx2"
  }

  @create_user_attrs3 %{
    email: "test3@examplex.com",
    password: "password5678",
    username: "testuserx3"
  }

  @create_demographic %{
    year_of_birth: DateTime.utc_now().year - 15,
    gender: "female",
    education: "other"
  }

  @create_demographic_over_18 %{
    year_of_birth: DateTime.utc_now().year - 30,
    gender: "female",
    education: "graduate degree"
  }

  defp product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp demographic_fixture(user, attrs) do
    attrs = Map.put(attrs, :user_id, user.id)
    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  defp rating_fixture(user, product, stars) do
    {:ok, rating} =
      Survey.create_rating(%{user_id: user.id, product_id: product.id, stars: stars})

    rating
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_rating(user, product, stars) do
    rating = rating_fixture(user, product, stars)
    %{rating: rating}
  end

  defp create_demographic(user, attrs \\ @create_demographic) do
    demographic = demographic_fixture(user, attrs)
    %{demographic: demographic}
  end

  describe "Survey results" do
    setup [:register_and_log_in_user_as_admin, :create_product, :create_user]

    setup %{user: user, product: product} do
      create_demographic(user)
      create_rating(user, product, 2)

      user2 = user_fixture(@create_user_attrs2)
      create_demographic(user2, @create_demographic_over_18)
      create_rating(user2, product, 3)
      :ok
    end

    test "it filters by age group", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/admin/dashboard")
      params = %{"age_group_filter" => "18 and under"}

      assert view
             |> element("#age-group-form")
             |> render_change(params) =~ "<title>2.00</title>"
    end

    test "it updates to display newly created rating", %{conn: conn, product: product} do
      {:ok, view, html} = live(conn, "/admin/dashboard")
      assert html =~ "2.50"
      user3 = user_fixture(@create_user_attrs3)
      create_demographic(user3)
      create_rating(user3, product, 3)
      send(view.pid, %{event: "rating_created"})
      :timer.sleep(2)
      # need to render the view again after sending the event
      assert render(view) =~ "2.67"
    end
  end
end

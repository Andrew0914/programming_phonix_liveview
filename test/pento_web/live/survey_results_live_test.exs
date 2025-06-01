defmodule PentoWeb.SurveyResultsLiveTest do
  use PentoWeb.ConnCase
  alias Pento.Accounts
  alias PentoWeb.Live.Admin.SurveyResultsLive
  alias Pento.{Admin, Survey, Catalog}

  @create_product_attrs %{
    description: "Test Game",
    unit_price: 100,
    name: "Test Game",
    sku: 908_070
  }

  @create_user_attrs %{
    email: "test@example.com",
    password: "password1234",
    username: "testuser"
  }

  @create_user_attrs2 %{
    email: "test2@example.com",
    password: "password5678",
    username: "testuser2"
  }

  @create_demographic %{
    year_of_birth: DateTime.utc_now().year - 30,
    gender: "male",
    education: "graduate degree"
  }

  @create_demographic2 %{
    year_of_birth: DateTime.utc_now().year - 15,
    gender: "female",
    education: "other"
  }

  defp product_fixture() do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp demographic_fixture(user, attrs \\ @create_demographic) do
    attrs = attrs |> Map.merge(%{user_id: user.id})
    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  defp rating_fixture(stars, user, product) do
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

  defp create_rating(stars, user, product) do
    rating = rating_fixture(stars, user, product)
    %{rating: rating}
  end

  defp create_demographic(user) do
    demographic = demographic_fixture(user)
    %{demographic: demographic}
  end

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  defp update_socket(socket, user) do
    %{socket | assigns: Map.merge(socket.assigns, Map.new([{key, value}]))}
  end

  defp assert_keys(socket, key, value) do
    assert socket.assigns[key] == value
    socket
  end

  describe "Socket State" do
    setup [
      :create_user,
      :create_product,
      :create_socket,
      :register_and_log_in_user
    ]

    setup %{user: user} do
      create_demographic(user)
      user2 = user_fixture(@create_user_attrs2)
      demographic_fixture(user2, @create_demographic2)
      [user2: user2]
    end

    test "no ratings exists", %{socket: socket} do
      socket =
        socket
        |> SurveyResultsLive.assign_filter(%{"gender_filter" => "all"})
        |> SurveyResultsLive.assign_products_with_average_ratings()

      assert socket.assigns.products_with_average_ratings == [{"Test Game", 0}]
    end

    test "ratings exist", %{socket: socket, product: product, user: user} do
      create_rating(2, user, product)

      socket =
        socket
        |> SurveyResultsLive.assign_filter(%{"gender_filter" => "all"})
        |> SurveyResultsLive.assign_products_with_average_ratings()

      assert socket.assigns.products_with_average_ratings == [{"Test Game", 2.0}]
    end

    test "ratings are filtered by age group", %{
      socket: socket,
      product: product,
      user: user,
      user2: user2
    } do
      create_rating(2, user, product)
      create_rating(3, user2, product)

      socket =
        socket
        |> SurveyResultsLive.assign_filter(%{"age_group_filter" => "18 and under"})
        |> SurveyResultsLive.assign_products_with_average_ratings()

      assert socket.assigns.products_with_average_ratings == [{"Test Game", 3.0}]
    end
  end
end

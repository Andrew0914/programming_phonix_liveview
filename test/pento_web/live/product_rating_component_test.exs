defmodule PentoWeb.ProductRatingComponentTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PentoWeb.RatingLive.Index
  alias Pento.Catalog.Product
  alias Pento.Accounts.User

  describe "Product rating" do
    test "should show product form when does not have rating yet" do
      product = %Product{ratings: [], id: 1}
      current_user = %User{id: 1, email: "test@example.com"}

      result =
        render_component(&Index.product_rating/1,
          product: product,
          current_user: current_user,
          index: 0
        )

      assert result =~ "product-rating-form-1"
      refute result =~ "hero-star-solid"
    end

    test "should show product rating when has rating" do
      product = %Product{ratings: [%{stars: 2}], id: 1}
      current_user = %User{id: 1, email: "test@example.com"}

      result =
        render_component(&Index.product_rating/1,
          product: product,
          current_user: current_user,
          index: 0
        )

      refute result =~ "product-rating-form-1"
      assert result =~ "hero-star-solid"
    end
  end
end

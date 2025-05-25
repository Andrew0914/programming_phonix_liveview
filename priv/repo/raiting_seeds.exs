import Ecto.Query

alias Pento.Accounts.User
alias Pento.Catalog.Product

alias Pento.{Repo, Accounts, Survey}

for i <- 1..45 do
  Accounts.register_user(%{email: "user#{i}@exxample.com" , password: "userpassword#{i}", username: "user#{i}"})
end

user_ids = Repo.all(from(u in User, select: u.id))

products_ids = Repo.all(from(p in Product, select: p.id))

gender = ["male", "female", "prefer not to say"]
years = 1960..2017
stars= 1..5
education = [ "high school","bachelor's degree", "graduate degree", "other", "prefer not to say"]

for uid <- user_ids do
  Survey.create_demographic(%{
    user_id: uid,
    gender: Enum.random(gender),
    year_of_birth: Enum.random(years),
    education: Enum.random(education)
  })
end

for uid <- user_ids do
  Survey.create_rating(%{
    user_id: uid,
    product_id: Enum.random(products_ids),
    stars: Enum.random(stars)
  })
end

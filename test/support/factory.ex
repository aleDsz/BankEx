defmodule BankEx.Factory do
  use ExMachina

  @genders ~w(M F O)

  def user_factory() do
    %{
      name: Faker.Person.name(),
      email: Faker.Internet.email(),
      cpf: Brcpfcnpj.cpf_generate(),
      birth_date: Faker.Date.date_of_birth(),
      gender: Enum.random(@genders),
      city: Faker.Address.city(),
      state: Faker.Address.state(),
      country: Faker.Address.country()
    }
  end
end

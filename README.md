# BankEx 

## Installation

To install our application, you can run `docker-compose` to it:

```sh
# Start all applications
$ docker-compose up --build
```

## Business Logic

To create a new user, you can send the parameters:

```sh
$ curl \
  X POST "http://localhost:4000/users" \
  -H "accept: application/json" \
  -H "content-type: application/json" \
  -d "{ \"birth_date\": \"1996-05-07\", \"city\": \"São Paulo\", \"country\": \"Brazil\", \"cpf\": \"08716310080\", \"email\": \"alexandre@teste.com\", \"password\": \"123456\", \"gender\": \"M\", \"name\": \"Alexandre de Souza\", \"state\": \"São Paulo\"}"
```

And it will generate the response:

```json
{
  "message": "User created successfully",
  "referral_code": "44090390"
}
```

With this, you can create an user with indication like:

```sh
$ curl \
  X POST "http://localhost:4000/users" \
  -H "accept: application/json" \
  -H "content-type: application/json" \
  -d "{ \"birth_date\": \"1996-05-07\", \"city\": \"São Paulo\", \"country\": \"Brazil\", \"cpf\": \"08716310080\", \"email\": \"alexandre2@teste.com\", \"password\": \"123456\", \"gender\": \"M\", \"name\": \"Alexandre de Souza\", \"state\": \"São Paulo\", \"referral_code\": \"44090390\"}"
```

## Documentation

You can access Swagger using the route `http://localhost:4000/docs`, and before that you need to generate Swagger file.

Just run `mix swagger`.

## Development

You need to define the environment variable `DATABASE_URL` with yout database connection string for PostgreSQL:

```sh
$ export DATABASE_URL="postgres://bankex:bankex@database:5432/bankex"
$ iex -S mix phx.server
```

## Tests

You can run all tests locally using the command:

```sh
$ mix setup                   # Create database
$ mix test --trace            # Run all tests
$ mix test.watcher --trace    # Run all tests with watcher
```

## Contributing

To contribute you need to:

1. Fork this repo
2. Create a new branch, i.e.: `feature/awesome-commit`
3. Push your code to your fork
4. Create a pull-request to this repo
5. Await to code review ✨
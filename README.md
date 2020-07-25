# BankEx 

## Installation

To install our application, you can run `docker-compose` to it:

```sh
# Start all applications
$ docker-compose up --build
```

## Documentation

You can generate Elixir documentation just running `mix docs`.
But, you can access Swagger using the route `http://localhost:4000/v1/docs`, and before that you need to generate Swagger file.

Just run `mix swagger`.

## Development

By convention, you can use our Insomnia/Postman workspace to call our routes with pre-defined body. Use our `insomnia.json` file to import to your Insomnia/Postman

## Tests

You can run all tests locally using the command:

```sh
$ mix setup           # Create database with seeds
$ mix test --trace    # Run all tests based on seeds
```

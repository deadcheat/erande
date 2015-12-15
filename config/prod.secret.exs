use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :zohyothanksgiving, Zohyothanksgiving.Endpoint,
  secret_key_base: "a3TMnYCR6/jj4GNIIRg8Le7tIBVe6APqEpnGB2au4NO0adYN0U7+tun137pBAiRN"

# Configure your database
config :zohyothanksgiving, Zohyothanksgiving.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "zohyothanksgiving_prod",
  pool_size: 20

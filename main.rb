require "time"

require_relative "user"
require_relative "transaction"
require_relative "bank"
require_relative "cba_bank"

File.write("app.log", "")

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

outside_bank_users = [
  User.new("Menna", 400)
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(outside_bank_users[0], -100)
]

bank = CBABank.new(users)

bank.process_transactions(transactions) do |success, transaction, reason|

  if success
    puts "Call endpoint for success of #{transaction}"
  else
    puts "Call endpoint for failure of #{transaction} with reason #{reason}"
  end

end
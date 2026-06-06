class User
  attr_reader :name
  attr_accessor :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end

  def update_balance(value)
    raise "Not enough balance" if @balance + value < 0

    @balance += value
  end
end
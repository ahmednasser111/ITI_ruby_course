require_relative "logger"

class CBABank < Bank
  include Logger

  def initialize(users)
    @users = users
  end

  def process_transactions(transactions, &callback)
    log_info(
      "Processing Transactions #{transactions.map(&:to_s).join(', ')}..."
    )

    transactions.each do |transaction|
      begin
        unless @users.include?(transaction.user)
          raise "#{transaction.user.name} not exist in the bank!!"
        end

        transaction.user.update_balance(transaction.value)

        log_info("#{transaction} succeeded")

        if transaction.user.balance.zero?
          log_warning("#{transaction.user.name} has 0 balance")
        end

        callback.call(
          true,
          transaction,
          nil
        )

      rescue => e
        log_error("#{transaction} failed with message #{e.message}")

        callback.call(
          false,
          transaction,
          e.message
        )
      end
    end
  end
end
namespace :articles do
  desc "Delete heavily reported articles"

  task cleanup: :environment do
    Article.where(
      "reports_count >= ?",
      6
    ).destroy_all
  end
end
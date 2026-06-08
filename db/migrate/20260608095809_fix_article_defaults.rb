class FixArticleDefaults < ActiveRecord::Migration[8.0]
  def change
    change_column_default :articles, :reports_count, 0
    change_column_default :articles, :archived, false
  end
end
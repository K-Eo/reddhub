class AddContentHtmlToPods < ActiveRecord::Migration[5.2]
  def change
    add_column :pods, :content_html, :text
  end
end

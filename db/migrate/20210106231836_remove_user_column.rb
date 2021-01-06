class RemoveUserColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :notes, :user, :string
  end
end

class RenameBodyColumn < ActiveRecord::Migration
  def change
    rename_column(:pastes, :text, :body)
  end
end

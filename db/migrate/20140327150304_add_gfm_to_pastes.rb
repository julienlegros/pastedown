class AddGfmToPastes < ActiveRecord::Migration
  def change
    add_column :pastes, :gfm, :boolean, null: false, default: true
  end
end

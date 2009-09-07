class AddDeltaToWatchlistsAndInterests < ActiveRecord::Migration
  def self.up
    add_column :watchlists, :delta, :text
    add_column :interests, :delta, :text

  end

  def self.down
    remove_column :watchlists, :delta
    remove_column :interests, :delta
  end
end

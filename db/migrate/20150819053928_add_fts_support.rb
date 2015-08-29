class AddFtsSupport < ActiveRecord::Migration
  def up
  	execute "create index event_title on events using gin(to_tsvector('english',title))"
    execute "create index event_address on events using gin(to_tsvector('english',address))"
  end

  def down
    execute "drop index event_title"
    execute "drop index event_address"
  end
end

class ChangeStatesToInteger < ActiveRecord::Migration
  def tables
    ['authentication_tokens', 'tests', 'users']
  end

  def self.up
    tables.each do |t|
      connection.execute("ALTER TABLE #{t} ALTER COLUMN state TYPE integer USING 1")
      connection.execute("ALTER TABLE #{t} ALTER COLUMN state SET DEFAULT 1")
    end
  end

  def self.down
    tables.each do |t|
      connection.execute("ALTER TABLE #{t} ALTER COLUMN state TYPE string")
    end
  end
end

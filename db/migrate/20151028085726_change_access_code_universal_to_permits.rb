class ChangeAccessCodeUniversalToPermits < ActiveRecord::Migration
  def self.up
    # Cache `universal` value for each fields first
    universality_map = AccessCode.all.map do |code|
      { id: code.id, universal: code.universal }
    end
    # Drop `universal` column
    remove_column :access_codes, :universal
    # Add `permits` column
    add_column :access_codes, :permits, :integer, :default => 1
    # Set appropriate values
    # Universal is -1
    universality_map.each do |field|
      permits = field[:universal] ? -1 : 1
      code = AccessCode.find(field[:id])
      code.permits = permits
      code.save!
      puts code.attributes
    end
  end

  def self.down
    # Recache universality map
    universality_map = AccessCode.all.map do |code|
      { id: code.id, universal: code.permits < 0 }
    end
    # Drop `permits` column
    remove_column :access_codes, :permits
    # Add `universal` column
    add_column  :access_codes, :universal, :boolean, :default => false
    # Set appropriate values
    universality_map.each do |field|
      AccessCode.find(field[:id]).update_attributes(:universal => field[:universal])
    end
  end

end

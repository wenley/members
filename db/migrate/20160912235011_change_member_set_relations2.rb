class ChangeMemberSetRelations2 < ActiveRecord::Migration[5.0]
  def change
    remove_column :set_member_instruments, :member_instrument_id
    remove_column :set_member_instruments, :set_status
    remove_column :set_member_instruments, :rotating
  end
end

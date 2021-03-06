module MembersHelper

  def setup_member_instruments(member)
    member.member_instruments.build if member.member_instruments.blank? || !member.member_instruments.map(&:new_record?).any?
    member
  end

  def select_current_member_instruments(member_set)
    return nil unless member_set && member_set.member && member_set.member.id
    if SetMemberInstrument.where(:member_set_id => member_set.id).first
      return MemberInstrument.find(SetMemberInstrument.where(:member_set_id => member_set.id).first.member_instrument_id).instrument
    end
  end

end

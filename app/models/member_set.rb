class MemberSet < ApplicationRecord
  audited associated_with: :member
  acts_as_paranoid

  has_many :set_member_instruments
  belongs_to :member
  belongs_to :performance_set, class_name: 'PerformanceSet', foreign_key: 'set_id'
  accepts_nested_attributes_for :set_member_instruments, allow_destroy: true
  validates :performance_set, presence: true

  enum statuses: ['Interested in playing this set',
                  :playing,
                  'Stopped playing, due to member\'s own decision',
                  'Unable to play, not due to Member\'s decision',
                  :subbing,
                  'Rolled over from last set — Unconfirmed',
                  'Not Interested in this set']
end

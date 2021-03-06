module ApplicationHelper

  def us_states
      [
        ['Alabama', 'AL'],
        ['Alaska', 'AK'],
        ['Arizona', 'AZ'],
        ['Arkansas', 'AR'],
        ['California', 'CA'],
        ['Colorado', 'CO'],
        ['Connecticut', 'CT'],
        ['Delaware', 'DE'],
        ['District of Columbia', 'DC'],
        ['Florida', 'FL'],
        ['Georgia', 'GA'],
        ['Hawaii', 'HI'],
        ['Idaho', 'ID'],
        ['Illinois', 'IL'],
        ['Indiana', 'IN'],
        ['Iowa', 'IA'],
        ['Kansas', 'KS'],
        ['Kentucky', 'KY'],
        ['Louisiana', 'LA'],
        ['Maine', 'ME'],
        ['Maryland', 'MD'],
        ['Massachusetts', 'MA'],
        ['Michigan', 'MI'],
        ['Minnesota', 'MN'],
        ['Mississippi', 'MS'],
        ['Missouri', 'MO'],
        ['Montana', 'MT'],
        ['Nebraska', 'NE'],
        ['Nevada', 'NV'],
        ['New Hampshire', 'NH'],
        ['New Jersey', 'NJ'],
        ['New Mexico', 'NM'],
        ['New York', 'NY'],
        ['North Carolina', 'NC'],
        ['North Dakota', 'ND'],
        ['Ohio', 'OH'],
        ['Oklahoma', 'OK'],
        ['Oregon', 'OR'],
        ['Pennsylvania', 'PA'],
        ['Puerto Rico', 'PR'],
        ['Rhode Island', 'RI'],
        ['South Carolina', 'SC'],
        ['South Dakota', 'SD'],
        ['Tennessee', 'TN'],
        ['Texas', 'TX'],
        ['Utah', 'UT'],
        ['Vermont', 'VT'],
        ['Virginia', 'VA'],
        ['Washington', 'WA'],
        ['West Virginia', 'WV'],
        ['Wisconsin', 'WI'],
        ['Wyoming', 'WY']
      ]
  end

  SKIP_FIELDS = {
    "MemberInstrument" => ["Member"]
  }

  def generate_audit_string(audit)
    audit_string = ""
    if audit.action == 'destroy'
      audit_string << "#{User.find(audit.user_id).email} destroyed <b>#{audit.auditable_type.underscore.humanize}</b> with values #{audit.audited_changes.inspect} on #{audit.created_at.in_time_zone("Pacific Time (US & Canada)").strftime('%Y-%m-%d %-I:%M %p PT')}<br>".html_safe
    else
      audit.audited_changes.each do |field, change|
        if change.is_a?(Array)
          if !change[0] && field != "playing_status"
            change_text = "as <b>#{change[1]}</b>"
            verb = "filled in"
          elsif field == "playing_status"
            change_text = "from <b>Untriaged</b> to <b>#{change[1]}</b>"
            verb = "changed"
          else
            change_text = "from <b>#{change[0]}</b> to <b>#{change[1]}</b>"
            verb = "changed"
          end
        else
          change_text = "to <b>#{change}</b>"
          verb = "added"
        end
        if SKIP_FIELDS.keys.include?(audit.auditable_type) && SKIP_FIELDS[audit.auditable_type] && SKIP_FIELDS[audit.auditable_type].include?(field.humanize)
          next
        end
        if audit.auditable_type.underscore.humanize == "Member"
          a_type_string = ""
        else
          a_type_string = "on <b>#{audit.auditable_type.underscore.humanize}</b>"
        end
        audit_string << "#{User.find(audit.user_id).email} #{verb} <b>#{field.humanize.capitalize}</b> #{a_type_string} #{change_text} on #{audit.created_at.in_time_zone("Pacific Time (US & Canada)").strftime('%Y-%m-%d %-I:%M %p PT')}<br>".html_safe
      end
    end
    audit_string
  end

  def generate_audit_array(obj)
    audit_string = []
    if obj.is_a?(Array)
      obj.each do |inner_obj|
        audit_string += generate_audit_array(inner_obj)
      end
    else
      obj.audits.each do |obj_audit|
        audit_string << generate_audit_string(obj_audit)
      end
    end
    audit_string
  end
end

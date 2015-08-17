def usage_report
  p %w(all_users with_providers with_goals)
  pp [ User.count, User.joins(:providers).uniq.count, User.joins(:providers, providers: :goal).uniq.count]

  p "Goals per user"
  pp Goal.joins(:provider).map{|g| g.provider.beeminder_user_id}.group_by(&:itself).map{ |k,v| [k,v.count] }

  p "Goals per provider"
  pp Goal.joins(:provider).map{|g| [g.provider.name, g.provider.beeminder_user_id] }.group_by(&:first)
  nil
end

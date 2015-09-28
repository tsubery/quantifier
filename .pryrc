def usage_report
  p %w(all_users with_credentials with_goals)
  pp [ User.count, User.joins(:credentials).uniq.count, User.joins(:goals).uniq.count]

  p "Goals per user"
  pp User.joins(:goals).includes(:goals).map{ |u| [u.beeminder_user_id, u.goals.count] }

  p "User per provider"
  pp Goal.includes(:credential).map{|g| [g.provider.name, g.credential.beeminder_user_id] }.group_by(&:first)

  p "Active Goals"
  pp Goal.where(active: true).count

end

json.array!(@members) do |member|
  json.extract! member, :id, :name, :level, :communicationGoal, :leadershipGoal, :club, :award
  json.url member_url(member, format: :json)
end

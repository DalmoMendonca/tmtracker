json.array!(@speeches) do |speech|
  json.extract! speech, :id, :manual, :project, :title, :date, :club, :comment, :chart_id
  json.url speech_url(speech, format: :json)
end

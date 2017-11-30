json.array!(@charts) do |chart|
  json.extract! chart, :id, :name, :member_id, :speech_id
  json.url chart_url(chart, format: :json)
end

json.array!(@users) do |user|
  json.extract! user, :id, :name, :tw_name, :tw_sid, :tw_uid, :tw_key, :tw_secret, :provider
  json.url user_url(user, format: :json)
end

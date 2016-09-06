json.linechart(@interface_counter) do |name, infos|
  json.infos(infos) do |time, count|
    json.time time
    json.count count
  end
end

json.product_statics @result

json.api_user_statisc(@api_users_sort) do |api_user_item|
  company = api_user_item[:company] == "青浦爱天气" ? "上海发布" : api_user_item[:company]
  json.company company
  json.count api_user_item[:count]
end
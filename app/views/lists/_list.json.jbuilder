json.extract! list, :id, :name, :category, :position, :group_id, :created_at, :updated_at, :tasks
json.url list_url(list, format: :json)

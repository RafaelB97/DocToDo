json.extract! task, :id, :name, :description, :finish, :date, :position, :list_id, :created_at, :updated_at
json.url task_url(task, format: :json)

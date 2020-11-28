# json.extract! group, :id, :name, :description, :private, :user_id, :created_at, :updated_at, :lists
# json.url group_url(group, format: :json)

json.group do
    json.id group.id
    json.name group.name
    json.description group.description
    json.private group.private
    json.user_id group.user_id
    json.created_at group.created_at
    json.updated_at group.updated_at
    # json.lists @group.lists
    json.lists do
        json.array! group.lists, :id, :name, :category, :position, :group_id, :created_at, :updated_at, :tasks
=begin
        json.array! group.lists do |list|
            json.id list.id
            json.name list.name
            json.task list.tasks
        end
=end
    end
    json.url group_url(group, format: :json)
end
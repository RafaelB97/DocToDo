json.extract! invitation, :id, :status, :user_id, :group_id, :created_at, :updated_at, :user
json.url invitation_url(invitation, format: :json)

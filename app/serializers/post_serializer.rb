class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :link
  has_one :user
end

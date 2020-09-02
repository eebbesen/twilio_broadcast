class RecipientListMember < ApplicationRecord
  belongs_to :recipient
  belongs_to :recipient_list
end

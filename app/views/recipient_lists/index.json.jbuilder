# frozen_string_literal: true

json.array! @recipient_lists, partial: 'recipient_lists/recipient_list', as: :recipient_list

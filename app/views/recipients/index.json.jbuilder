# frozen_string_literal: true

json.array! @recipients, partial: 'recipients/recipient', as: :recipient

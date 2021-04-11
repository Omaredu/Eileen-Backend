class Message < ApplicationRecord
  belongs_to :conversation
  
  enum tone: %i[anger fear joy sadness analytical confident tentative]
end

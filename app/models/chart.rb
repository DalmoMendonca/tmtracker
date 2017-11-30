class Chart < ActiveRecord::Base
	has_many :speeches
	belongs_to :member

end

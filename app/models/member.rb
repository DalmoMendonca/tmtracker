class Member < ActiveRecord::Base
	has_many :charts, :autosave=>true
end

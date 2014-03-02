class UserProfile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :address, :country, :dob, :education, :firstname, :gender, :id_number, :lastname, :middlename, :register_address, :state, :user_id
  
  # searchable do
  #   string :lastname
  #   string :firstname
  # end
  
  def id_number_encrypted
    if self.id_number.length > 9
      return self.id_number[0..3] + 'XXXXX' + self.id_number[9..10] 
    else 
      return 'NO DATA'
    end
  end
end

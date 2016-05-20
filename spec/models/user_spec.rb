# == Schema Information
#
# Table name: users
#
#  beeminder_user_id :string           not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#

describe User do
  let(:user) { build(:user) }

  describe "Validations" do
    it "factory creates valid model" do
      expect(user).to be_valid
    end
  end
end

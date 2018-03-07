require "rails_helper"

RSpec.describe User, :type => :model do
  describe "create" do
    context "given complete data" do
      it "stores" do
        expect(create(:user, :user_frank)).to be_valid
      end
    end
  end
end
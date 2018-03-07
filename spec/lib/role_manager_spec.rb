require 'spec_helper'
# require relative to this spec file in spec/lib.
require File.join(File.dirname(__FILE__), '../../app/lib/role_manager')

describe "role_manager" do
  it "initializes correctly" do
    expect { RoleManager::RoleManager.new }.to_not raise_error()
  end
end

describe "permitted?" do
  let(:rm) {RoleManager::RoleManager.new}
  it "returns true for role is_user and activity :view_public_content" do
    #                  activity, is_visitor, is_user, is_member_of_acct, is_owner_of_acct
    context = [false, true, false, false, false]
    expect(rm.permitted?(:view_public_content, context)).to be true
  end
end

describe "permitted?" do
  let(:rm) {RoleManager::RoleManager.new}
  it "returns false for role is_user and activity :invite_to_account" do
    #                  activity, is_visitor, is_user, is_member_of_acct, is_owner_of_acct
    # Note the activity is a symbol.
    context= [false, true, false, false, false, false]
    expect(rm.permitted?(:invite_to_account, context)).to be nil
  end
end
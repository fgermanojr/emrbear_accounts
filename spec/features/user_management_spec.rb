require 'rails_helper'
# This is primitive feature test. Need to get a stack work that
# supports javascript. Understand the different options:
# poltergeist, chrome, firefox
RSpec.feature "User management", js: true, :type => :feature do
  scenario "Root page is correct" do
    visit '/'
    expect(page).to have_text("EMRbear")
    expect(page).to have_text("Content List")
  end

  scenario "/users" do
    visit '/users'
    expect(page).to have_text("EMRbear")
    expect(page).to have_text("Users List")
  end

  # scenario "create user" do
  #   visit '/' # root_path
  #   # expect(page).to have_content 'Please Login'
  #   click_link("a_user_create")
  #   # within(“form#user_new”) do
  #   #   fill_in 'Name’, with: 'John’
  #   #   fill_in 'Email’, with: 'user@example.com’
  #   #   fill_in 'Password’, with: 'password’
  #   #   fill_in 'Retype Password’, with: 'password’
  #   # end
  #   # click_button 'Sign Up’
  #   # expect(page).to have_content 'Welcome to Sample App’
  #   # expect(page).to have_content 'John’
  # end
end
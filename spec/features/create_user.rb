require 'rails_helper'

feature 'CreateUser' do
  let(:email) { 'new_user@bloc.io'}
  let(:password) { 'password' }
  let(:bad_password) { 'pa$$word' }
  let(:username) { 'new_user' }

  scenario "creates new user with valid parameters" do
    visit(root_path)
    visit(new_user_registration_path)
    fill_in 'Username', with: username
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_on 'Sign up'
    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(current_path).to eq(root_path)
    expect(User.find_by(username: username).email).to eq(email)
  end

  scenario "displays correct error messages when data is missing" do
    visit(new_user_registration_path)
    fill_in 'Username', with: ""
    fill_in 'Email', with: ""
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: bad_password
    click_on 'Sign up'
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Username can't be blank")
    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(current_path).to eq(user_registration_path)
  end
end

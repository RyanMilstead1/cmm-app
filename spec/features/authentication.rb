require 'rails_helper'

feature 'Authentication' do
  let(:email) { 'new_user@bloc.io' }
  let(:password) { 'password' }
  let(:username) { 'new_user' }

  before do
    create(:user, email: email, password: password, password_confirmation: password, username: username)
  end

  scenario "signs in with correct credentials" do
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully.')
  end

  scenario "incorrect credientials denies sign-in and alerts user" do
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: 'nothinggood'
    click_on 'Log in'
    expect(page).to have_content('Invalid Email or password.')
  end

  scenario "returns to deep page after sign-in" do
    visit(wikis_path)
    expect(current_path).to eq(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(current_path).to eq(wikis_path)
    expect(page).to have_content('Signed in successfully.')
  end

  scenario "signed in user can sign out" do
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(page).to have_content(username)
    click_on 'Sign Out'
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Signed out successfully.")
  end
end

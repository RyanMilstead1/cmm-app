require 'rails_helper'

feature 'CreateWiki' do
  let(:email) { 'user@email.com' }
  let(:password) { 'password' }
  let(:premium_user) { create(:user, email: email_premium, password: password, password_confirmation: password, role: :premium) }
  let(:admin) { create(:user, email: email_admin, password: password, password_confirmation: password, role: :admin) }

  scenario "standard user can create a public wiki" do
    create(:user, email: email, password: password, password_confirmation: password)
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully.')
    click_on 'Go to Wikis'
    expect(current_path).to eq(wikis_path)
    click_on 'New Wiki'
    expect(current_path).to eq(new_wiki_path)
    expect(page).to_not have_content('Private')
    title = "About #{Faker::Book.title}"
    fill_in 'Title', with: title
    fill_in 'Body', with: Faker::Lorem.paragraph
    click_on 'Save'
    expect(page).to have_content('was created.')
    expect(page).to have_content(title)
    click_on 'Back to Wikis'
    expect(page).to have_content(title)
    expect(current_path).to eq(wikis_path)
  end

  scenario "premium user can create a public wiki" do
    create(:user, email: email, password: password, password_confirmation: password, role: :admin)
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully.')
    click_on 'Go to Wikis'
    expect(current_path).to eq(wikis_path)
    click_on 'New Wiki'
    expect(current_path).to eq(new_wiki_path)
    expect(page).to have_content('Private')
    title = "About #{Faker::Book.title}"
    fill_in 'Title', with: title
    fill_in 'Body', with: Faker::Lorem.paragraph
    click_on 'Save'
    expect(page).to have_content('was created.')
    expect(page).to have_content(title)
    click_on 'Back to Wikis'
    expect(page).to have_content(title)
    expect(current_path).to eq(wikis_path)
  end

  scenario "premium user can create a private wiki" do
    create(:user, email: email, password: password, password_confirmation: password, role: :admin)
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully.')
    click_on 'Go to Wikis'
    expect(current_path).to eq(wikis_path)
    click_on 'New Wiki'
    expect(current_path).to eq(new_wiki_path)
    title = "About #{Faker::Book.title}"
    fill_in 'Title', with: title
    fill_in 'Body', with: Faker::Lorem.paragraph
    page.check 'Private'
    click_on 'Save'
    expect(page).to have_content('was created.')
    expect(page).to have_content(title)
    click_on 'Back to Wikis'
    expect(page).to have_content("#{title} Private!")
    expect(current_path).to eq(wikis_path)
  end

  scenario "premium user can create a public wiki" do
    create(:user, email: email, password: password, password_confirmation: password, role: :premium)
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully.')
    click_on 'Go to Wikis'
    expect(current_path).to eq(wikis_path)
    click_on 'New Wiki'
    expect(current_path).to eq(new_wiki_path)
    expect(page).to have_content('Private')
    title = "About #{Faker::Book.title}"
    fill_in 'Title', with: title
    fill_in 'Body', with: Faker::Lorem.paragraph
    click_on 'Save'
    expect(page).to have_content('was created.')
    expect(page).to have_content(title)
    click_on 'Back to Wikis'
    expect(page).to have_content(title)
    expect(current_path).to eq(wikis_path)
  end

  scenario "premium user can create a private wiki" do
    create(:user, email: email, password: password, password_confirmation: password, role: :premium)
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Log in'
    expect(page).to have_content('Signed in successfully.')
    click_on 'Go to Wikis'
    expect(current_path).to eq(wikis_path)
    click_on 'New Wiki'
    expect(current_path).to eq(new_wiki_path)
    title = "About #{Faker::Book.title}"
    fill_in 'Title', with: title
    fill_in 'Body', with: Faker::Lorem.paragraph
    page.check 'Private'
    click_on 'Save'
    expect(page).to have_content('was created.')
    expect(page).to have_content(title)
    click_on 'Back to Wikis'
    expect(page).to have_content("#{title} Private!")
    expect(current_path).to eq(wikis_path)
  end
end

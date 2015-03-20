require 'spec_helper'

feature "User views the index page" do
  scenario "user sees the correct title and alphabetically sorted" do
    visit '/'
    titles = page.all('.meetup-row h1 a').collect(&:text)

    expect(titles).to eq(titles.sort)
  end
end


feature "User views the meetup page" do
  scenario "user sees the meetup title, description and location" do
    visit '/show/1'

    expect(page).to have_content "JugoFutbol"
    expect(page).to have_content "Pick up soccer games"
    expect(page).to have_content "Boston"
  end
end

feature "User creates a new meetup" do
  scenario "user provides name, description and location and then sees the details of the new meetup and a message stating the meetup was successfully created" do
    user = User.create(provider: 'github', uid: '9405172', username: 'Dodie324', email: 'dodie@example.com', avatar_url: 'https://avatars.githubusercontent.com/u/9405172?v=3')
    sign_in_as(user)
    visit '/new'

    fill_in('name', with: 'Launch Academy')
    fill_in('description', with: 'Learn Ruby!')
    fill_in('location', with: 'Boston')

    click_button('Add Group')

    expect(page).to have_content "Launch Academy"
    expect(page).to have_content "Learn Ruby!"
    expect(page).to have_content "Boston"
    expect(page).to have_content "Meetup created successfully"
  end
end

feature "User wants to join a meetup" do
  scenario "user visits meetup page, clicks button to join and successfully joins the group" do

    user = User.create(provider: 'github', uid: '9405172', username: 'Dodie324', email: 'dodie@example.com', avatar_url: 'https://avatars.githubusercontent.com/u/9405172?v=3')
    sign_in_as(user)
    visit '/show/9'
    click_link('Join')

    expect(page).to have_content "You joined the group!"
  end
end

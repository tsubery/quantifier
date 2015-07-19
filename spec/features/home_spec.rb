require 'spec_helper'

describe "Home page" do
  scenario "anonymous user visit welcome page" do
    visit root_path
    expect(page).to have_content('Welcome')
  end
end

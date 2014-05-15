require "spec_helper"

describe "User" do | |
  it "visit sign-in page" do
    visit new_user_session_path
    page.should have_content "Login"
  end

end
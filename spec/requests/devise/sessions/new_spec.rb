require 'spec_helper.rb'

describe "SignInPages" do

  before { visit new_user_session_path }
  subject {page}
  let(:user) { FactoryGirl.create :user }

  describe "the sign-in process" do

    describe "with valid info" do
      before do
        fill_in "Email",     with: user.email
        fill_in "Password",  with: user.password
        click_button "Sign in"
      end
      it { should have_content("success") }
    end

    describe "with invalid info" do 
      before do
        fill_in "Email",    with: "wrong"
        fill_in "Password", with: "wrong"
        click_button "Sign in"
        # print page.html
      end
      it { should have_content("Invalid") }
    end
  end
  
end

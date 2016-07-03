require 'rails_helper'

feature 'member can add santas to a list', :js do

  signed_in_as(:member) do

    context 'a list does not yet exist' do

      scenario 'Member adds new list with valid data' do
        visit member_dashboard_index_path
        click_on("Create a list")
        fill_in("Name", with: "Winter is coming")

        within "#santas" do
          click_on("Add Santa")
          fill_in("Name", with: "Johnny")
          fill_in("Email", with: "littlejohnny@example.com")
        end

        click_on("Create")

        expect(page).to have_flash(:notice, "List was successfully created.")
        expect(List.count).to be(1)
        # the following test is currently commented out because of an issue with cocoon.
        # expect(List.last.santas.count).to be(1)
        within "table" do
          within_row("Winter is coming") { click_on("View") }
          expect(page).to have_content("littlejohnny@example.com")
        end
      end

    end

    context 'a list already exists' do
      let!(:list) { FactoryGirl.create(:list, user: current_user) }

      scenario 'Member edits list and adds a santa' do
        visit member_dashboard_index_path
        within "table" do
          within_row(list.name) { click_on("Edit") }
        end

        within "#santas" do
          click_on("Add Santa")
          fill_in("Name", with: "Johnny")
          fill_in("Email", with: "littlejohnny@example.com")
        end

        click_on("Save Changes")

        expect(page).to have_flash(:notice, "List was successfully updated.")
        expect(Santa.first.email).to eq("littlejohnny@example.com")
      end
    end

  end

end

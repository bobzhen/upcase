require "rails_helper"

feature 'Visitor can purchase a subscription for their team' do
  scenario 'successful purchase' do
    visit_team_plan_checkout_page
    fill_out_account_creation_form email: 'user@fabtabulous.com'
    fill_out_credit_card_form_with_valid_credit_card

    expect_to_see_checkout_success_flash

    my_account_link.click

    expect_to_see_team_name 'Fabtabulous'
  end

  def team_plan
    Plan.team.first
  end

  def expect_to_see_team_name(team_name)
    expect(page).to have_content(team_name)
  end
end

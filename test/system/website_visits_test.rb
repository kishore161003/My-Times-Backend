require "application_system_test_case"

class WebsiteVisitsTest < ApplicationSystemTestCase
  setup do
    @website_visit = website_visits(:one)
  end

  test "visiting the index" do
    visit website_visits_url
    assert_selector "h1", text: "Website visits"
  end

  test "should create website visit" do
    visit website_visits_url
    click_on "New website visit"

    fill_in "Time spent", with: @website_visit.time_spent
    fill_in "Visit date", with: @website_visit.visit_date
    fill_in "Website", with: @website_visit.website_id
    click_on "Create Website visit"

    assert_text "Website visit was successfully created"
    click_on "Back"
  end

  test "should update Website visit" do
    visit website_visit_url(@website_visit)
    click_on "Edit this website visit", match: :first

    fill_in "Time spent", with: @website_visit.time_spent
    fill_in "Visit date", with: @website_visit.visit_date
    fill_in "Website", with: @website_visit.website_id
    click_on "Update Website visit"

    assert_text "Website visit was successfully updated"
    click_on "Back"
  end

  test "should destroy Website visit" do
    visit website_visit_url(@website_visit)
    click_on "Destroy this website visit", match: :first

    assert_text "Website visit was successfully destroyed"
  end
end

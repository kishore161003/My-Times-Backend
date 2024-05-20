require "test_helper"

class WebsiteVisitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @website_visit = website_visits(:one)
  end

  test "should get index" do
    get website_visits_url
    assert_response :success
  end

  test "should get new" do
    get new_website_visit_url
    assert_response :success
  end

  test "should create website_visit" do
    assert_difference("WebsiteVisit.count") do
      post website_visits_url, params: { website_visit: { time_spent: @website_visit.time_spent, visit_date: @website_visit.visit_date, website_id: @website_visit.website_id } }
    end

    assert_redirected_to website_visit_url(WebsiteVisit.last)
  end

  test "should show website_visit" do
    get website_visit_url(@website_visit)
    assert_response :success
  end

  test "should get edit" do
    get edit_website_visit_url(@website_visit)
    assert_response :success
  end

  test "should update website_visit" do
    patch website_visit_url(@website_visit), params: { website_visit: { time_spent: @website_visit.time_spent, visit_date: @website_visit.visit_date, website_id: @website_visit.website_id } }
    assert_redirected_to website_visit_url(@website_visit)
  end

  test "should destroy website_visit" do
    assert_difference("WebsiteVisit.count", -1) do
      delete website_visit_url(@website_visit)
    end

    assert_redirected_to website_visits_url
  end
end

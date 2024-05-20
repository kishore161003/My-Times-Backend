class WebsitesController < ApplicationController
  before_action :set_website, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token

  # GET /websites or /websites.json
  def index
    @websites = Website.all
    render json: @websites, status: :ok
  end

  # GET /websites/1 or /websites/1.json
  def show
    # Implementation not shown in the provided code
  end

  # GET /websites/new
  def new
    @website = Website.new
  end

  # GET /websites/1/edit
  def edit
    # Implementation not shown in the provided code
  end

  # POST /websites or /websites.json
  def create
    @website = Website.new(website_params)

    if @website.save
      render json: @website, status: :created, location: @website
    else
      render json: @website.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /websites/1 or /websites/1.json
  def update
    if @website.update(website_params)
      render json: @website, status: :ok, location: @website
    else
      render json: @website.errors, status: :unprocessable_entity
    end
  end

  def destroy_all
    Website.destroy_all
    render json: { message: "All websites deleted" }, status: :ok
  end

  def time_spent_today
    user_id = params[:user_id]
    websites_with_time_spent = Website.joins(:website_visits)
                                      .where(user_id: user_id, website_visits: { visit_date: Date.today })
                                      .select('websites.*, SUM(website_visits.time_spent) AS total_time_spent')
                                      .group('websites.id')
                                      .order('total_time_spent DESC')

    render json: websites_with_time_spent.map { |website| format_website(website) }
  end

  def time_spent_past_week
    user_id = params[:user_id]
    past_week = Date.today - 7.days
    websites_with_time_spent = Website.joins(:website_visits)
                                      .where(user_id: user_id)
                                      .where('website_visits.visit_date >= ?', past_week)
                                      .select('websites.*, SUM(website_visits.time_spent) AS total_time_spent')
                                      .group('websites.id')
                                      .order('total_time_spent DESC')

    render json: websites_with_time_spent.map { |website| format_website(website) }
  end

  def time_spent_past_month
    user_id = params[:user_id]
    past_month = Date.today - 1.month
    websites_with_time_spent = Website.joins(:website_visits)
                                      .where(user_id: user_id)
                                      .where('website_visits.visit_date >= ?', past_month)
                                      .select('websites.*, SUM(website_visits.time_spent) AS total_time_spent')
                                      .group('websites.id')
                                      .order('total_time_spent DESC')

    render json: websites_with_time_spent.map { |website| format_website(website) }
  end

  def time_spent_past_month_for_domain
  user_id = params[:user_id]
  domain = params[:domain]
  past_month = Date.today - 1.month

 
  website_visits = WebsiteVisit.joins(:website)
                                .where(websites: { user_id: user_id })
                                .where('visit_date >= ?', past_month)
                                .where('websites.url LIKE ?', "%#{domain}%")
  total_time_spent = website_visits.sum(:time_spent)
  details = website_visits.order(:visit_date).map do |visit|
    { date: visit.visit_date, time_spent: visit.time_spent }
  end

  render json: {
    domain: domain,
    time_spent: {
      total: total_time_spent,
      details: details
    }
  }
end


    def time_spent_past_month_for_website
    user_id = params[:user_id]
    url = params[:url]
    past_month = Date.today - 1.month

    website = Website.find_by(url: url, user_id: user_id)
    return render json: { error: "Website not found" }, status: :not_found unless website

    website_visits = WebsiteVisit.where(website_id: website.id)
                                 .where('visit_date >= ?', past_month)
                                 .order(:visit_date)

    total_time_spent = website_visits.sum(:time_spent)

    result = {
      url: website.url,
      restricted: website.restricted,
      timeout: website.timeout,
      time_spent: {
        total: total_time_spent,
        details: website_visits.map { |visit| { date: visit.visit_date, time_spent: visit.time_spent } }
      }
    }

    render json: result, status: :ok
  end

  def user_websites
    user_id = params[:user_id]
    websites = Website.where(user_id: user_id)
    website_visits = WebsiteVisit.where(website_id: websites.pluck(:id))
    grouped_visits = website_visits.group_by(&:website_id)

    result = websites.map do |website|
      visits = grouped_visits[website.id] || []
      timespend = visits.each_with_object({}) do |visit, hash|
        hash[visit.visit_date.to_s] = visit.time_spent
      end
      {
        url: website.url,
        restricted: website.restricted,
        timeout: website.timeout,
        timespend: timespend
      }
    end

    render json: result
  end

  def update_restriction_and_timeout
    website = Website.find(params[:id])
    if website.update(restricted: params[:restricted], timeout: params[:timeout])
      render json: website, status: :ok
    else
      render json: { errors: website.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_data
    userId = params[:user_id]
    url = params[:url]
    restricted = params[:restricted]
    timeout = params[:timeout]
    timespend = params[:time_spend].to_i

    website = Website.find_or_initialize_by(url: url, user_id: userId)

    if website.new_record?
      website.restricted = restricted
      website.user_id = userId
      website.timeout = timeout
    end

    if website.save
      website_visit = WebsiteVisit.find_or_initialize_by(website_id: website.id, visit_date: Date.today)

      if website_visit.new_record?
        website_visit.time_spent = 0
      else
        website_visit.time_spent = timespend.to_i
      end

      if website_visit.save
        render json: { time_spent: website_visit.time_spent }, status: :ok
      else
        render json: { errors: website_visit.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: website.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_timeout_data
  user_id = params[:user_id]
  url = params[:url]
  timeout = params[:timeout]

  # Find the website by URL and user ID
  website = Website.find_by(url: url, user_id: user_id)

  if website.nil?
    # If the website doesn't exist, create a new one with the provided timeout
    website = Website.new(url: url, user_id: user_id, timeout: timeout)
  else
    # If the website exists, update the timeout
    website.timeout = timeout
  end

  if website.save
    render json: website, status: :ok
  else
    render json: { errors: website.errors.full_messages }, status: :unprocessable_entity
  end
end

  def update_restricted_data
  user_id = params[:user_id]
  url = params[:url]
  restricted = params[:restricted]

  # Find the website by URL and user ID
  website = Website.find_or_initialize_by(url: url, user_id: user_id)

  # Update the timeout if provided
  website.restricted = restricted if restricted.present?

  if website.new_record? || website.save
    render json: website, status: :ok
  else
    render json: { errors: website.errors.full_messages }, status: :unprocessable_entity
  end
end

   def with_restriction_or_timeout
    userId = params[:user_id]
    websites = Website.where(user_id: userId).where('restricted = ? OR timeout > ?', true, 0)
    render json: websites
  end

  # DELETE /websites/1 or /websites/1.json
  def destroy
    @website.destroy!
    head :no_content
  end

  private

  def format_website(website)
    {
      url: website.url,
      restricted: website.restricted,
      timeout: website.timeout,
      time_spent: {
        total: website.total_time_spent.to_i,
        details: website.website_visits.where('visit_date >= ?', Date.today - 1.month).order(:visit_date).map do |visit|
          { date: visit.visit_date, time_spent: visit.time_spent }
        end
      }
    }
  end

  def set_website
    @website = Website.find(params[:id])
  end

  def website_params
    params.require(:website).permit(:url, :restricted, :timeout)
  end
end

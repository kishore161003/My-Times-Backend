class WebsiteVisitsController < ApplicationController
  before_action :set_website_visit, only: %i[ show edit update destroy ]

  skip_before_action :verify_authenticity_token

  # GET /website_visits or /website_visits.json
  def index
    @website_visits = WebsiteVisit.all
    render json:@website_visits,status: :ok
  end

  # GET /website_visits/1 or /website_visits/1.json
  def show
  end

  # GET /website_visits/new
  def new
    @website_visit = WebsiteVisit.new
  end

  # GET /website_visits/1/edit
  def edit
  end

  # POST /website_visits or /website_visits.json
  def create
    @website_visit = WebsiteVisit.new(website_visit_params)

    respond_to do |format|
      if @website_visit.save
        format.html { redirect_to website_visit_url(@website_visit), notice: "Website visit was successfully created." }
        format.json { render :show, status: :created, location: @website_visit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @website_visit.errors, status: :unprocessable_entity }
      end
    end
  end

   def total_time_stats
    # Fetch the user based on the provided user_id
    user = User.find(params[:user_id])
    
    # Get user's websites
    user_websites = user.websites

    # Get website ids for the user's websites
    website_ids = user_websites.pluck(:id)

    # Query website visits for today, past week, and past month
    today_visits = WebsiteVisit.where(website_id: website_ids, visit_date: Date.today)
    past_week_visits = WebsiteVisit.where(website_id: website_ids, visit_date: 1.week.ago..Date.today)
    past_month_visits = WebsiteVisit.where(website_id: website_ids, visit_date: 1.month.ago..Date.today)

    # Calculate total time spent for today, past week, and past month
    total_time_today = today_visits.sum(:time_spent)
    total_time_past_week = past_week_visits.sum(:time_spent)
    total_time_past_month = past_month_visits.sum(:time_spent)

    render json: {
      user_id: user.id,
      total_time_today: total_time_today,
      total_time_past_week: total_time_past_week,
      total_time_past_month: total_time_past_month
    }
  end
  

  # PATCH/PUT /website_visits/1 or /website_visits/1.json
  def update
    respond_to do |format|
      if @website_visit.update(website_visit_params)
        format.html { redirect_to website_visit_url(@website_visit), notice: "Website visit was successfully updated." }
        format.json { render :show, status: :ok, location: @website_visit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @website_visit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_all
    WebsiteVisit.destroy_all
    render json: {message: "All website visits deleted"}, status: :ok
  end


  # DELETE /website_visits/1 or /website_visits/1.json
  def destroy
    @website_visit.destroy!

    respond_to do |format|
      format.html { redirect_to website_visits_url, notice: "Website visit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_website_visit
      @website_visit = WebsiteVisit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def website_visit_params
      params.require(:website_visit).permit(:website_id, :visit_date, :time_spent)
    end
end

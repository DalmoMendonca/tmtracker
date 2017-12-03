class ChartsController < ApplicationController
  before_action :set_chart, only: [:show, :edit, :update, :destroy]
  before_action :dictionaries

  # GET /charts
  # GET /charts.json
  def index
    if params[:clubname].present?
      @charts = Chart.joins(:member).where("club like ?", "%#{params[:clubname]}%").order("progress": :desc, "lastUpdate": :desc)
    else
      @charts = Chart.all.order("progress": :desc, "lastUpdate": :desc)
    end

    if params[:clubname].present?
      @members = Member.where("club like ?", "%#{params[:clubname]}%")
    else
      @members = Member.all
    end
  end

  # GET /charts/1
  # GET /charts/1.json
  def show
    @members = Member.all
    @speeches = Speech.all
    @charts = Chart.all
    render :layout => nil
  end

  # GET /charts/new
  def new
    @member = Member.find(params[:member_id])
    @chart = Member.find(params[:member_id]).charts.new
    #@chart = Chart.new
  end

  # GET /charts/1/edit
  def edit
  end

  # POST /charts
  # POST /charts.json
  def create
    @chart = Member.find(params[:member_id]).charts.new(chart_params)
    case @chart.name
    when "CC"
      10.times do |i|
        newspeech = @chart.speeches.new
        newspeech.manual = "COMPETENT COMMUNICATION"
        newspeech.project = @ccProjects[i]
        i = i+1
      end
    when "ACB"
      11.times do |i|
        newspeech = @chart.speeches.new
        if i == 10
          newspeech.project = "Complete CC"
        else
          newspeech.manual = "CHOOSE AN ADVANCED MANUAL"
        end
        i = i+1
      end
    when "ACS"
      13.times do |i|
        newspeech = @chart.speeches.new
        if i == 12
          newspeech.project = "Complete ACB"
        elsif i == 10 || 11 
          newspeech.manual = "CHOOSE AN EDUCATIONAL MANUAL"
        else
          newspeech.manual = "CHOOSE AN ADVANCED MANUAL"
        end
        i = i+1
      end
    when "ACG"
      13.times do |i|
        newspeech = @chart.speeches.new
        if i == 11
          newspeech.project = "Mentor a Member"
        elsif i == 12
          newspeech.project = "Complete ACS"
        else
          newspeech.manual = "CHOOSE AN ADVANCED MANUAL"
        end
        i = i+1
      end
    when "CL"
      @clProjects.each do |project, titles|
        titles.each do |title|
          newspeech = @chart.speeches.new
          newspeech.manual = "COMPETENT LEADERSHIP"
          newspeech.project = project
          newspeech.title = title
        end
      end
    when "ALB"
      5.times do |i|
        newspeech = @chart.speeches.new
        case i
        when 2
          newspeech.project = "Club officer for 6 months"
        when 3
          newspeech.project = "Participate in DCP plan meeting"
        when 4
          newspeech.project = "Attend officer training"
        when 5
          newspeech.project = "Complete CC"
        when 6
          newspeech.project = "Complete CL"
        else
          newspeech.manual = "CHOOSE AN EDUCATIONAL MANUAL"
        end
        i = i+1
      end
    when "ALS"
      5.times do |i|
        newspeech = @chart.speeches.new
        case i
        when 0
          newspeech.manual = "HIGH PERFORMANCE LEADERSHIP"
          newspeech.project = "(1) Sharing Your Vision (5-6 min)"
        when 1
          newspeech.manual = "HIGH PERFORMANCE LEADERSHIP"
          newspeech.project = "(2) Presenting the Results (5-7 min)"
        when 2
          newspeech.project = "District officer for 1 year"
        when 3
          newspeech.project = "Sponsor or coach a club"
        when 4
          newspeech.project = "Achieve ALB"
        end
        i = i+1
      end
    end

    respond_to do |format|
      if @chart.save
        format.html { redirect_to edit_multiple_members_path, notice: 'Chart was successfully created.' }
        format.json { render :show, status: :created, location: @chart }
      else
        format.html { render :new }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /charts/1
  # PATCH/PUT /charts/1.json
  def update
    respond_to do |format|
      if @chart.update(chart_params)
        format.html { redirect_to edit_multiple_members_path, notice: 'Chart was successfully updated.' }
        format.json { render :show, status: :ok, location: @chart }
      else
        format.html { render :edit }
        format.json { render json: @chart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charts/1
  # DELETE /charts/1.json
  def destroy
    @chart.destroy
    respond_to do |format|
      format.html { redirect_to charts_url, notice: 'Chart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_multiple
    @chart = Chart.find(params[:chart_id])
    @speeches = @chart.speeches
  end

  def update_multiple
    @speeches = Speech.update(params[:speeches].keys, params[:speeches].values)
    @chart = Chart.find(params[:chart_id])
    if @speeches.empty?
    redirect_to speeches_url
      else
       render "edit_multiple"
    end
  end

  private
    def dictionaries
      @ccProjects = ["(1) The Ice Breaker (4-6 min)",
                    "(2) Organize Your Speech (5-7 min)",
                    "(3) Get to the Point (5-7 min)",
                    "(4) How to Say It (5-7 min)",
                    "(5) Your Body Speaks (5-7 min)",
                    "(6) Vocal Variety (5-7 min)",
                    "(7) Research Your Topic (5-7 min)",
                    "(8) Get Comfortable with Visual Aids (5-7 min)",
                    "(9) Persuade with Power (5-7 min)",
                    "(10) Inspire Your Audience (8-10 min)"]
      @clProjects = {"(1) Listening" => ["Speech Evaluator",
                                      "Table Topics Speaker",
                                      "Ah Counter",
                                      "Grammarian"],
                   "(2) Critical Thinking" => ["Speech Evaluator",
                                              "Grammarian",
                                               "General Evaluator"],
                   "(3) Giving Feedback" => ["Speech Evaluator",
                                              "Grammarian",
                                              "General Evaluator"],
                   "(4) Time Management" => ["Timer",
                                              "Toastmaster",
                                              "Speaker",
                                              "Topicsmaster",
                                              "Grammarian"],
                   "(5) Planning and Implementation" => ["Speaker",
                                                          "General Evaluator",
                                                          "Toastmaster",
                                                          "Topicsmaster"],
                   "(6) Organization and Delegation" => ["Help Organize a Club Speech Contest",
                                                          "Help Organize a Club Special Event",
                                                          "Help Organize a Club Membership Campaign or Contest",
                                                          "Help Organize a Club PR Campaign",
                                                          "Help Produce a Club Newsletter",
                                                          "Assist the Club's Webmaster"],
                   "(7) Facilitation" => ["Toastmaster",
                                          "General Evaluator",
                                          "Topicsmaster",
                                          "Befriend a Guest"],
                   "(8) Motivation" => ["Membership Campaign or Contest Chair",
                                        "PR Campaign Chair",
                                        "Toastmaster",
                                        "Speech Evaluator",
                                        "General Evaluator"],
                   "(9) Mentoring" => ["Mentor for a New Member",
                                        "Mentor for an Existing Member",
                                        "HPL Guidance Committee Member"],
                   "(10) Team Building" => ["Toastmaster",
                                            "General Evaluator",
                                            "Membership Campaign Chair",
                                            "Club PR Campaign Chair",
                                            "Club Speech Contest Chair",
                                            "Club Special Event Chair",
                                            "Club Newsletter Editor",
                                            "Club Webmaster"]
                  }
      @advancedManuals = ["COMMUNICATING ON TELEVISION",
                "COMMUNICATING ON VIDEO",
                "FACILITATING DISCUSSION",
                "HUMOROUSLY SPEAKING",
                "INTERPERSONAL COMMUNICATIONS",
                "INTERPRETIVE READING",
                "PERSUASIVE SPEAKING",
                "PUBLIC RELATIONS",
                "SPEAKING TO INFORM",
                "SPECIAL OCCASION SPEECHES",
                "SPECIALTY SPEECHES",
                "SPEECHES BY MANAGEMENT",
                "STORYTELLING",
                "TECHNICAL PRESENTATIONS",
                "THE DISCUSSION LEADER",
                "THE ENTERTAINING SPEAKER",
                "THE PROFESSIONAL SALESPERSON",
                "THE PROFESSIONAL SPEAKER"]
      @educationManuals = ["EDUCATIONAL BETTER SPEAKER SERIES",
                "EDUCATIONAL LEADERSHIP EXCELLENCE SERIES",
                "EDUCATIONAL SUCCESSFUL CLUB SERIES"]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_chart
      @chart = Chart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chart_params
      params.require(:chart).permit(:speech_id, :name, :member_id)
    end
end

class SpeechesController < ApplicationController
  before_action :set_speech, only: [:show, :edit, :update, :destroy]
  before_action :dictionaries
  after_action :update_chart, only: [:edit_multiple, :update_multiple]

  # GET /speeches
  # GET /speeches.json
  def index
    @speeches = Speech.all
  end

  # GET /speeches/1
  # GET /speeches/1.json
  def show
  end

  # GET /speeches/new
  def new
    @speech = Speech.new
  end

  # GET /speeches/1/edit
  def edit
  end

  # POST /speeches
  # POST /speeches.json
  def create
    @speech = Speech.new(speech_params)


    respond_to do |format|
      if @speech.save
        format.html { redirect_to @speech, notice: 'Speech was successfully created.' }
        format.json { render :show, status: :created, location: @speech }
      else
        format.html { render :new }
        format.json { render json: @speech.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /speeches/1
  # PATCH/PUT /speeches/1.json
  def update
    respond_to do |format|
      if @speech.update(speech_params)
        format.html { redirect_to @speech, notice: 'Speech was successfully updated.' }
        format.json { render :show, status: :ok, location: @speech }
      else
        format.html { render :edit }
        format.json { render json: @speech.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /speeches/1
  # DELETE /speeches/1.json
  def destroy
    @speech.destroy
    respond_to do |format|
      format.html { redirect_to speeches_url, notice: 'Speech was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_multiple
    @chart = Chart.find(params[:chart_id])
    @speeches = @chart.speeches
    markAsDone()

  end

  def update_multiple
    @chart = Chart.find(params[:chart_id])
    @speeches = Speech.update(params[:speeches].keys, params[:speeches].values)
    markAsDone()
    #@speeches = Speech.update(params[:speeches].keys, params[:speeches].values)
    if @speeches.empty?
    redirect_to speeches_url
      else
       render "edit_multiple"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_speech
      @speech = Speech.find(params[:id])
    end
    def checkMe(start,duration,min)
      done = 0
      finish = start + duration
      duration.times do
        done = done + (@speeches[start]["date"].nil? ? 0 : 1)
        #done = done.to_s + @speeches[start]["date"].to_s #troubleshooting
        start = start + 1
      end
      return (done >= min)
      #return done #troubleshooting
    end

    def markAsDone()
      i=1
      #params[:speeches].each do |id v|
      #  s = Speech.find(v)
      @speeches.each do |s|
        if s["date"].present?
          s["done"] = true
        elsif @chart.name.include?("CL")
          check = case s.project
          when "(1) Listening"
            checkMe(0,4,3)
          when "(2) Critical Thinking"
            checkMe(4,3,2)
          #when "(3) Giving Feedback"
          #  check(7,3,3)
          when "(4) Time Management"
            (checkMe(10,1,1) && checkMe(11,4,1))
          when "(5) Planning and Implementation"
            checkMe(15,4,3)
          when "(6) Organization and Delegation"
            checkMe(19,6,1)
          when "(7) Facilitation"
            checkMe(25,4,2)
          when "(8) Motivation"   
            (checkMe(29,2,1) && checkMe(31,3,2))
          when "(9) Mentoring"  
            checkMe(34,3,1)          
          when "(10) Team Building" 
            (checkMe(37,2,2) || checkMe(39,6,1))
          end
          if check == true
              s["done"] = true
          #else #troubleshooting
          #    s["title"] = check #troubleshooting
          end
        else
          s["done"] = false
        end
        if @chart.name.include?("AC")
          case i
          when 1
            @manual1 = s["manual"]
          when 2,3,4,5
            s["manual"] = @manual1
          when 6
            @manual2 = s["manual"]
          when 7,8,9,10
            s["manual"] = @manual2
          end
        end
        s.save
        i=i+1
      end
    end

    def update_chart()
      total = 0
      done = 0
      @chart.speeches.each do |speech|
        total = total+1
        done = done+1 if speech.done == true
      end
      progress = (100*done.to_f/total.to_f).round
      @chart.update_attribute(:progress, progress)

      inProgress = nil
      date = Date.parse("1/1/0000")
      @chart.speeches.each do |speech|
        if speech.done.nil?
          inProgress = true
        elsif speech.date.present? && (speech.date > date)
          date = speech.date
        end
      end
      @chart.update_attribute(:lastUpdate, date)

      if inProgress.nil?
        done = date
      else
        done = nil
      end
      @chart.update_attribute(:done, done)
    end

    def dictionaries 
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
      @projects = {"COMMUNICATING ON TELEVISION" => ["(1) Straight Talk (3 min)",
                    "(2) The Talk Show (10 min)",
                    "(3) When You're the Host (10 min)",
                    "(4) The Press Conference (4-6 min presentation; 8-10 min Q&amp;A)",
                    "(5) Training on Television (5-7 min; 5-7 min video tape playback)"],
                    "COMMUNICATING ON VIDEO" => ["(1) The Straight Talk (3 min)",
                    "(2) The Interview Show (5-7 min)",
                    "(3) When You're the Host (5-7 min)",
                    "(4) The Press Conference (3-5 min; 2-3 min for Q&amp;A)",
                    "(5) Instructing on the Internet (5-7 min; 5-7 min for video playback)"],
                    "FACILITATING DISCUSSION" => ["(1) The Panel Moderator (28-30 min or optional 22-26 min)",
                    "(2) The Brainstorming Session (31-33 min or optional 20-22 min)",
                    "(3) The Problem-Solving Discussion (26-31 min or optional 19-23 min)",
                    "(4) Handling Challenging Situations (22-32 min or optional 12-21 min)",
                    "(5) Reaching a Consensus (31-37 min or optional 20-26 min)"],
                    "HUMOROUSLY SPEAKING" => ["(1) Warm Up Your Audience (5-7 min)",
                    "(2) Leave Them with a Smile (5-7 min)",
                    "(3) Make Them Laugh (5-7 min)",
                    "(4) Keep Them Laughing (5-7 min)",
                    "(5) The Humorous Speech (5-7 min)"],
                    "INTERPERSONAL COMMUNICATIONS" => ["(1) Conversing with Ease (10-14 min)",
                    "(2) The Successful Negotiator (10-14 min)",
                    "(3) Diffusing Verbal Criticism (10-14 min)",
                    "(4) The Coach (10-14 min)",
                    "(5) Asserting Yourself Effectively (10-14 min)"],
                    "INTERPRETIVE READING" => ["(1) Read a Story (8-10 min)",
                    "(2) Interpreting Poetry (6-8 min)",
                    "(3) The Monodrama (5-7 min)",
                    "(4) The Play (12-15 min)",
                    "(5) The Oratorical Speech (8-10 min)"],
                    "PERSUASIVE SPEAKING" => ["(1) The Effective Salesperson (3-4 min speech; 3-5 min role play; 2-3 min discussion)",
                    "(2) Conquering the Cold Call (3-4 min speech; 5-7 min role play; 2-3 min discussion)",
                    "(3) The Winning Proposal (5-7 min)",
                    "(4) Addressing the Opposition (7-9 min speech; 2-3 min Q&amp;A)",
                    "(5) The Persuasive Leader (6-8 min)"],
                    "PUBLIC RELATIONS" => ["(1) The Goodwill Speech (5-7 min)",
                    "(2) The Radio Talk Show (3-5 min; 2-3 min Q&amp;A)",
                    "(3) The Persuasive Approach (5-7 min)",
                    "(4) Speaking Under Fire (3-5 min; 2-3 min Q&amp;A)",
                    "(5) The Crisis Management Speech (4-6 min; 3-5 min Q&amp;A)"],
                    "SPEAKING TO INFORM" => ["(1) The Speech to Inform (5-7 min)",
                    "(2) Resources for Informing (5-7 min)",
                    "(3) The Demonstration Talk (5-7 min)",
                    "(4) A Fact-Finding Report (5-7 min; 2-3 min Q&amp;A)",
                    "(5) The Abstract Concept (6-8 min)"],
                    "SPECIAL OCCASION SPEECHES" => ["(1) Mastering the Toast (2-3 min)",
                    "(2) Speaking in Praise (5-7 min)",
                    "(3) The Roast (3-5 min)",
                    "(4) Presenting an Award (3-4 min)",
                    "(5) Accepting an Award (5-7 min)"],
                    "SPECIALTY SPEECHES" => ["(1) Impromptu Speaking (5-7 min)",
                    "(2) Uplift the Spirit (8-10 min)",
                    "(3) Sell a Product (10-12 min)",
                    "(4) Read Out Loud (12-15 min)",
                    "(5) Introduce the Speaker (duration of a club meeting)"],
                    "SPEECHES BY MANAGEMENT" => ["(1) The Briefing (3-5 min; 2-3 min  Q&amp;A)",
                    "(2) Appraise with Praise (5-7 min)",
                    "(3) Persuade and Inspire (5-7 min)",
                    "(4) Communicating Change (5-7 min)",
                    "(5) Delivering Bad News (5-7 min)"],
                    "STORYTELLING" => ["(1) The Folk Tale (7-9 min)",
                    "(2) Let's Get Personal (6-8 min)",
                    "(3) The Moral of the Story (5-7 min)",
                    "(4) The Touching Story (6-8 min)",
                    "(5) Bringing History to Life (7-9 min)"],
                    "TECHNICAL PRESENTATIONS" => ["(1) The Technical Briefing (8-10 min)",
                    "(2) The Proposal (8-10 min; 3-5 min Q&amp;A)",
                    "(3) The Nontechnical Audience (10-12 min)",
                    "(4) Presenting a Technical Paper (10-12 min)",
                    "(5) Enhancing a Technical Talk with the Internet (12-15 min)"],
                    "THE DISCUSSION LEADER" => ["(1) The Seminar Solution (20-30 min)",
                    "(2) The Round Robin (20-30 min)",
                    "(3) Pilot a Panel (30-40 min)",
                    "(4) Make Believe (Role Playing) (20-30 min)",
                    "(5) The Workshop Leader (30-40 min)"],
                    "THE ENTERTAINING SPEAKER" => ["(1) The Entertaining Speech (5-7 min)",
                    "(2) Resources for Entertainment (5-7 min)",
                    "(3) Make Them Laugh (5-7 min)",
                    "(4) A Dramatic Talk (5-7 min)",
                    "(5) Speaking After Dinner (8-10 min)"],
                    "THE PROFESSIONAL SALESPERSON" => ["(1) The Winning Attitude (8-10 min)",
                    "(2) Closing the Sale (10-12 min)",
                    "(3) Training the Sales Force (6-8 min; 8-10 min role play; 2-5 min discussion)",
                    "(4) The Sales Meeting (15-20 min)",
                    "(5) The Team Sales Presentation (15-20 min; 5-7 min per person for manual credit)"],
                    "THE PROFESSIONAL SPEAKER" => ["(1) The Keynote Address (15-20 min)",
                    "(2) Speaking to Entertain (15-20 min)",
                    "(3) The Sales Training Speech (15-20 min)",
                    "(4) The Professional Seminar (20-40 min)",
                    "(5) The Motivational Speech (15-20 min)"],
                    "EDUCATIONAL BETTER SPEAKER SERIES" => ["(1) Beginning Your Speech (10-15 min)",
                    "(2) Concluding Your Speech (10-15 min)",
                    "(3) Controlling Your Fear (10-15 min)",
                    "(4) Impromptu Speaking (10-15 min)",
                    "(5) Selecting Your Topic (10-15 min)",
                    "(6) Know Your Audience (10-15 min)",
                    "(7) Organizing Your Speech (10-15 min)",
                    "(8) Creating an Introduction (10-15 min)",
                    "(9) Preparation and Practice (10-15 min)",
                    "(10) Using Body Language (10-15 min)"],
                    "EDUCATIONAL LEADERSHIP EXCELLENCE SERIES" => ["(1) The Visionary Leader (10-15 min)",
                    "(2) Developing a Mission (10-15 min)",
                    "(3) Values and Leadership (10-15 min)",
                    "(4) Goal Setting and Planning (10-15 min)",
                    "(5) Delegate to Empower (10-15 min)",
                    "(6) Building a Team (10-15 min)",
                    "(7) Giving Effective Feedback (10-15 min)",
                    "(8) The Leader as a Coach (10-15 min)",
                    "(9) Motivating People (10-15 min)",
                    "(10) Service and Leadership (10-15 min)",
                    "(11) Resolving Conflict (10-15 min)"], 
                    "EDUCATIONAL SUCCESSFUL CLUB SERIES" => ["(1) Moments Of Truth (60-90 min)",
                    "(2) Finding New Members for Your Club (10-15 min)",
                    "(3) Evaluate to Motivate (10-15 min)",
                    "(4) Closing the Sale (10-15 min)",
                    "(5) Creating the Best Club Climate (10-15 min)",
                    "(6) Meeting Roles and Responsibilities (10-15 min)",
                    "(7) Mentoring (10-15 min)",
                    "(8) Keeping the Commitment (10-15 min)",
                    "(9) Going Beyond Our Club (10-15 min)",
                    "(10) How to Be a Distinguished Club (10-15 min)",
                    "(11) The Toastmasters Educational Program (10-15 min)"]
      }      
      @notes = {1 => [4,"Complete 3 of 4"],
          5 => [3,"Complete 2 of 3"],
          8 => [3,"Complete 3 of 2"],
          11 => [5,"Complete Timer + 1"],
          16 => [4,"Complete 3 of 4"],
          20 => [6,"Complete 1 of 6"],
          26 => [4,"Complete 2 of 4"],
          30 => [5,"Chair a Membership Campaign or Club Contest + 2 others"],
          35 => [3,"Complete 1 of 3"],
          38 => [8,"Complete 2 of 2 roles or 1 of 6 chairs"]
      }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def speech_params
      params.require(:speech).permit("manual", :manual, :project, :title, :date, :club, :comment, :chart_id, :done)
    end
end

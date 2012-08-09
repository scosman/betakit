class AdminController < ApplicationController
  http_basic_authenticate_with :name => Rails.configuration.auth_username, :password => Rails.configuration.auth_password

  def home
    @users = User.order("created_at DESC")
  end

  def reports
    @statistics = []

    statNames = Statistic.select('name').uniq.collect {|s| s.name}
    statNames.each do |statName|
      statDetails = {:name => statName}
      statDetails[:lastValue] = Statistic.where(:name => statName, :cohort_group => nil).order('time DESC').first
      statDetails[:values] = Statistic.where(:name => statName, :cohort_group => nil).order('time DESC').limit(400)
      @statistics.push statDetails
    end
  end

  def report_stat
    @statName = params[:stat_name]
    @lastValue = Statistic.where(:name => @statName, :cohort_group => nil).order('time DESC').first
    @historyValues = Statistic.where(:name => @statName, :cohort_group => nil).order('time DESC').limit(400)

    # add graphs for each cohort group, and lines for each cohort within a group
    @cohortGraphs = []
    cohortGroups = Statistic.select('cohort_group').where(:name => @statName).where('cohort_group IS NOT NULL').uniq.collect {|s| s.cohort_group}
    cohortGroups.each do |cohortGroup|
      cohortNames = Statistic.select('cohort_name').where(:name => @statName, :cohort_group => cohortGroup).uniq.collect {|s| s.cohort_name}
      cohorts = []
      cohortNames.each do |cohortName|
        values = Statistic.where(:name => @statName, :cohort_group => cohortGroup, :cohort_name => cohortName).order('time DESC').limit(400)
        cohorts.push({:name => cohortName, :values => values})
      end
      @cohortGraphs.push({:name => "Cohort: #{cohortGroup}", :cohorts => cohorts})
    end
  end

  def invite_user
    user = User.find_by_email params[:email]
    if user.nil?
      render :text => "false", :status => 400
      return
    end 

    begin
      BetaMailer.invite_mail(user).deliver
      user.state = User::STATES[:invited]
      user.save
      render :text => "true"
    rescue
      render :text => "false", :status => 400
    end
  end

  def import_emails
    emailString = params[:emails]
    emails = emailString.split(/[,;\s]+/)
    total = 0
    alreadyImported = 0

    emails.each do |email|
      trimmed = email.strip
      user = User.new
      user.email = trimmed
      saved = user.save
     if saved
       total += 1
     else 
       user = User.find_by_email trimmed
       alreadyImported += 1 if !user.nil? 
     end
    end

    render :text => "Imported " + total.to_s + " of " + emails.length.to_s + ". " + alreadyImported.to_s + " previously imported. " + (emails.length - total - alreadyImported).to_s + " errors." 
  end

  def export_emails
    csv = User.all.collect {|u| u.email}.join(", ")
    render :text => csv
  end
end

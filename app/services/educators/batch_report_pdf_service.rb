require 'squid'
require 'prawn'
require 'gchart'
require 'googlecharts'
require "open-uri"

class Educators::BatchReportPdfService < Prawn::Document
  include ProcessorHelper
  def initialize(params)
    super()
    @batch_id = params[:batch_id]
    @batch = Batch.find(@batch_id)
    # identify test
    @test = Test.find(@batch.test_id)
    header
    text_content
  end

  def test_result_for(params)
    @userid = params[:id]
    # Cache result
    cache_key = "user#{@userid}:test#{@test.id}:result"

    Rails.cache.fetch(cache_key) do
      # Find the latest result of this test from the user
      result = Result.where(test: @test, user: User.find_by(id: @userid)).last
      # Execute processor file to get results
      # Method load_processor_for can be found inside ProcessorHelper
      if !result.nil?
        load_processor_for(@test)
        result_processor = Processor.new(result)

        # Return processed result
        result_processor.process
      end
    end
  end

  def header
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    ul = []
    @batch.email.each do |el|
      if (user = User.find_by(email: el))
        ul << user
      end
    end

    rl = {}
    ul.each do |current_user|
      if test_result_for(id: current_user.id)
        rl[current_user.email] = test_result_for(id: current_user.id)
      end
    end

    #Distibution of SP
    @beginning = 0
    @developing = 0
    @maturing = 0
    @exceptional = 0

    #Distribution of SA
    @sa_top = {}
    @sa_bottom = {}

    #Distribution of SR
    @sr = {}
    @eg = 0
    @pm = 0
    @sm = 0
    @bd = 0
    @mm = 0
    @de = 0
    @mk = 0
    @csm = 0
    @am = 0
    @fm = 0

    rl.each do |k,v|
      #SP count
      case "#{v[:potential][:title]}"
      when "Beginning"
        @beginning += 1
      when "Developing"
        @developing += 1
      when "Maturing"
        @maturing += 1
      when "Exceptional"
        @exceptional += 1
      end

      #SA name list
      if @sa_top[v[:top_attributes][0][:title].to_s].nil?
        @sa_top[v[:top_attributes][0][:title].to_s] = "#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      else
        @sa_top[v[:top_attributes][0][:title].to_s] << "\n#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      end

      if @sa_bottom[v[:bottom_attributes][0][:title].to_s].nil?
        @sa_bottom[v[:bottom_attributes][0][:title].to_s] = "#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      else
        @sa_bottom[v[:bottom_attributes][0][:title].to_s] << "\n#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      end

      #SR name list
      if @sr[v[:top_roles][0][:title].to_s].nil?
        @sr[v[:top_roles][0][:title].to_s] = "#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      else
        @sr[v[:top_roles][0][:title].to_s] << "\n#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      end

      #SR Count
      case "#{v[:top_roles][0][:title].to_s}"
      when "Engineer"
        @eg += 1
      when "Product Manager"
        @pm += 1
      when "Sales Manager"
        @sm += 1
      when "Business Developer"
        @bd += 1
      when "Marcomms Manager"
        @mm += 1
      when "Designer"
        @de += 1
      when "Marketer"
        @mk += 1
      when "Customer Service Manager"
        @csm += 1
      when "Admin Manager"
        @am += 1
      when "Finance Manager"
        @fm += 1
      end
    end
  end

  def sa_rows
    [['Tier', 'Attribute', 'Name']] +
      @sa_top.map do |k,v|
      ['1', k, v]
    end
  end

  def sa_rows_bottom
    [['Tier', 'Attribute', 'Name']] +
      @sa_bottom.map do |k,v|
      ['1', k, v]
    end
  end

  def sr_rows
    [['#', 'Roles', 'Names']] +
      @sr.map do |k,v|
      ['1' , k, v]
    end
  end

  def text_content
    y_position = cursor - 30
    spacing_value = 80
    left_column_font_size = 15
    right_column_font_size = 10
    left_column_font_color = "8BC34A"
    left_column_font_color_bottom = "#03A9F4"
    right_column_font_color = "616161"

    font_families.update("Open Sans Light" => {
      :normal => "#{Rails.root}/app/assets/fonts/OpenSans-Light.ttf"
    })

    bounding_box([450, y_position + 50],:width => 180, :height => bounds.height) do
      font "Open Sans Light"
      text "Report generated on:", size: 10, :color => right_column_font_color
      text "#{Date.today}", size: 10, :color => right_column_font_color
    end

    bounding_box([0, y_position - 150],:width => 400, :height => bounds.height) do
      text "Distribution of Starteur Potential", size: 40, :color => left_column_font_color
      text "This section shows a collection of your group's Starteur Potentials. Starteur Potentials are categorized into 4 components ranging between Beginning to Exceptional."
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor

    bounding_box([0, y_position],:width => 540) do
      text "Number of Students", :align => :center
    end

    y_position = cursor - 20

    bounding_box([0, y_position],:width => bounds.width) do
      data = {"Starteur Potential" => {"Beginning" => @beginning, "Developing" => @developing, 
        "Maturing" => @maturing, "Exceptional" => @exceptional}}
      chart data, colors: %w(e7a13d bc2d30)
    end

    y_position = cursor - 20

    bounding_box([0, y_position],:width => 540) do
      text "Beginning", :color => left_column_font_color
      text "The majority range of individuals who have completed the profiling tool lie in this region. Individuals in this region presently in its budding stages of entrepreneurship. Now would be the best time to look into their personal motivations for wanting to be an entrepreneur or co-founder. Getting them to reflecting on their potential in each of the 16 Starteur™ Attributes will help them to identify their strengths, areas for improvement and think about what first got them started or interested in business. By consciously directing their thoughts and behaviours, they will be able to better decide if the path of an entrepreneurs or co-founders is something they'd like to pursue."
    end

    y_position = cursor - 20

    bounding_box([0, y_position],:width => 540) do
      text "Developing", :color => left_column_font_color
      text "This region is in the middle range of individuals who have completed the profiling tool. While your entrepreneurial aptitude may still be in its nascent stages, your potential in each of the individual 16 Starteur™ Attributes provides an opportunity for you to level up. By focusing on the individual attributes that are also reflected as Developing, you’ll be able to evolve your thoughts and behaviours along traits that are considered to be fundamental to entrepreneurs and co-founders. Review your results below, and consider the suggestions provided to accelerate your entrepreneurial development."
    end
    
    y_position = cursor - 20

    bounding_box([0, y_position],:width => 540) do
      text "Maturing", :color => left_column_font_color
      text "This region indicates that your group is amoung the upper range of individuals who have completed the profiling tool. While their entrepreneurial aptitude may still be growing, their potential in each of the individual 16 Starteur™ Attributes provides an opportunity for them to continue levelling up. Review their results and consider the suggestions provided to maximize their entrepreneurial development."
    end

    y_position = cursor - 20

    bounding_box([0, y_position],:width => 540) do
      text "Exceptional", :color => left_column_font_color
      text "This region puts your group amongst the highest of individuals who have completed the profiling tool. Review their results and consider the suggestions provided to realize their full entrepreneurial potential."
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor - 20

    bounding_box([0, y_position - 150],:width => 400, :height => bounds.height) do
      text "Distribution of Starteur Attributes", size: 40, :color => left_column_font_color
      text "This section categorizes your group into their respective strongest and weakest Starteur™ Attributes."
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor

    bounding_box([0, y_position],:width => 540) do
      text "Students' Top Attributes", :align => :center
    end

    y_position = cursor - 20

    bounding_box([0, y_position],:width => 540) do
      table sa_rows do
        self.header = true
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [40, 300, 200]
      end
    end

    y_position = cursor - 30

    bounding_box([0, y_position],:width => 540) do
      text "Students' Bottom Attributes", :align => :center
    end

    y_position = cursor - 20

    bounding_box([0, y_position],:width => 540) do
      table sa_rows_bottom do
        self.header = true
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [40, 300, 200]
      end
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor - 20

    bounding_box([0, y_position - 150],:width => 400, :height => bounds.height) do
      text "Distribution of Starteur Roles", size: 40, :color => left_column_font_color
      text "Starteur Roles are the potential jobs that your group can take. This section categorizes your group into their most suited roles."
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor

    bounding_box([0, y_position],:width => 540) do
      text "Students' Roles", :align => :center
    end

    y_position = cursor - 20

    bounding_box([0, y_position],:width => 540) do
      table sr_rows do
        self.header = true
        self.row_colors = ['DDDDDD', 'FFFFFF']
        self.column_widths = [40, 300, 200]
      end
    end

    y_position = cursor - 30

    bounding_box([0, y_position],:width => 540) do
      text "Number of Students", :align => :center
    end

    y_position = cursor - 20

    bounding_box([0, y_position],:width => bounds.width) do
      data = {"Starteur Roles" => {"Engineer" => @eg, "Product Manager" => @pm, "Sales Manager" => @sm, "Business Developer" => @bd, "Marcomms Manager" => @mm, "Designer" => @de, "Marketer" => @mk, "Customer Service Manager" => @csm, "Admin Manager" => @am, "Finance Manager" => @fm}}
      chart data, colors: %w(e7a13d bc2d30)
    end
  end
end

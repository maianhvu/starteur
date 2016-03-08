class Educators::BatchReportPdfService < Prawn::Document
  def initialize(params)
    super()
    @batch_id = params[:batch_id]
    @batch = Batch.find(@batch_id)
    # identify test
    @test = Test.find(@batch.test_id)
    header
    text_content
  end

  def header
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    ul = []
    @batch.email.each do |el|
      ul << User.find_by(email: el)
    end

    processor_file_path = File.join(Rails.root, 'app', 'processors', @test.identifier, 'processor.rb')
    load processor_file_path
    
    rl = {}
    ul.each do |current_user|
      result = Result.where(test: @test, user: current_user).last

      # Execute processor file to get results
      # Method load_processor_for can be found inside ProcessorHelper
      # load_processor_for(@test)
      result_processor = Processor.new(result)
      # Return processed result
      rl[current_user.email] = result_processor.process
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
        @sa_top[v[:top_attributes][0][:title].to_s] << "#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      end

      if @sa_bottom[v[:bottom_attributes][0][:title].to_s].nil?
        @sa_bottom[v[:bottom_attributes][0][:title].to_s] = "#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      else
        @sa_bottom[v[:bottom_attributes][0][:title].to_s] << "#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      end

      #SR name list
      if @sr[v[:top_roles][0][:title].to_s].nil?
        @sr[v[:top_roles][0][:title].to_s] = "#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
      else
        @sr[v[:top_roles][0][:title].to_s] << "#{User.find_by(email: k).first_name} #{User.find_by(email: k).last_name}"
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
    [['Tier', 'Attribute', 'Top']] +
      @sa_top.map do |k,v|
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
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor - 100

    bounding_box([90, y_position],:width => 400, :height => bounds.height) do
      text "#{@beginning}", size: 70
      y_position -= 90
    end

    bounding_box([10, y_position],:width => 400, :height => bounds.height) do
      text "Beginning", size: 40
      y_position += 90
    end

    bounding_box([390, y_position],:width => 400, :height => bounds.height) do
      text "#{@developing}", size: 70
      y_position -= 90
    end

    bounding_box([310, y_position],:width => 400, :height => bounds.height) do
      text "Developing", size: 40
      y_position -= 150
    end

    bounding_box([90, y_position],:width => 400, :height => bounds.height) do
      text "#{@maturing}", size: 70
      y_position -= 90
    end

    bounding_box([10, y_position],:width => 400, :height => bounds.height) do
      text "Maturing", size: 40
      y_position += 90
    end

    bounding_box([390, y_position],:width => 400, :height => bounds.height) do
      text "#{@exceptional}", size: 70
      y_position -= 90
    end

    bounding_box([310, y_position],:width => 400, :height => bounds.height) do
      text "Exceptional", size: 40
    end
    
    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor - 20

    bounding_box([0, y_position - 150],:width => 400, :height => bounds.height) do
      text "Distribution of Starteur Attributes", size: 40, :color => left_column_font_color
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    table sa_rows do
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40, 300, 200]
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor - 20

    bounding_box([0, y_position - 150],:width => 400, :height => bounds.height) do
      text "Distribution of Starteur Roles", size: 40, :color => left_column_font_color
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    table sr_rows do
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40, 300, 200]
    end
  end
end
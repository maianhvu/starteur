class Educators::ReportPdfService < Prawn::Document
  include ProcessorHelper
  def initialize(params)
    super()
    @userid = params[:user_id]
    @batch_id = params[:batch_id]
    @batch = Batch.find(@batch_id)
    # identify test
    @test = Test.find(@batch.test_id)
    header
    text_content
    # table_content
  end

  def test_result_for(test)
    # Cache result
    cache_key = "user#{@userid}:test#{@test.id}:result"
    Rails.cache.fetch(cache_key) do
      # Find the latest result of this test from the user
      result = Result.where(test: @test, user: User.find_by(id: @userid)).last
      # Execute processor file to get results
      # Method load_processor_for can be found inside ProcessorHelper
      load_processor_for(test)
      result_processor = Processor.new(result)

      # Return processed result
      result_processor.process
    end
  end

  def header
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]

    processor_file_path = File.join(Rails.root, 'app', 'processors', @test.identifier, 'processor.rb')
    load processor_file_path
    
    @rl = test_result_for(@test)

    # top attributes
    @topattrib = []
    @rl[:top_attributes].each do |topattrib|
      @topattrib << topattrib
    end

    # bottom attributes
    @botattrib = []
    @rl[:bottom_attributes].each do |botattrib|
      @botattrib = botattrib
    end

    # set starteur potential icon
    @potentialstr = ""
    @potentialdesc = ""
    @potentialdescpt1 =""
    @potentialdescpt2 =""
    @potentialdescpt3 =""
    case "#{@rl[:potential][:title]}"
    when "Beginning"
      @potentialstr = "icon-potential-1.png"
      @potentialdesc = "Your Starteur™ Profile indicates your current overall potential as Beginning, in the majority range of individuals who have completed the profiling tool. As your entrepreneurial aptitude is presently in its budding stages, now would be the best time to look into your personal motivations for wanting to be an entrepreneur or co-founder. Reflecting on your potential in each of the 16 Starteur™ Attributes will help you to identify strengths, areas for improvement, and think about what first got you started or interested in business. By consciously directing your thoughts and behaviours, you’ll be able to better decide if the path of an entrepreneurs or co-founders is something you’d like to pursue. Review your results below, and consider the suggestions provided to begin your entrepreneurial development."
      @potentialdescpt1 = "You need additional preparation in understanding what being a co-founder or entrepreneur is all about."
      @potentialdescpt2 = "You are aware that being an entrepreneur is one of many alternative career paths. However, you are likely to be unsure if this is suitable for you, either now or in the future."
      @potentialdescpt3 = "You are likely to have some idea about what life as an entrepreneur entails. However, the fear or anxiety that you are facing now may likely stem from misconceptions about what the job scope and functions of an entrepreneur."
    when "Developing"
      @potentialstr = "icon-potential-2.png"
      @potentialdesc = "Your Starteur™ Profile indicates your current overall potential as Developing, in the middle range of individuals who have completed the profiling tool. While your entrepreneurial aptitude may still be in its nascent stages, your potential in each of the individual 16 Starteur™ Attributes provides an opportunity for you to level up. By focusing on the individual attributes that are also reflected as Developing, you’ll be able to evolve your thoughts and behaviours along traits that are considered to be fundamental to entrepreneurs and co-founders. Review your results below, and consider the suggestions provided to accelerate your entrepreneurial development."
      @potentialdescpt1 = "You have good knowledge about entrepreneurship, and you know that you want to embark on this career path. You have some well-formed ideas about entrepreneurship, and are likely to be actively searching for additional information at this moment."
      @potentialdescpt2 = "You see entrepreneurship as a viable career option, and it this point, are likely to want to give it a try. Though over time, you may reconsider, and reassess your situation should you feel that it is no longer viable for you."
      @potentialdescpt3 = "You will need to know about what kinds of challenges await you, as well as how to handle them should you you decide to pursue entrepreneurship. At this point, you need to fully acknowledge that entrepreneurship is extremely challenging, and that the road will not always be easy. You will need a strong support system to prevent you from feeling burned-out."
    when "Maturing"
      @potentialstr = "icon-potential-3.png"
      @potentialdesc = "Your Starteur™ Profile indicates your current overall potential as Maturing, in the upper range of individuals who have completed the profiling tool. While your entrepreneurial aptitude may still be growing, your potential in each of the individual 16 Starteur™ Attributes provides an opportunity for you to continue levelling up. Review your results below, and consider the suggestions provided to maximize your entrepreneurial development."
      @potentialdescpt1 = "You have strong fact-based knowledge about entrepreneurship, and are very interested to take on this career path. You well-formed ideas about entrepreneurship, stemming from your own personal experiences and that of others, though you are likely to always be searching for more valuable insight."
      @potentialdescpt2 = "You see entrepreneurship as a prospective career path for you, and are willing to give it a try. In fact, you are optimistic that you will make startups and entrepreneurship work for you, and are likely to have taken actionable, concrete steps to materialise your plans."
      @potentialdescpt3 = "Though you may feel settled or easily satisfied at times with what you have achieved, innately you feel compelled to achieve something more than what you have already done; you are aware of the untapped potential that is there."
    when "Exceptional"
      @potentialstr = "icon-potential-4.png"
      @potentialdesc = "Your Starteur™ Profile indicates your current potential as Exceptional, putting you amongst the highest of individuals who have completed the profiling tool. Review your results below, and consider the suggestions provided to realize your full entrepreneurial potential."
      @potentialdescpt1 = "You have deep knowledge about startups and entrepreneurship, and you believe that entrepreneurship is your calling. You have diverse ideas about entrepreneurship, stemming from your own personal experiences and that of others, and are always trying to find out more. You see yourself as a thought leader in certain aspects in which you claim domain mastery, and are likely to seek out other subject experts to maximize your own learning."
      @potentialdescpt2 = "You see entrepreneurship as your career path, and you will make it work, one way or another. You fully acknowledge the challenges that you would have to face on the entrepreneurship journey, and are ready to face them. While you have high hopes, this is grounded in concrete action and results, and you have certainty in the progress and trajectory of your various projects and startups."
      @potentialdescpt3 = "You are passionate, relentlessly resourceful, and hungry for achievement. You feel compelled to bring a quantum leap in what you have attained thus far, and your self-awareness guides you in maximizing your own untapped potential."
    end

    # set first role icons
    @imagestr1 = ""
    case "#{@rl[:top_roles][0][:title]}"
    when "Engineer"
      @imagestr1 = "role_icons_engineer.png"
    when "Product Manager"
      @imagestr1 = "role_icons_product.png"
    when "Sales Manager"
      @imagestr1 = "role_icons_sales.png"
    when "Business Developer"
      @imagestr1 = "role_icons_business.png"
    when "Marcomms Manager"
      @imagestr1 = "role_icons_marcomms.png"
    when "Designer"
      @imagestr1 = "role_icons_designer.png"
    when "Marketer"
      @imagestr1 = "role_icons_marketer.png"
    when "Customer Service Manager"
      @imagestr1 = "role_icons_customer.png"
    when "Admin Manager"
      @imagestr1 = "role_icons_admin.png"
    when "Finance Manager"
      @imagestr1 = "role_icons_finance.png"
    end 

    # set second role icons
    @imagestr2 = ""
    case "#{@rl[:top_roles][1][:title]}"
    when "Engineer"
      @imagestr2 = "role_icons_engineer.png"
    when "Product Manager"
      @imagestr2 = "role_icons_product.png"
    when "Sales Manager"
      @imagestr2 = "role_icons_sales.png"
    when "Business Developer"
      @imagestr2 = "role_icons_business.png"
    when "Marcomms Manager"
      @imagestr2 = "role_icons_marcomms.png"
    when "Designer"
      @imagestr2 = "role_icons_designer.png"
    when "Marketer"
      @imagestr2 = "role_icons_marketer.png"
    when "Customer Service Manager"
      @imagestr2 = "role_icons_customer.png"
    when "Admin Manager"
      @imagestr2 = "role_icons_admin.png"
    when "Finance Manager"
      @imagestr2 = "role_icons_finance.png"
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
      text "#{User.find_by(id: @userid).first_name} #{User.find_by(id: @userid).last_name}", size: 40, :color => left_column_font_color
      text "#{@test.name}", size: left_column_font_size, :color => left_column_font_color
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor + 20

    bounding_box([240, y_position],:width => 180) do
      text "Potential", size: left_column_font_size, :color => left_column_font_color
    end

    y_position = cursor - 30

    bounding_box([100, y_position],:width => 180) do
      image "#{Rails.root}/app/assets/images/#{@potentialstr}", width: 150
    end

    bounding_box([270, y_position - 50],:width => 180) do
      text "Starteur Potential", size: 20
      text "#{@rl[:potential][:title]}", size: 30
    end

    y_position = cursor - 80

    bounding_box([0, y_position],:width => 540) do
      text "#{@potentialdesc}", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 10

    a = bounding_box([0, y_position],:width => 540) do
      text "#{@potentialdescpt1}", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 10

    bounding_box([0, y_position],:width => 540) do
      text "#{@potentialdescpt2}", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 10

    bounding_box([0, y_position],:width => 540) do
      text "#{@potentialdescpt3}", size: right_column_font_size, :color => right_column_font_color
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor - 30

    bounding_box([240, y_position + 40],:width => 180) do
      text "Attributes", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([0, y_position],:width => 180) do
      text "Your top attributes", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360) do
      text "Your top attributes are the attributes you display most often.", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 50

    bounding_box([0, y_position],:width => 200) do
      text "#{@rl[:top_attributes][0][:title]}", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360) do
      text "#{@rl[:top_attributes][0][:description]}", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 30

    bounding_box([0, y_position],:width => 200) do
      text "#{@rl[:top_attributes][1][:title]}", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360) do
      text "#{@rl[:top_attributes][1][:description]}", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 30

    bounding_box([0, y_position],:width => 200) do
      text "#{@rl[:top_attributes][2][:title]}", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360) do
      text "#{@rl[:top_attributes][2][:description]}", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 50

    bounding_box([0, y_position],:width => 200) do
      text "Your Bottom Attributes", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360) do
      text "Your bottom attributes are the attributes you display the least.", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 50

    bounding_box([0, y_position],:width => 200) do
      text "#{@rl[:bottom_attributes][0][:title]}", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360) do
      text "#{@rl[:bottom_attributes][0][:description]}", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 30

    bounding_box([0, y_position],:width => 200) do
      text "#{@rl[:bottom_attributes][1][:title]}", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360) do
      text "#{@rl[:bottom_attributes][1][:description]}", size: right_column_font_size, :color => right_column_font_color
    end

    y_position = cursor - 30

    bounding_box([0, y_position],:width => 200) do
      text "#{@rl[:bottom_attributes][2][:title]}", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360) do
      text "#{@rl[:bottom_attributes][2][:description]}", size: right_column_font_size, :color => right_column_font_color
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor + 20

    bounding_box([240, y_position],:width => 180) do
      text "Roles", size: left_column_font_size, :color => left_column_font_color
    end

    y_position = cursor - 30

    bounding_box([30, y_position + 30],:width => 180) do
      image "#{Rails.root}/app/assets/images/#{@imagestr1}", width: 300
    end

    bounding_box([270, y_position - 30],:width => 180) do
      text "Primary Role", size: 20
      text "#{@rl[:top_roles][0][:title]}", size: 30
    end

    y_position = cursor - 40

    bounding_box([0, y_position],:width => 540) do
      text "#{@rl[:top_roles][0][:description]}", size: right_column_font_size, :color => right_column_font_color
    end
    
    y_position = cursor - 30

    bounding_box([30, y_position],:width => 180) do
      image "#{Rails.root}/app/assets/images/#{@imagestr2}", width: 300
    end

    bounding_box([270, y_position - 30],:width => 180) do
      text "Secondary Role", size: 20
      text "#{@rl[:top_roles][1][:title]}", size: 30
      y_position -= 160
    end

    bounding_box([0, y_position],:width => 540, :height => bounds.height) do
      text "#{@rl[:top_roles][1][:description]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= (spacing_value + 15)
    end

    # bounding_box([0, y_position],:width => 540, :height => bounds.height) do
    #   text "#{@content[:roles][1][:paragraphs][1]}", size: right_column_font_size, :color => right_column_font_color
    #   y_position -= spacing_value
    # end
  end
end
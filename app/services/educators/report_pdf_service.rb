class Educators::ReportPdfService < Prawn::Document
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

  def header
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]

    # expose results
    categories = @test.categories.includes(:questions).map do |category|
      attrib = category.attributes.select do |k, v|
        [:id, :rank, :title, :description].include? k.intern
      end
      attrib[:questions] = category.questions.all.map do |question|
        question.attributes.select { |k, v| [:id, :polarity].include? k.intern }.symbolize_keys
      end
      attrib.symbolize_keys
    end
    #answers = user.results.order('created_at DESC').find_by(:test_id => params[:test_id]).answers
    answers = Result.order('created_at DESC').find_by(user_id: @userid, test_id: @test.id).answers
    # require file
    #processor_path = Rails.root.join('app', 'processors', "#{test.processor_file}.rb")
    processor_path = Rails.root.join('app', 'processors', "starteur_profiling_assessment.rb")
    require processor_path
    # include the class
    self.class.class_eval do
      include Processor
    end
    # process result
    @content = Processor.process({
      :categories => categories,
      :answers => answers
    })

    # top attributes
    @attriblist = []
    i = 1
    max = @content[:attributes].count

    while i <= max do
      @attriblist.push(@content[:attributes][i])
      i += 1
    end

    @topattrib = []
    j = 0
    jmax = @attriblist.count
    k = 0
    kmax = @attriblist[j].count
    
    while j < jmax do
      while k < kmax do
        if @topattrib[j].blank?
          @topattrib[j] = @attriblist[j][k]
        else
          if @topattrib[j][:score] < @attriblist[j][k][:score]
            @topattrib[j] = @attriblist[j][k]
          end
        end
        k += 1
      end
      j += 1
      k = 0
      kmax = 5
    end

    # bottom attributes
    @botattrib = []
    j = 0
    jmax = @attriblist.count
    k = 0
    kmax = @attriblist[j].count
    
    while j < jmax do
      while k < kmax do
        if @botattrib[j].blank?
          @botattrib[j] = @attriblist[j][k]
        else
          if @botattrib[j][:score] > @attriblist[j][k][:score]
            @botattrib[j] = @attriblist[j][k]
          end
        end
        k += 1
      end
      j += 1
      k = 0
      kmax = 5
    end

    # set starteur potential icon
    @potentialstr = ""
    case "#{@content[:potential]}"
    when "beginning"
      @potentialstr = "icon-potential-1.png"
    when "developing"
      @potentialstr = "icon-potential-2.png"
    when "maturing"
      @potentialstr = "icon-potential-3.png"
    when "eceptional"
      @potentialstr = "icon-potential-4.png"
    end

    # set first role icons
    @imagestr1 = ""
    case "#{@content[:roles][0][:title]}"
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
    case "#{@content[:roles][1][:title]}"
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

    bounding_box([0, y_position],:width => 180, :height => bounds.height) do
      font "Open Sans Light"
      text "Your top attributes", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "Your top attributes are the attributes you display most often. Ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", size: right_column_font_size, :color => right_column_font_color
      y_position -= 60
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "#{@topattrib[0][:name]}", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "#{@topattrib[0][:description]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "#{@topattrib[1][:name]}", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "#{@topattrib[1][:description]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "#{@topattrib[2][:name]}", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "#{@topattrib[2][:description]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= 120
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "Your Bottom Attributes", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "Your bottom attributes are the attributes you display the least. Ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", size: right_column_font_size, :color => right_column_font_color
      y_position -= 60
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "#{@botattrib[0][:name]}", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "#{@botattrib[1][:description]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "#{@botattrib[1][:name]}", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "#{@botattrib[1][:description]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "#{@botattrib[2][:name]}", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "#{@botattrib[2][:description]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor

    bounding_box([0, y_position],:width => 180, :height => bounds.height) do
      image "#{Rails.root}/app/assets/images/#{@potentialstr}", width: 150, at: [100,y_position]
    end

    bounding_box([270, y_position - 60],:width => 180, :height => bounds.height) do
      text "Starteur Potential", size: 20
      text "#{@content[:potential]}", size: 30
      y_position -= 200
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "Determination", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "Determination", size: left_column_font_size, :color => left_column_font_color_bottom
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor

    bounding_box([0, y_position],:width => 180, :height => bounds.height) do
      image "#{Rails.root}/app/assets/images/#{@imagestr1}", width: 300, at: [30,y_position]
    end

    bounding_box([270, y_position - 60],:width => 180, :height => bounds.height) do
      text "Primary Role", size: 20
      text "#{@content[:roles][0][:title]}", size: 30
      y_position -= 180
    end

    bounding_box([0, y_position],:width => 540, :height => bounds.height) do
      text "#{@content[:roles][0][:paragraphs][0]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= (spacing_value + 20)
    end

    bounding_box([0, y_position],:width => 540, :height => bounds.height) do
      text "#{@content[:roles][0][:paragraphs][1]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= (spacing_value + 15)
    end

    bounding_box([0, y_position],:width => 180, :height => bounds.height) do
      image "#{Rails.root}/app/assets/images/#{@imagestr2}", width: 300, at: [30,y_position + (2*spacing_value+220)]
    end

    bounding_box([270, y_position - 50],:width => 180, :height => bounds.height) do
      text "Secondary Role", size: 20
      text "#{@content[:roles][1][:title]}", size: 30
      y_position -= 180
    end

    bounding_box([0, y_position],:width => 540, :height => bounds.height) do
      text "#{@content[:roles][1][:paragraphs][1]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= (spacing_value + 15)
    end

    bounding_box([0, y_position],:width => 540, :height => bounds.height) do
      text "#{@content[:roles][1][:paragraphs][1]}", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    start_new_page
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    y_position = cursor

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "Very good tip", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "Very very good tip", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "Outstanding tip", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end

    bounding_box([0, y_position],:width => 200, :height => bounds.height) do
      text "Excellent tip", size: left_column_font_size, :color => left_column_font_color
    end

    bounding_box([180, y_position],:width => 360, :height => bounds.height) do
      text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", size: right_column_font_size, :color => right_column_font_color
      y_position -= spacing_value
    end
    
  end

  def product_rows
    [['#', 'Name', 'Price']] +
      @batches.each do |batch|
      [batch.test_id, batch.name, batch.email]
    end
  end
end
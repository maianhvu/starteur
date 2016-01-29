class Educators::ReportPdfService < Prawn::Document
  def initialize(params)
    super()
    @batch_id = params[:batch_id]
    @batch = Batch.find(@batch_id)
    @test = Test.find(@batch.test_id)
    header
    text_content
    # table_content
  end

  def header
    #This inserts an image in the pdf file and sets the size of the image
    #image "#{Rails.root}/public/images/header-logo.png", width: 213, height: 48
    image "#{Rails.root}/app/assets/images/bg-pattern-full.png", at: [-48, cursor + 40]
    text "#{@batch.name}", size: 30, style: :bold
    text "#{@test.name}", size: 20, style: :bold
  end

  def text_content
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 30

    bounding_box([0, y_position],:width => bounds.width, :height => bounds.height) do
      text "General Information", size: 20, style: :bold
    end
    
    # The bounding_box takes the x and y coordinates for positioning its content and some options to style it
    bounding_box([0, y_position - 30], :width => 270, :height => bounds.height) do
      text "#{@batch.email.size} students participated in this profiling tool"
      text " "
      text "Profiling began on #{@test.created_at} and ended on #{}"
      text " "
      text "Students were from #{} and average age is #{}"
    end

    bounding_box([300, y_position], :width => 270, :height => bounds.height) do
      text "Batch Report", style: :bold
      text "Generated on #{DateTime.now.to_date}"
    end

    bounding_box([0, y_position - 150],:width => 270, :height => bounds.height) do
      text "Summary of Results", size: 20, style: :bold
      text "#{@test.description}",align: :justify
      text " "
      text "This batch report collates the individual profile of students in a particular batch.",align: :justify
      text " "
      text "Use this customised batch report to better understand the profile of your class, and bring out the best in your student's entrepreneural aptitudes.",align: :justify
    end

    bounding_box([400, y_position - 150],:width => 270, :height => bounds.height) do
      # image 
    end

    bounding_box([0, y_position - 330],:width => 270, :height => bounds.height) do
      text "Starteur Attributes", size: 20, style: :bold
      text "This section displays the most prominent attributes"
    end

    bounding_box([0, y_position - 380],:width => 270, :height => bounds.height) do
      image "#{Rails.root}/app/assets/images/ic-pathfinder.png", scale: 0.3
      image "#{Rails.root}/app/assets/images/ic-develop-static.png", scale: 0.1, at: [-13,cursor]
    end
    
  end

  # def table_content
  #   # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
  #   # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
  #   # Then I set the table column widths
  #   table params.batch do
  #     row(0).font_style = :bold
  #     self.header = true
  #     self.row_colors = ['DDDDDD', 'FFFFFF']
  #     self.column_widths = [40, 300, 200]
  #   end
  # end

  def product_rows
    [['#', 'Name', 'Price']] +
      @batches.each do |batch|
      [batch.test_id, batch.name, batch.email]
    end
  end
end
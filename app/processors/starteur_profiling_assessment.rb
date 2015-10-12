module Processor
  @@roles = [{
    :title => "Engineer",
    :supp_mask => 0b0001000001101000011000100,
    :crit_mask => 0b0000000001001000001000100
  }, {
    :title => "Product Manager",
    :supp_mask => 0b0100000000011100000100011,
    :crit_mask => 0b0100000000001000000100010
  }, {
    :title => "Sales Manager",
    :supp_mask => 0b1010001100100000000100001,
    :crit_mask => 0b1000001100000000000000001
  }, {
    :title => "Business Developer",
    :supp_mask => 0b0010011000000001000010011,
    :crit_mask => 0b0010011000000000000000010
  }, {
    :title => "Marcomms Manager",
    :supp_mask => 0b0010001000000101100000011,
    :crit_mask => 0b0010001000000001000000001
  }, {
    :title => "Designer",
    :supp_mask => 0b0000000000110101110000010,
    :crit_mask => 0b0000000000010001010000010
  }, {
    :title => "Marketer",
    :supp_mask => 0b0001000001001001010100010,
    :crit_mask => 0b0001000000000001000100010
  }, {
    :title => "Customer Service Manager",
    :supp_mask => 0b0000001000010010000011101,
    :crit_mask => 0b0000001000010010000000100
  }, {
    :title => "Admin Manager",
    :supp_mask => 0b0000100010100010000011100,
    :crit_mask => 0b0000100010100000000000100
  }, {
    :title => "Finance Manager",
    :supp_mask => 0b0000100011101000000101000,
    :crit_mask => 0b0000000011100000000001000
  }]

  def self.process(options)
    # prepare scores
    individual = {}
    aggregate  = {}

    # start calculating
    ###################################################################################################
    # STARTEUR PART I
    ###################################################################################################
    part1_attrib = options[:categories].select { |c| c[:rank] < 4 }
    part1_attrib.each do |attrib|
      score = 0.0
      attrib[:questions].each do |question|
        score += (options[:answers][question[:id].to_s].to_i * question[:polarity] + 6) % 7
      end
      score /= attrib[:questions].count

      individual[attrib[:id]] = score
      aggregate[attrib[:rank]] ||= []
      aggregate[attrib[:rank]] << score
    end
    # calculate aggregate
    aggregate.each_pair do |attrib, scores|
      average = 0.0
      scores.each do |score|
        average += score
      end
      average /= scores.count
      aggregate[attrib] = average
    end
    # determine potential
    potential_data = potential(aggregate).to_s

    ###################################################################################################
    # STARTEUR PART II
    ###################################################################################################
    part2_attrib = options[:categories].select { |c| c[:rank] >= 4 }.sort { |a,b| a[:title] <=> b[:title] }
    individual2 = [] # Individual scores for part 2
    aggregate2 = []  # Aggregate scores for part 2
    # calculate score
    part2_attrib.each do |attrib|
      score = attrib[:questions].select { |q| options[:answers][q[:id].to_s].to_i == 1 }.count
      individual2 << score
    end
    # find out role
    @@roles.each do |role|
      supp_mask = role[:supp_mask]
      crit_mask = role[:crit_mask]
      score = 0
      individual2.reverse.each do |i|
        score += (supp_mask & 1) * i
        score += ((crit_mask & 1) << 1) * i
        supp_mask >>= 1
        crit_mask >>= 1
      end
      aggregate2 << { title: role[:title], score: score }
    end
    roles = aggregate2.sort { |a, b| b[:score] <=> a[:score] }.take(2).map { |a| a[:title] }

    ###################################################################################################
    # OUTPUT FINAL RESULT
    ###################################################################################################
    cat_id = 0
    attrib_data = {}
    individual.keys.each do |attrib_id|
      next unless (attrib = options[:categories][cat_id])[:id] == attrib_id
      unless attrib_data.has_key?(attrib[:rank])
        attrib_data[attrib[:rank]] = []
      end
      attrib_data[attrib[:rank]] << {
        name: attrib[:title],
        description: attrib[:description],
        score: individual[attrib_id]
      }
      cat_id += 1
      break if cat_id >= options[:categories].count
    end

    {
      :potential  => potential_data,
      :attributes =>  attrib_data,
      :roles => roles
    }
  end

  private

  def self.potential(aggregate)
    potentials = [:beginning, :developing, :maturing, :exceptional]
    scores = aggregate.values
    rank = 0
    scores.each_index do |i|
      rank = i
      break if scores[i] < 4.6
      rank += 1 if i == scores.count - 1
    end
    potentials[rank % potentials.count]
  end

  def self.hamming(a, b)
    (a^b).to_s(2).count("1")
  end

end

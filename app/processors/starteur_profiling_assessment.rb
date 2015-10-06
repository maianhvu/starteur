module Processor
  def self.process(options)
    # prepare scores
    individual = {}
    aggregate  = {}

    # start calculating
    options[:categories].each do |attrib|
      score = 0.0
      attrib[:questions].each do |question|
        score += (options[:answers][question[:id].to_s].to_i * question[:polarity] + 6) % 7
      end
      score /= attrib[:questions].count # take average
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

    # return results
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
      :attributes =>  attrib_data
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

end

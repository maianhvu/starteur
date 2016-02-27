class Processor
  include SQLHelper

  # Constants
  SCORE_POTENTIAL_MAX = 6
  SCORE_POTENTIAL_MIN = 0
  SCORE_POTENTIAL_THRESHOLD = 4.6

  SCORE_MULTIPLIER_SUPPORTING = 1
  SCORE_MULTIPLIER_CRITICAL   = 3

  TIERS_POTENTIAL = [
    { tier: 0, name: 'Beginning'  },
    { tier: 1, name: 'Developing' },
    { tier: 2, name: 'Maturing'   },
    { tier: 3, name: 'Exceptional'}
  ]

  #
  # Constructor
  #
  def initialize(result_id)
    @result_id = result_id
  end

  def process
    # Get all scores from the result
    scores = Result.find(result_id).scores

    # Calculate potentials
    self.calculate_potential(scores)
  end

  def get_potential
    tier_scores = get_tier_scores
    final_potential_tier = 0

    TIERS_POTENTIAL.each do |potential|
      tier = potential[:tier]
      next unless tier_scores[tier]
      break if tier_scores[tier] < SCORE_POTENTIAL_THRESHOLD
      final_potential_tier = tier
    end

    TIERS_POTENTIAL[final_potential_tier]
  end

  def get_roles
    # Return cache immediately

    return @cached_roles if @cached_roles

    @cached_role_data = self.class.load_roles_data
  end

  def get_tier_scores
    # Return the tier scores result if already calculated
    return @cached_tier_scores if @cached_tier_scores

    # If not, start calculating the tier scores
    result = raw_query(construct_tier_scores_query)

    # Result given is in array form [['<tier_no>', '<tier_average_score>']]
    # Convert result to hash form { <tier_no>: <tier_average_score> }
    tier_scores = {}
    result.each do |row|
      row = row.map(&:to_i)
      tier_scores[row[0]] = row[1]
    end

    # Cache result first
    @cached_tier_scores = tier_scores

    # Return result
    @cached_tier_scores
  end

  def self.get_human_readable_score(score)
    score + 1
  end

  def self.get_tiers
    TIERS_POTENTIAL.reject { |p| p[:tier] == 0 }.map { |p| p[:tier] }
  end

  private

  def self.load_role_data
    data_file_path = File.join(__dir__, 'roles_data.yaml')
    YAML.load(File.read(data_file_path))
  end

  def construct_tier_scores_query
    <<-SQL
    SELECT c.rank, AVG((s.value::float / s.upon) * #{SCORE_POTENTIAL_MAX}) + 1
    FROM scores s, categories c WHERE s.result_id=#{@result_id}
    AND s.category_id=c.id AND c.rank IN (#{self.class.get_tiers.join(', ')})
    GROUP BY c.rank
    SQL
  end


end

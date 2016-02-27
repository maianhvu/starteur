class Processor
  include SQLHelper

  # Constants
  SCORE_POTENTIAL_MAX = 6
  SCORE_POTENTIAL_MIN = 0
  SCORE_POTENTIAL_THRESHOLD = 4.6

  SCORE_MULTIPLIER_SUPPORTING = 1
  SCORE_MULTIPLIER_CRITICAL   = 3

  COUNT_EXTREME_ATTRIBUTES = 5

  #--------------------------------------------------------------------------------------------------
  # Constructor
  #--------------------------------------------------------------------------------------------------
  def initialize(result_id)
    @result_id = result_id
  end

  #--------------------------------------------------------------------------------------------------
  # Main public interface
  #--------------------------------------------------------------------------------------------------
  def process

    # STARTEUR PART 1
    # Calculate potentials
    tier_scores = get_tier_scores
    potential   = get_potential(tier_scores)

    # Attributes
    top_attributes    = get_top_attributes
    bottom_attributes = get_bottom_attributes

    # Return aggregated result
    {
      potential: potential,
      tier_scores: tier_scores,
      tier_score_max: SCORE_POTENTIAL_MAX,

      top_attributes: top_attributes,
      bottom_attributes: bottom_attributes
    }
  end

  #--------------------------------------------------------------------------------------------------
  # Starteur Part I
  #--------------------------------------------------------------------------------------------------

  # Potentials
  def get_potential(tier_scores = nil)
    tier_scores ||= get_tier_scores
    final_potential_tier = 0

    # Load potential data from cache or data file
    @cached_potential_data ||= self.class.load_potential_data

    @cached_potential_data.each do |potential|
      tier = potential[:tier]
      next unless tier_scores[tier]
      break if tier_scores[tier] < self.class.get_human_readable_score(SCORE_POTENTIAL_THRESHOLD)
      final_potential_tier = tier
    end

    @cached_potential_data[final_potential_tier]
  end

  # Top Attributes
  def get_top_attributes
    # Return cache immediately
    return @cached_top_attributes if @cached_top_attributes

    # Query for top attributes
    result = raw_query(construct_top_attributes_query)

    # Extract the title out only
    result = result.map { |row| row[0] }
    @cached_top_attributes = result
  end

  # Bottom Attributes
  def get_bottom_attributes
    # Return cache immediately
    return @cached_bottom_attributes if @cached_bottom_attributes

    # Query for bottom attributes
    result = raw_query(construct_bottom_attributes_query)

    # Extract the title out only
    result = result.map { |row| row[0] }
    @cached_bottom_attributes = result
  end

  # Scores of each tier
  def get_tier_scores
    # Return the tier scores result if already calculated
    return @cached_tier_scores if @cached_tier_scores

    # If not, start calculating the tier scores
    result = raw_query(construct_tier_scores_query)

    # Result given is in array form [['<tier_no>', '<tier_average_score>']]
    # Convert result to hash form { <tier_no>: <tier_average_score> }
    tier_scores = {}
    result.each do |row|
      # Parse columns
      tier_number = row[0].to_i
      tier_score  = row[1].to_f

      # Set hash value
      tier_scores[tier_number] = tier_score
    end

    # Cache result first
    @cached_tier_scores = tier_scores

    # Return result
    @cached_tier_scores
  end

  # Tier numbers
  def get_tiers
    @cached_potential_data ||= self.class.load_potential_data
    @cached_potential_data.reject { |p| p[:tier] == 0 }.map { |p| p[:tier] }
  end

  def self.get_human_readable_score(score)
    score + 1
  end

  #--------------------------------------------------------------------------------------------------
  # Starteur Part II
  #--------------------------------------------------------------------------------------------------
  def get_roles
    # Return cache immediately
    return @cached_roles if @cached_roles

    # Load data from YAML
    @cached_role_data = self.class.load_role_data
    byebug
  end


  private

  #--------------------------------------------------------------------------------------------------
  # YAML Resources
  #--------------------------------------------------------------------------------------------------
  def self.load_role_data
    data_file_path = File.join(__dir__, 'roles_data.yaml')
    YAML.load(File.read(data_file_path))
  end

  def self.load_potential_data
    data_file_path = File.join(__dir__, 'potentials_data.yaml')
    data = YAML.load(File.read(data_file_path))
    data.map(&:symbolize_keys)
  end

  #--------------------------------------------------------------------------------------------------
  # SQL Queries
  #--------------------------------------------------------------------------------------------------
  def construct_tier_scores_query
    <<-SQL
    SELECT c.rank, AVG((s.value::float / s.upon) * #{SCORE_POTENTIAL_MAX}) + 1
    FROM scores s, categories c WHERE s.result_id=#{@result_id}
    AND s.category_id=c.id AND c.rank IN (#{get_tiers.join(', ')})
    GROUP BY c.rank
    SQL
  end

  def construct_top_attributes_query
    <<-SQL
    SELECT c.title, (s.value::float / s.upon) AS score
    FROM scores s, categories c WHERE s.category_id=c.id
    AND c.rank IN (#{get_tiers.join(', ')}) ORDER BY score DESC
    LIMIT #{COUNT_EXTREME_ATTRIBUTES}
    SQL
  end

  def construct_bottom_attributes_query
    <<-SQL
    SELECT c.title, (s.value::float / s.upon) AS score
    FROM scores s, categories c WHERE s.category_id=c.id
    AND c.rank IN (#{get_tiers.join(', ')}) ORDER BY score
    LIMIT #{COUNT_EXTREME_ATTRIBUTES}
    SQL
  end


end

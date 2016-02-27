class Processor
  include SQLHelper

  # Constants
  SCORE_POTENTIAL_MAX = 6
  SCORE_POTENTIAL_MIN = 0
  SCORE_POTENTIAL_THRESHOLD = 4.6

  SCORE_THRESHOLD_ATTRIB_MEDIUM = 0.334
  SCORE_THRESHOLD_ATTRIB_HIGH   = 0.667

  SCORE_MULTIPLIER_SUPPORTING = 1
  SCORE_MULTIPLIER_CRITICAL   = 3

  RANK_CATEGORIES_ROLE = 4
  SCORE_THRESHOLD_ATTRIB_SUPP = 4
  SCORE_THRESHOLD_ATTRIB_CRIT = 5
  SCORE_MULTIPLIER_ATTRIB_SUPP = 1
  SCORE_MULTIPLIER_ATTRIB_CRIT = 3

  COUNT_EXTREME_ATTRIBUTES = 5
  COUNT_ROLES_TOP = 2

  #--------------------------------------------------------------------------------------------------
  # Constructor
  #--------------------------------------------------------------------------------------------------
  def initialize(result)
    @result_id = result.id
    # @user_id   = result.user_id
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

    # Roles
    top_roles = get_roles

    # Return aggregated result
    {
      potential: potential,
      tier_scores: tier_scores,
      tier_score_max: SCORE_POTENTIAL_MAX,

      top_attributes: top_attributes,
      bottom_attributes: bottom_attributes,

      top_roles: top_roles
    }
  end

  #--------------------------------------------------------------------------------------------------
  # Starteur Part I
  #--------------------------------------------------------------------------------------------------

  # Potentials
  def get_potential(tier_scores = nil)
    tier_scores ||= get_tier_scores
    final_potential_tier = 0

    # Load potential data
    potential_data = load_potential_data

    potential_data.each do |potential|
      tier = potential['tier']
      next unless tier_scores[tier]
      break if tier_scores[tier] < self.class.get_human_readable_score(SCORE_POTENTIAL_THRESHOLD)
      final_potential_tier = tier
    end

    potential_data[final_potential_tier].symbolize_keys
  end

  # Top Attributes
  def get_top_attributes
    # Return cache immediately
    return @cached_top_attributes if @cached_top_attributes

    # Query for top attributes
    result = raw_query(construct_top_attributes_query)

    # Load attributes data
    attributes_data = load_attributes_data

    # Extract title and description
    result = result.map do |row|

      title = row[0]
      symbol = row[1]
      score = row[2].to_f

      # Assume title is for high score
      byebug unless attributes_data[symbol]
      description = attributes_data[symbol]['high']
      description = attributes_data[symbol]['medium'] if score < SCORE_THRESHOLD_ATTRIB_HIGH
      # This can't be happening!!
      description = attributes_data[symbol]['low'] if score < SCORE_THRESHOLD_ATTRIB_MEDIUM

      { title: title, description: description }
    end

    @cached_top_attributes = result
  end

  # Bottom Attributes
  def get_bottom_attributes
    # Return cache immediately
    return @cached_bottom_attributes if @cached_bottom_attributes

    # Query for bottom attributes
    result = raw_query(construct_bottom_attributes_query)

    # Load attributes data
    attributes_data = load_attributes_data

    # Extract title and description
    result = result.map do |row|

      title = row[0]
      symbol = row[1]
      score = row[2].to_f

      # Assume title is for low score
      description = attributes_data[symbol]['low']
      description = attributes_data[symbol]['medium'] if score >= SCORE_THRESHOLD_ATTRIB_MEDIUM
      # This can't be happening!!
      description = attributes_data[symbol]['high'] if score >= SCORE_THRESHOLD_ATTRIB_HIGH

      { title: title, description: description }
    end

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

    # Cache and return results
    @cached_tier_scores = tier_scores
  end

  # Tier numbers
  def get_tiers
    potential_data = load_potential_data
    potential_data.reject { |p| p['tier'] == 0 }.map { |p| p['tier'] }
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
    role_data = load_role_data

    # Get raw role scores
    raw_role_scores = raw_query(construct_raw_role_scores_query)
    users_attributes = []
    users_critical_attributes = []

    # Iterate through each attribute and populate the user's supporting
    # and critical attributes based on the score attained (whether they
    # pass the threshold)
    raw_role_scores.each do |row|
      attribute = row[0]
      score = row[1].to_i

      users_attributes << attribute if score >= SCORE_THRESHOLD_ATTRIB_SUPP
      users_critical_attributes << attribute if score >= SCORE_THRESHOLD_ATTRIB_CRIT
    end

    # Go through the specifications of each role and populate the score based on
    # its attributes
    role_scores = role_data.map do |role|
      # Prepare initial value of score
      score = 0

      # Supporting attributes of this role are the keys of the `attributes` mapping
      role_supporting_attributes = role['attributes'].keys
      # Critical attributes of this role are the `true` keys of the `attributes` mapping
      role_critical_attributes   = role['attributes'].select { |k, v| v }.keys

      # Get all the supporting attributes that the user possesses under
      # this particular role
      supporting_intersect = role_supporting_attributes & users_attributes
      # Critical attributes of the user but are not considered critical under this
      # particular role are also counted towards supporting intersection
      non_critical_attributes = users_critical_attributes - role_critical_attributes
      supporting_intersect.push(*non_critical_attributes)

      # Add raw score under supporting intersection to final score
      score += supporting_intersect.count * SCORE_MULTIPLIER_ATTRIB_SUPP

      # Intersection of user's critical attributes and the role's critical attributes
      # constitutes the real critical attributes
      critical_intersect = role_critical_attributes & users_critical_attributes

      # Add raw score under critical intersection to final score
      score += critical_intersect.count * SCORE_MULTIPLIER_ATTRIB_CRIT

      # Strip new line characters
      description = role['description'].map(&:chomp)
      # Return aggregated role data
      {
        title: role['role'],
        description: description,
        icon_url: role['icon_file'],
        score: score
      }
    end

    # Sort results according to score
    role_scores.sort! { |a, b| a[:score] <=> b[:score] }

    # Get only the top 2 attributes
    top_scoring_roles = role_scores.first(COUNT_ROLES_TOP)

    # Cache and return roles
    @cached_roles = top_scoring_roles
  end


  private

  #--------------------------------------------------------------------------------------------------
  # YAML Resources
  #--------------------------------------------------------------------------------------------------
  # YAML Helpers
  def self.load_yaml(file_path)
    YAML.load(File.read(file_path))
  end

  def self.get_data_file_path_from_name(data_file_name)
    File.join(__dir__, data_file_name)
  end

  def self.load_data_file(data_file_name)
    load_yaml(get_data_file_path_from_name(data_file_name))
  end

  # YAML data
  def load_role_data
    Rails.cache.fetch('starteur_profiling_assessment/roles_data') do
      self.class.load_data_file('roles_data.yaml')
    end
  end

  def load_attributes_data
    Rails.cache.fetch('starteur_profiling_assessment/attributes_data') do
      self.class.load_data_file('attributes_data.yaml')
    end
  end

  def load_potential_data
    Rails.cache.fetch('starteur_profiling_assessment/potential_data') do
      self.class.load_data_file('potentials_data.yaml')
    end
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
    SELECT c.title, c.alias, (s.value::float / s.upon) AS score
    FROM scores s, categories c WHERE s.result_id=#{@result_id}
    AND s.category_id=c.id AND c.rank IN (#{get_tiers.join(', ')})
    ORDER BY score DESC LIMIT #{COUNT_EXTREME_ATTRIBUTES}
    SQL
  end

  def construct_bottom_attributes_query
    <<-SQL
    SELECT c.title, c.alias, (s.value::float / s.upon) AS score
    FROM scores s, categories c WHERE s.result_id=#{@result_id}
    AND s.category_id=c.id AND c.rank IN (#{get_tiers.join(', ')})
    ORDER BY score ASC LIMIT #{COUNT_EXTREME_ATTRIBUTES}
    SQL
  end

  def construct_raw_role_scores_query
    <<-SQL
    SELECT c.alias, s.value FROM scores s, categories c
    WHERE s.result_id=#{@result_id} AND s.value>=#{SCORE_THRESHOLD_ATTRIB_SUPP}
    AND s.category_id=c.id AND c.rank=#{RANK_CATEGORIES_ROLE}
    ORDER BY s.value DESC
    SQL
  end

end

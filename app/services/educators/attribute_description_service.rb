class Educators::AttributeDescriptionService
	def initialize(params)
      @attribute = params[:attribute]
	end

	def retrieve_low_description
	  description = ""
      case @attribute
      when "Vision"
        description = "You seldom think about future possibilities, and probably have trouble finding insight whilst planning and moving forward. You tend to be less focused on the big picture, and not as interested in talking about outcomes or exploring different possibilities."
      when "Risk-Tolerance"
        description = "You understand that risks will always be there, but you tend to avoid taking it as much as possible. You see risk as something that should be avoided altogether."
      when "Flexibility"
      	description = "You often have difficulty navigating yourself in ambiguous and uncertain situations. Lack of information and uncertainty frustrates you very much, and prevents you from moving forward."
      when "Assertiveness"
      	description = "You have difficulty in standing up for what you believe in, as well as expressing it with firm hand. You tend to shy away from opportunities where you can express your convictions, and you avoid confrontation with other people at all costs."
	  when "Internality"
	  	description = "You believe that you have little control over whatever happens to you. Despite the amount of effort you put into resolving a matter, you believe that external circumstance tend to have greater influence over your success."
	  when "Independence"
        description = "You tend not to be independent, and would prefer to work under supervision from others. Your inner guidance is not strong, and as such you often need others to instruct you on what you should or should not do."
	  when "Vigour"
	  	description = "You don’t show much enthusiasm in approaching life and appear to be generally less interested in issues. You seldom generate positive energy towards or around others, unless necessary."
	  when "Resilience"
	  	description = "You don’t function too well under pressure and need some time to recover from stress. You may not have coping strategies in place to deal with additional responsibilities or multiple issues simultaneously."
      when "Self-Belief"
	  	description = "You often have doubts about yourself and your capabilities. Despite of the potential that you possess, you sometimes feel insecure and get intimidated easily by setbacks."
	  when "Transcendence"
	  	description = "You are unlikely to be interested in being part of something that is bigger and beyond your own. You don’t feel obliged to work for the benefit of the greater good, nor leave a lasting impact to your immediate community or society."
	  when "Receptivity"
	  	description = "You rarely try to seek feedback from others, nor actively glean new learning experiences. You tend to have less concern or interest on what others have to say when it is against your values or out of your paradigm of thinking."
	  when "Self-Discipline"
	  	description = "You have difficulty in controlling yourself, and often feel unmotivated to start doing tasks that you are supposed to do. You often get distracted and swayed by what you encounter along the way, and may choose to set a different, easier goal to achieve."
	  when "Determination"
	  	description = "You tend to feel easily discouraged by the setbacks that you have encountered. You often feel unsure about whether you can achieve what you have set,  and often lose interest in the face of adversity."
	  when "Proactivity"
	  	description = "You don’t possess much initiative, and tend to wonder what you should be done when a problem arises. You tend to wait for something to happen, and act only when a situation gets out of hand, or when told to do so."
	  when "Achievement"
	  	description = "You don’t have much need for achievement and may get intimidated by new challenges, in spite of the opportunity for self-improvement. You are overly motivated or determined to succeed past your usual thresholds, and often feel satisfied with the status quo."
	  when "Innovativeness"
	  	description = "You need time and effort in order to understand what and how things should be improved, including offering new and better solution to solve a problem. When a past solution is now unusable, you sometimes have difficulty finding an alternative solution, and may feel stuck as a result."
	  end
	  return description
	end

	def retrieve_top_description
      description = ""
      case @attribute
      when "Vision"
        description = "You always think about future possibilities, and tend to have great insight about where and how something should move forward. You tend to enjoy thinking about the big picture, and will usually get excited when exploring further possibilities and alternative outcomes."
      when "Risk-Tolerance"
        description = "You understand that risks will always be there, but you are not afraid in taking it when needed. You see risk as an inevitable aspect in decision making that you can reduce, but not eliminate entirely."
      when "Flexibility"
      	description = "You don’t have much trouble in navigating yourself in ambiguous or uncertain situations. You understand that uncertainty will always exist, but you do not feel threatened by it – instead, you choose to move forward and do what you can and must do to navigate around it."
      when "Assertiveness"
      	description = "You are able to stand up for what you believe in with total honesty and are not afraid to express it with a firm hand. You are highly secure and confident in the way you express your convictions without much fear of confrontation from other people."
      when "Internality"
	  	description = "You have a strong belief that you are in control of whatever happens to you. You believe that both success and failure depends on how much effort you invest into a particular issue; external circumstances have little influence on the outcome or state of your actions."
	  when "Independence"
        description = "You are a highly independent person, and do not require much supervision, if at all, to get things done. You have a strong inner guidance that drives you to do things by yourself, and hardly need instructions from others to achieve outcomes or complete tasks."
      when "Vigour"
	  	description = "You are a passionate person and exude enthusiasm in approaching whatever that life has to offer. You create a positive atmosphere with the people around you with your energy, and can always be counted upon to boost your group’s morale."
	  when "Resilience"
	  	description = "You are tough enough to endure multiples sources of stress, and recover from it swiftly. You have developed coping strategies that have been tried and tested, and you find balance despite being in situations of high internal and external pressure."
	  when "Self-Belief"
	  	description = "You have unwavering faith in yourself and your capabilities. You are self-assured in having what it takes to overcome any setback that you may face in the future, no matter how difficult or trying."
	  when "Transcendence"
	  	description = "You have a strong desire to be part of, and create, something that is bigger and beyond your own self. You have an inner calling and sense of responsibility that wills you to work towards the benefit of the greater good, and you likely endeavour to leave a lasting positive impact to the world."
	  when "Receptivity"
	  	description = "You constantly seek feedback from others to gain new insight, as well as to learning from the experience of others. You are very open to what others have to say, and appreciate differences in viewpoints as they signal new knowledge that can be collected and learned from."
	  when "Self-Discipline"
	  	description = "You have a strong self-control and are capable in overcoming reluctance in beginning or completing tasks. You can focus yourself towards a desired goal, in spite of the many distractions that you would encounter along the way."
	  when "Determination"
	  	description = "You have strong determination to achieve what you have set, and are not easily discouraged by setbacks. Upon deciding on goals and targets, your strong resolution for achievement helps tide you through obstacles, no matter what or how long."
	  when "Proactivity"
	  	description = "You have a strong sense of initiative, and are able to anticipate a course of action when a problem or situation arises. You don’t like to sit around doing nothing and waiting for something to happen, and your bias-to-action keeps you on the go most, if not all of the time."
	  when "Achievement"
	  	description = "You have a strong need for achievement and readily take new challenges that push you out of your comfort zone. You have an innate desire to succeed, and display this by continuously seeking additional avenues for self-improvement and personal growth."
	  when "Innovativeness"
	  	description = "You possess great aptitude in understanding what and how things should be improved, and often offer new and better ways in solving a problem. You don’t get paralysed easily in the face of a problem, and you are often called upon to generate an alternative solution when a previous solution is no longer tenable."
	  end
	  return description
	end
end
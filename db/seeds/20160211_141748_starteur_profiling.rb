test_name = 'Starteur Profiling Assessment'
test = Test.find_by(name: test_name)
test.destroy if test
# Create test
test = Test.create!(
  name: 'Starteur Profiling Assessment',
  description: '',
  price: 0.0,   # temporarily free
  shuffle: true # shuffle questions
)

# Create categories (Attributes)
category_params = {
  :vision          => { rank: 1, title: 'Vision',          symbol: 'Vs' },
  :risk_tolerance  => { rank: 1, title: 'Risk-Tolerance',  symbol: 'Rt' },
  :flexibility     => { rank: 1, title: 'Flexibility',     symbol: 'Fx' },
  :assertiveness   => { rank: 1, title: 'Assertiveness',   symbol: 'As' },
  :internality     => { rank: 1, title: 'Internality',     symbol: 'It' },
  :independence    => { rank: 1, title: 'Independence',    symbol: 'Id' },
  :vigor           => { rank: 2, title: 'Vigor',           symbol: 'Vg' },
  :resilience      => { rank: 2, title: 'Resilience',      symbol: 'Rs' },
  :self_belief     => { rank: 2, title: 'Self-Belief',     symbol: 'Sb' },
  :transcendence   => { rank: 2, title: 'Transcendence',   symbol: 'Tr' },
  :receptivity     => { rank: 2, title: 'Receptivity',     symbol: 'Rc' },
  :self_discipline => { rank: 3, title: 'Self-Discipline', symbol: 'Sd' },
  :determination   => { rank: 3, title: 'Determination',   symbol: 'Dt' },
  :proactivity     => { rank: 3, title: 'Proactivity',     symbol: 'Pr' },
  :achievement     => { rank: 3, title: 'Achievement',     symbol: 'Ac' },
  :innovativeness  => { rank: 3, title: 'Innovativeness',  symbol: 'In' },
}

categories = {}

category_params.each_pair do |key, value|
  value[:test_id] = test.id
  categories[key] = Category.create!(value)
end

# Create questions and choices
question_params = {
:vision => [
  {
    content: "I ___ discuss about my future plans.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I ___ look for future possibilities.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I am ___ about the idea of 'shaking things up'.",
    polarity: 1,
    choices: [
      "resistant",
      "open",
      "excited"
    ]
  },  {
    content: "I can imagine different posibilities in a scenario with ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "I can understand the entire perspective of a situation or issue ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "I am ___ in sharing my ideas and goals for the future with others.",
    polarity: 1,
    choices: [
      "hesitant",
      "comfortable",
      "passionate"
    ]
  },  {
    content: "I can visualise what I want in the future ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "Communicating to others about my dreams and plans is ___ .",
    polarity: 1,
    choices: [
      "difficult",
      "possible",
      "easy"
    ]
  },
],
:risk_tolerance => [
  {
    content: "I am ___ to take a chance and do something new.",
    polarity: -1,
    choices: [
      "not afraid",
      "cautious",
      "afraid"
    ]
  },  {
    content: "I ___ make choices when not all information is provided.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "Making bold, unpopular decisions  is ___ to me.",
    polarity: 1,
    choices: [
      "difficult",
      "possible",
      "easy"
    ]
  },  {
    content: "I make decisions on high-stakes situations with ___ .",
    polarity: 1,
    choices: [
      "hesitation",
      "caution",
      "ease"
    ]
  },  {
    content: "I act on incomplete information with ___ .",
    polarity: 1,
    choices: [
      "hesitation",
      "caution",
      "ease"
    ]
  },  {
    content: "I set challenging but attainable goals with ___ .",
    polarity: 1,
    choices: [
      "hesitation",
      "caution",
      "ease"
    ]
  },  {
    content: "I ___ avoid making difficult decisions.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I ___ take chances, if the payoff is likely to be large.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },
],
:flexibility => [
  {
    content: "I ___ feel nervous when faced with a problem with multiple solutions.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "Not knowing what will heppen in the future is ___ scary to me.",
    polarity: 1,
    choices: [
      "extremely",
      "not so",
      "not at all"
    ]
  },  {
    content: "I am ___ when it comes to a diversity of viewpoints.",
    polarity: 1,
    choices: [
      "resistant",
      "open",
      "excited"
    ]
  },  {
    content: "I am ___ when it comes to a problem which does not have a single answer.",
    polarity: 1,
    choices: [
      "resistant",
      "open",
      "excited"
    ]
  },  {
    content: "I ___ find a project or assignment with no clear instructions stressful.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I find it ___ scary to be thrown into an unfamiliar situation.",
    polarity: 1,
    choices: [
      "extremely",
      "not so",
      "not at all"
    ]
  },  {
    content: "I ___ enjoy getting lost whilst traveling.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "Having a routine is ___ important to me functioning well.",
    polarity: 1,
    choices: [
      "extremely",
      "not so",
      "not at all"
    ]
  },
],
:assertiveness => [
  {
    content: "I have ___ fear of embarrasment, when engaging with an important superior.",
    polarity: 1,
    choices: [
      "extreme",
      "moderate",
      "little"
    ]
  },  {
    content: "I ___ speak boldly about what I believe is right.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I stand up for something I believe in with ___ .",
    polarity: 1,
    choices: [
      "hesitation",
      "caution",
      "ease"
    ]
  },  {
    content: "I express disagreement towards something with ___ .",
    polarity: 1,
    choices: [
      "hesitation",
      "caution",
      "ease"
    ]
  },  {
    content: "I find it ___ to say no to an unwanted request.",
    polarity: 1,
    choices: [
      "difficult",
      "possible",
      "easy "
    ]
  },  {
    content: "I am ___ able to turn down doing a favour for someone else.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "often"
    ]
  },  {
    content: "Sticking to my guts and convictions is ___ .",
    polarity: 1,
    choices: [
      "difficult",
      "possible",
      "easy"
    ]
  },  {
    content: "Telling others exactly what I want with confidence is ___ .",
    polarity: 1,
    choices: [
      "difficult",
      "possible",
      "easy"
    ]
  },
],
:internality => [
  {
    content: "I ___ believe that suceess comes with preparation, and not just through luck or others.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "strongly"
    ]
  },  {
    content: "I ___ believe that difficult circumstances can be turned around.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ believe that happiness depends on what I do with life, not just what happens to me. ",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "strongly"
    ]
  },  {
    content: "I ___ believe that misfortunes happen solely because people aren't hardworking enough.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "strongly"
    ]
  },  {
    content: "My background ___ has an influence on how well I do in life.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ believe that respect is earned through effort, rather than privelege.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "strongly"
    ]
  },  {
    content: "Outside factors have ___ influence on my own success.",
    polarity: 1,
    choices: [
      "insignificant",
      "reasonable",
      "significant"
    ]
  },  {
    content: "My own attitudes and effort contribute ___ to my success as mere luck.",
    polarity: 1,
    choices: [
      "much less",
      "as much",
      "much more"
    ]
  },
],
:independence => [
  {
    content: "I am ___ with the idea of setting up my own rules.",
    polarity: 1,
    choices: [
      "uncomfortable",
      "open",
      "excited"
    ]
  },  {
    content: "I ___ seek guidance to be sure about the decisions that I make.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I ___ need others to instruct me on what I should do next.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I ___ figure out how to solve a problem independently.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ enjoy being told what to do next.",
    polarity: -1,
    choices: [
      "never",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ need others to supervise me when I'm working on a new task.",
    polarity: -1,
    choices: [
      "rarely",
      "occasionally",
      "always"
    ]
  },  {
    content: "I ___ tend to rebel against orders that are not in line with my beliefs and values.",
    polarity: 1,
    choices: [
      "hardly",
      "occasionally",
      "always"
    ]
  },  {
    content: "I ___ rely on others to make difficult decisions.",
    polarity: -1,
    choices: [
      "rarely",
      "occasionally",
      "frequently"
    ]
  },
],
:vigor => [
  {
    content: "I tend to be a ___ person.",
    polarity: 1,
    choices: [
      "cynical",
      "realistic",
      "optimistic"
    ]
  },  {
    content: "My friends have described me as an ___ person.",
    polarity: 1,
    choices: [
      "solemn",
      "even-tempered",
      "upbeat"
    ]
  },  {
    content: "I ___ cheer on others who are feeling down with my positive energy.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ greet others cheerfully.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I am ___ the motivator of the group when morale is down.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "usually"
    ]
  },  {
    content: "I ___ smile.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I am ___ enthusiastic when talking about something.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ get excited at the prospect of experiencing something new.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "often"
    ]
  },
],
:resilience => [
  {
    content: "When stressed out, I tend to cope ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "I ___ get anxious or stressed out.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I can focus on one out of many tasks ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "I ___ get flustered when assigned several tasks.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I ___ feel burned out at the end of a long day.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ get nervous when expected to complete a task within a deadline.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "often"
    ]
  },  {
    content: "I can ___ handle high-pressure situations in a clam manner.",
    polarity: 1,
    choices: [
      "hardly",
      "occasionally",
      "always"
    ]
  },  {
    content: "I ___ snap at others.",
    polarity: -1,
    choices: [
      "never",
      "sometimes",
      "often"
    ]
  },
],
:self_belief => [
  {
    content: "I ___ feel helpless when facing a difficult situation.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I can ___ be depended upon during a crisis.",
    polarity: 1,
    choices: [
      "hardly",
      "occasionally",
      "always"
    ]
  },  {
    content: "I find it ___ that I am able ot overcome any difficulty that comes my way.",
    polarity: 1,
    choices: [
      "doubtful",
      "plausible",
      "confident"
    ]
  },  {
    content: "I can solve any problem ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "I am ___ confident in my ability to deal with unexpected events.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "always"
    ]
  },  {
    content: "I am a ___ person.",
    polarity: 1,
    choices: [
      "unskillful",
      "average",
      "capable"
    ]
  },  {
    content: "I find it ___ that I can do anything if I wanted to.",
    polarity: 1,
    choices: [
      "unlikely",
      "plausible",
      "easy"
    ]
  },  {
    content: "I ___ have faith in my own abilities.",
    polarity: 1,
    choices: [
      "never",
      "sometimes",
      "always"
    ]
  },
],
:transcendence => [
  {
    content: "I ___ identify with groups that have a noble or ethical cause.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "often"
    ]
  },  {
    content: "I have ___ desire to make a significant contribution to the world that I live in.",
    polarity: 1,
    choices: [
      "little",
      "some",
      "strong"
    ]
  },  {
    content: "I ___ believe that I should use my talent to better the world.",
    polarity: 1,
    choices: [
      "don't",
      "somewhat",
      "strongly"
    ]
  },  {
    content: "I am ___ drawn to the idea of helping mankind.",
    polarity: 1,
    choices: [
      "not",
      "somewhat",
      "absolutely"
    ]
  },  {
    content: "Selfless public figures give me ___ inspiration to do noble things.",
    polarity: 1,
    choices: [
      "little",
      "some",
      "strong"
    ]
  },  {
    content: "I ___ want to solve the issues in my country or community.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ believe that I have the ability to make the world a better place.",
    polarity: 1,
    choices: [
      "don't",
      "somewhat",
      "strongly"
    ]
  },  {
    content: "I ___ want to work on something that is bigger than myself.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "always"
    ]
  },
],
:receptivity => [
  {
    content: "I find it ___ to listen to someone with values or beliefs different from my own.",
    polarity: 1,
    choices: [
      "difficult",
      "possible",
      "easy"
    ]
  },  {
    content: "Intellectual discussions are ___ energizing.",
    polarity: 1,
    choices: [
      "rarely",
      "occasionally",
      "always"
    ]
  },  {
    content: "I consider conflicting viewpoints on an issue ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "I ___ enjoy learning about something new for its own sake.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ seek honest feedback from others, be it positive or negative, about my ideas.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ exchange ideas with others to get new perspectives.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ feel offended when others express disapproval to my ideas.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "often"
    ]
  },  {
    content: "I ___ feel the need to defend myself when others disagree.",
    polarity: -1,
    choices: [
      "never",
      "sometimes",
      "always"
    ]
  },
],
:self_discipline => [
  {
    content: "I ___ have difficulty resisting temptation.",
    polarity: -1,
    choices: [
      "never",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ take the easy way out.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "usually"
    ]
  },  {
    content: "Resisting myself from spending on something that I don't need is ___ .",
    polarity: 1,
    choices: [
      "difficult",
      "possible",
      "easy"
    ]
  },  {
    content: "I can control my cravings ___ of the time.",
    polarity: 1,
    choices: [
      "none",
      "some",
      "all"
    ]
  },  {
    content: "Maintaining habits comes to me ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "I ___ procrastinate.",
    polarity: -1,
    choices: [
      "never",
      "sometimes",
      "always"
    ]
  },  {
    content: "I can maintain my focus on my current projects ___ of the time.",
    polarity: 1,
    choices: [
      "none",
      "some",
      "all "
    ]
  },  {
    content: "I can ___ save money consistently.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "easily"
    ]
  },
],
:determination => [
  {
    content: "I ___ finish whatever I begin.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "After a setback, I tend to motivate myself ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "Setbacks ___ hold me from trying harder.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "usually"
    ]
  },  {
    content: "I feel ___ discouraged when people around me are giving up.",
    polarity: 1,
    choices: [
      "extremely",
      "somewhat",
      "barely"
    ]
  },  {
    content: "Spending extra effort to accomplish something is ___ .",
    polarity: 1,
    choices: [
      "unecessary ",
      "optional",
      "necesssary"
    ]
  },  {
    content: "I ___ continue to work hard until I see the fruits of my labour.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ change my goals from time to time.",
    polarity: -1,
    choices: [
      "rarely",
      "somewhat",
      "often"
    ]
  },  {
    content: "I ___ become interested in new pursuits every few months.",
    polarity: -1,
    choices: [
      "hardly",
      "sometimes",
      "often"
    ]
  },
],
:proactivity => [
  {
    content: "I ___ enjoy being idle.",
    polarity: -1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ make things happen.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ volunteer myself to do something instead of waiting to be asked.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "usually"
    ]
  },  {
    content: "I ___ become frustrated when I have to wait for something, instead of taking action. ",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ take immediate action.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "always"
    ]
  },  {
    content: "I tend to have ___ initiative.",
    polarity: 1,
    choices: [
      "low",
      "some",
      "high"
    ]
  },  {
    content: "I ___ get impatient and restless.",
    polarity: 1,
    choices: [
      "never",
      "sometimes",
      "always"
    ]
  },  {
    content: "I ___ ask what I can do for others when I have nothing to do.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "often"
    ]
  },
],
:achievement => [
  {
    content: "I ___ get initimated when given a task that exceeds my capablities.",
    polarity: -1,
    choices: [
      "hardly",
      "sometimes",
      "often"
    ]
  },  {
    content: "I ___ try to get better at what I do.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "often"
    ]
  },  {
    content: "I ___ push myself to my limits.",
    polarity: 1,
    choices: [
      "don't",
      "sometimes",
      "always"
    ]
  },  {
    content: "To me, a job well done is in itself ___ fulfilling than the reward.",
    polarity: 1,
    choices: [
      "less",
      "as",
      "more"
    ]
  },  {
    content: "I ___ enjoy being busy all day.",
    polarity: 1,
    choices: [
      "do not",
      "somewhat",
      "always"
    ]
  },  {
    content: "During competitions, I ___ try to win at all costs.",
    polarity: 1,
    choices: [
      "won't",
      "sometimes",
      "always"
    ]
  },  {
    content: "I have a ___ need to accomplish something that no one has.",
    polarity: 1,
    choices: [
      "slight",
      "moderate",
      "strong"
    ]
  },  {
    content: "Getting to the top is ___ important to me.",
    polarity: 1,
    choices: [
      "least",
      "somewhat",
      "most"
    ]
  },
],
:innovativeness => [
  {
    content: "I ___ like to find new ways of doing things.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I ___ enjoy trying out new concepts or ideas.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "frequently"
    ]
  },  {
    content: "I am ___ to try out unconventional methods.",
    polarity: 1,
    choices: [
      "resistant",
      "open",
      "excited"
    ]
  },  {
    content: "I ___ tend to ask 'what-if' questions.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "often"
    ]
  },  {
    content: "I ___ enjoy creating something from scratch.",
    polarity: 1,
    choices: [
      "hardly",
      "sometimes",
      "always"
    ]
  },  {
    content: "I make associations between completely disparate ideas ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },  {
    content: "I ___ see patterns and trends when others don't.",
    polarity: 1,
    choices: [
      "rarely",
      "sometimes",
      "always"
    ]
  },  {
    content: "I can see how things can be improved ___ .",
    polarity: 1,
    choices: [
      "with difficulty",
      "in time",
      "with ease"
    ]
  },
]
}

question_params.each_pair do |categ, paramz|
  category = categories[categ]
  paramz.each do |question|
    q = Question.new(question)
    q.category = category
    q.test = test
    q.save!
  end
end



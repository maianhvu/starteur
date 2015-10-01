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
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ look for future possibilities.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ about the idea of 'shaking things up'.",
      choices: [
        { content: "resistant", points: -1, ordinal: 0 },
        { content: "open",  points: 0,  ordinal: 1 },
        { content: "excited", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I can imagine different posibilities in a scenario with ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I can understand the entire perspective of a situation or issue ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ in sharing my ideas and goals for the future with others.",
      choices: [
        { content: "hesitant",  points: -1, ordinal: 0 },
        { content: "comfortable", points: 0,  ordinal: 1 },
        { content: "passionate",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I can visualise what I want in the future ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Communicating to others about my dreams and plans is ___ .",
      choices: [
        { content: "difficult", points: -1, ordinal: 0 },
        { content: "possible",  points: 0,  ordinal: 1 },
        { content: "easy",  points: 1,  ordinal: 2 }
      ]
    },
  ],
  :risk_tolerance => [
    {
      content: "I am ___ to take a chance and do something new.",
      choices: [
        { content: "not afraid",  points: 1,  ordinal: 0 },
        { content: "cautious",  points: 0,  ordinal: 1 },
        { content: "afraid",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ make choices when not all information is provided.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Making bold, unpopular decisions  is ___ to me.",
      choices: [
        { content: "difficult", points: -1, ordinal: 0 },
        { content: "possible",  points: 0,  ordinal: 1 },
        { content: "easy",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I make decisions on high-stakes situations with ___ .",
      choices: [
        { content: "hesitation",  points: -1, ordinal: 0 },
        { content: "caution", points: 0,  ordinal: 1 },
        { content: "ease",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I act on incomplete information with ___ .",
      choices: [
        { content: "hesitation",  points: -1, ordinal: 0 },
        { content: "caution", points: 0,  ordinal: 1 },
        { content: "ease",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I set challenging but attainable goals with ___ .",
      choices: [
        { content: "hesitation",  points: -1, ordinal: 0 },
        { content: "caution", points: 0,  ordinal: 1 },
        { content: "ease",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ avoid making difficult decisions.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ take chances, if the payoff is likely to be large.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: 1,  ordinal: 2 }
      ]
    },
  ],
  :flexibility => [
    {
      content: "I ___ feel nervous when faced with a problem with multiple solutions.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "Not knowing what will heppen in the future is ___ scary to me.",
      choices: [
        { content: "extremely", points: -1, ordinal: 0 },
        { content: "not so",  points: 0,  ordinal: 1 },
        { content: "not at all",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ when it comes to a diversity of viewpoints.",
      choices: [
        { content: "resistant", points: -1, ordinal: 0 },
        { content: "open",  points: 0,  ordinal: 1 },
        { content: "excited", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ when it comes to a problem which does not have a single answer.",
      choices: [
        { content: "resistant", points: -1, ordinal: 0 },
        { content: "open",  points: 0,  ordinal: 1 },
        { content: "excited", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ find a project or assignment with no clear instructions stressful.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I find it ___ scary to be thrown into an unfamiliar situation.",
      choices: [
        { content: "extremely", points: -1, ordinal: 0 },
        { content: "not so",  points: 0,  ordinal: 1 },
        { content: "not at all",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ enjoy getting lost whilst traveling.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Having a routine is ___ important to me functioning well.",
      choices: [
        { content: "extremely", points: -1, ordinal: 0 },
        { content: "not so",  points: 0,  ordinal: 1 },
        { content: "not at all",  points: 1,  ordinal: 2 }
      ]
    },
  ],
  :assertiveness => [
    {
      content: "I have ___ fear of embarrasment, when engaging with an important superior.",
      choices: [
        { content: "extreme", points: -1, ordinal: 0 },
        { content: "moderate",  points: 0,  ordinal: 1 },
        { content: "little",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ speak boldly about what I believe is right.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I stand up for something I believe in with ___ .",
      choices: [
        { content: "hesitation",  points: -1, ordinal: 0 },
        { content: "caution", points: 0,  ordinal: 1 },
        { content: "ease",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I express disagreement towards something with ___ .",
      choices: [
        { content: "hesitation",  points: -1, ordinal: 0 },
        { content: "caution", points: 0,  ordinal: 1 },
        { content: "ease",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I find it ___ to say no to an unwanted request.",
      choices: [
        { content: "difficult", points: -1, ordinal: 0 },
        { content: "possible",  points: 0,  ordinal: 1 },
        { content: "easy ", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ able to turn down doing a favour for someone else.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Sticking to my guts and convictions is ___ .",
      choices: [
        { content: "difficult", points: -1, ordinal: 0 },
        { content: "possible",  points: 0,  ordinal: 1 },
        { content: "easy",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Telling others exactly what I want with confidence is ___ .",
      choices: [
        { content: "difficult", points: -1, ordinal: 0 },
        { content: "possible",  points: 0,  ordinal: 1 },
        { content: "easy",  points: 1,  ordinal: 2 }
      ]
    },
  ],
  :internality => [
    {
      content: "I ___ believe that suceess comes with preparation, and not just through luck or others.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "strongly",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ believe that difficult circumstances can be turned around.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ believe that happiness depends on what I do with life, not just what happens to me. ",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "strongly",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ believe that misfortunes happen solely because people aren't hardworking enough.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "strongly",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "My background ___ has an influence on how well I do in life.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ believe that respect is earned through effort, rather than privelege.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "strongly",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Outside factors have ___ influence on my own success.",
      choices: [
        { content: "insignificant", points: -1, ordinal: 0 },
        { content: "reasonable",  points: 0,  ordinal: 1 },
        { content: "significant", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "My own attitudes and effort contribute ___ to my success as mere luck.",
      choices: [
        { content: "much less", points: -1, ordinal: 0 },
        { content: "as much", points: 0,  ordinal: 1 },
        { content: "much more", points: 1,  ordinal: 2 }
      ]
    },
  ],
  :independence => [
    {
      content: "I am ___ with the idea of setting up my own rules.",
      choices: [
        { content: "uncomfortable", points: -1, ordinal: 0 },
        { content: "open",  points: 0,  ordinal: 1 },
        { content: "excited", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ seek guidance to be sure about the decisions that I make.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ need others to instruct me on what I should do next.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ figure out how to solve a problem independently.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ enjoy being told what to do next.",
      choices: [
        { content: "never", points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ need others to supervise me when I'm working on a new task.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "occasionally",  points: 0,  ordinal: 1 },
        { content: "always",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ tend to rebel against orders that are not in line with my beliefs and values.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "occasionally",  points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ rely on others to make difficult decisions.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "occasionally",  points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },
  ],
  :vigor => [
    {
      content: "I tend to be a ___ person.",
      choices: [
        { content: "cynical", points: -1, ordinal: 0 },
        { content: "realistic", points: 0,  ordinal: 1 },
        { content: "optimistic",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "My friends have described me as an ___ person.",
      choices: [
        { content: "solemn",  points: -1, ordinal: 0 },
        { content: "even-tempered", points: 0,  ordinal: 1 },
        { content: "upbeat",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ cheer on others who are feeling down with my positive energy.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ greet others cheerfully.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ the motivator of the group when morale is down.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "usually", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ smile.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ enthusiastic when talking about something.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ get excited at the prospect of experiencing something new.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: 1,  ordinal: 2 }
      ]
    },
  ],
  :resilience => [
    {
      content: "When stressed out, I tend to cope ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ get anxious or stressed out.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I can focus on one out of many tasks ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ get flustered when assigned several tasks.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ feel burned out at the end of a long day.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ get nervous when expected to complete a task within a deadline.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: -1, ordinal: 2 }
      ]
    },  {
      content: "I can ___ handle high-pressure situations in a clam manner.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "occasionally",  points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ snap at others.",
      choices: [
        { content: "never", points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: -1, ordinal: 2 }
      ]
    },
  ],
  :self_belief => [
    {
      content: "I ___ feel helpless when facing a difficult situation.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I can ___ be depended upon during a crisis.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "occasionally",  points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I find it ___ that I am able ot overcome any difficulty that comes my way.",
      choices: [
        { content: "doubtful",  points: -1, ordinal: 0 },
        { content: "plausible", points: 0,  ordinal: 1 },
        { content: "confident", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I can solve any problem ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ confident in my ability to deal with unexpected events.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am a ___ person.",
      choices: [
        { content: "unskillful",  points: -1, ordinal: 0 },
        { content: "average", points: 0,  ordinal: 1 },
        { content: "capable", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I find it ___ that I can do anything if I wanted to.",
      choices: [
        { content: "unlikely",  points: -1, ordinal: 0 },
        { content: "plausible", points: 0,  ordinal: 1 },
        { content: "easy",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ have faith in my own abilities.",
      choices: [
        { content: "never", points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },
  ],
  :transcendence => [
    {
      content: "I ___ identify with groups that have a noble or ethical cause.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I have ___ desire to make a significant contribution to the world that I live in.",
      choices: [
        { content: "little",  points: -1, ordinal: 0 },
        { content: "some",  points: 0,  ordinal: 1 },
        { content: "strong",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ believe that I should use my talent to better the world.",
      choices: [
        { content: "don't", points: -1, ordinal: 0 },
        { content: "somewhat",  points: 0,  ordinal: 1 },
        { content: "strongly",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ drawn to the idea of helping mankind.",
      choices: [
        { content: "not", points: -1, ordinal: 0 },
        { content: "somewhat",  points: 0,  ordinal: 1 },
        { content: "absolutely",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Selfless public figures give me ___ inspiration to do noble things.",
      choices: [
        { content: "little",  points: -1, ordinal: 0 },
        { content: "some",  points: 0,  ordinal: 1 },
        { content: "strong",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ want to solve the issues in my country or community.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ believe that I have the ability to make the world a better place.",
      choices: [
        { content: "don't", points: -1, ordinal: 0 },
        { content: "somewhat",  points: 0,  ordinal: 1 },
        { content: "strongly",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ want to work on something that is bigger than myself.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },
  ],
  :receptivity => [
    {
      content: "I find it ___ to listen to someone with values or beliefs different from my own.",
      choices: [
        { content: "difficult", points: -1, ordinal: 0 },
        { content: "possible",  points: 0,  ordinal: 1 },
        { content: "easy",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Intellectual discussions are ___ energizing.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "occasionally",  points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I consider conflicting viewpoints on an issue ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ enjoy learning about something new for its own sake.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ seek honest feedback from others, be it positive or negative, about my ideas.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ exchange ideas with others to get new perspectives.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ feel offended when others express disapproval to my ideas.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ feel the need to defend myself when others disagree.",
      choices: [
        { content: "never", points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: -1, ordinal: 2 }
      ]
    },
  ],
  :self_discipline => [
    {
      content: "I ___ have difficulty resisting temptation.",
      choices: [
        { content: "never", points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ take the easy way out.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "usually", points: -1, ordinal: 2 }
      ]
    },  {
      content: "Resisting myself from spending on something that I don't need is ___ .",
      choices: [
        { content: "difficult", points: -1, ordinal: 0 },
        { content: "possible",  points: 0,  ordinal: 1 },
        { content: "easy",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I can control my cravings ___ of the time.",
      choices: [
        { content: "none",  points: -1, ordinal: 0 },
        { content: "some",  points: 0,  ordinal: 1 },
        { content: "all", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Maintaining habits comes to me ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ procrastinate.",
      choices: [
        { content: "never", points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I can maintain my focus on my current projects ___ of the time.",
      choices: [
        { content: "none",  points: -1, ordinal: 0 },
        { content: "some",  points: 0,  ordinal: 1 },
        { content: "all ",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I can ___ save money consistently.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "easily",  points: 1,  ordinal: 2 }
      ]
    },
  ],
  :determination => [
    {
      content: "I ___ finish whatever I begin.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "After a setback, I tend to motivate myself ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Setbacks ___ hold me from trying harder.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometmes",  points: 0,  ordinal: 1 },
        { content: "usually", points: -1, ordinal: 2 }
      ]
    },  {
      content: "I feel ___ discouraged when people around me are giving up.",
      choices: [
        { content: "extremely", points: -1, ordinal: 0 },
        { content: "somewhat",  points: 0,  ordinal: 1 },
        { content: "barely",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Spending extra effort to accomplish something is ___ .",
      choices: [
        { content: "unecessary ", points: -1, ordinal: 0 },
        { content: "optional",  points: 0,  ordinal: 1 },
        { content: "necesssary",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ continue to work hard until I see the fruits of my labour.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ change my goals from time to time.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "somewhat",  points: 0,  ordinal: 1 },
        { content: "often", points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ become interested in new pursuits every few months.",
      choices: [
        { content: "hardly",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: -1, ordinal: 2 }
      ]
    },
  ],
  :proactivity => [
    {
      content: "I ___ enjoy being idle.",
      choices: [
        { content: "rarely",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ make things happen.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometmes",  points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ volunteer myself to do something instead of waiting to be asked.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "usually", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ become frustrated when I have to wait for something, instead of taking action. ",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ take immediate action.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I tend to have ___ initiative.",
      choices: [
        { content: "low", points: -1, ordinal: 0 },
        { content: "some",  points: 0,  ordinal: 1 },
        { content: "high",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ get impatient and restless.",
      choices: [
        { content: "never", points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ ask what I can do for others when I have nothing to do.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: 1,  ordinal: 2 }
      ]
    },
  ],
  :achievement => [
    {
      content: "I ___ get initimated when given a task that exceeds my capablities.",
      choices: [
        { content: "hardly",  points: 1,  ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: -1, ordinal: 2 }
      ]
    },  {
      content: "I ___ try to get better at what I do.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ push myself to my limits.",
      choices: [
        { content: "don��t",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "To me, a job well done is in itself ___ fulfilling than the reward.",
      choices: [
        { content: "less",  points: -1, ordinal: 0 },
        { content: "as",  points: 0,  ordinal: 1 },
        { content: "more",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ enjoy being busy all day.",
      choices: [
        { content: "do not",  points: -1, ordinal: 0 },
        { content: "somewhat",  points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "During competitions, I ___ try to win at all costs.",
      choices: [
        { content: "won't", points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I have a ___ need to accomplish something that no one has.",
      choices: [
        { content: "slight",  points: -1, ordinal: 0 },
        { content: "moderate",  points: 0,  ordinal: 1 },
        { content: "strong",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "Getting to the top is ___ important to me.",
      choices: [
        { content: "least", points: -1, ordinal: 0 },
        { content: "somewhat",  points: 0,  ordinal: 1 },
        { content: "most",  points: 1,  ordinal: 2 }
      ]
    },
  ],
  :innovativeness => [
    {
      content: "I ___ like to find new ways of doing things.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ enjoy trying out new concepts or ideas.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "frequently",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I am ___ to try out unconventional methods.",
      choices: [
        { content: "resistant", points: -1, ordinal: 0 },
        { content: "open",  points: 0,  ordinal: 1 },
        { content: "excited", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ tend to ask 'what-if' questions.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "often", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ enjoy creating something from scratch.",
      choices: [
        { content: "hardly",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I make associations between completely disparate ideas ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I ___ see patterns and trends when others don't.",
      choices: [
        { content: "rarely",  points: -1, ordinal: 0 },
        { content: "sometimes", points: 0,  ordinal: 1 },
        { content: "always",  points: 1,  ordinal: 2 }
      ]
    },  {
      content: "I can see how things can be improved ___ .",
      choices: [
        { content: "with difficulty", points: -1, ordinal: 0 },
        { content: "in time", points: 0,  ordinal: 1 },
        { content: "with ease", points: 1,  ordinal: 2 }
      ]
    },
  ]
}

question_params.each_pair do |categ, paramz|
  category = categories[categ]
  paramz.each do |question|
    q = Question.create!(content: question[:content], category: category)
    question[:choices].each do |choice|
      c = Choice.new(choice)
      c.question = q
      c.save!
    end
  end
end



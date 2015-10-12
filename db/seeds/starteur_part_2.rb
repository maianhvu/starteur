test = Test.find_by(name: "Starteur Profiling Assessment")

categories = {
  :achiever => {
    :title => 'Achiever',
    :questions => [
      { :content => 'I have great stamina and have always been known to work harder and longer than most people.' },
      { :content => 'I am a high achiever.' },
      { :content => 'Including evenings and weekends, my typical work week is in excess of 60 hours.' },
      { :content => 'I like work.' },
      { :content => 'If I don\'t accomplish something meaningful by the end of each day, I feel dissatisfied with myself.' },
    ]
  },
  :activator => {
    :title => 'Activator',
    :questions => [
      { :content => 'I am a thrill-seeker.' },
      { :content => 'I take risks.' },
      { :content => 'Once I have made a decision, I have to act.' },
      { :content => 'It is easy for to start new tasks.' },
      { :content => 'I tend to ask the question "so when can we start".' },
      { :content => 'I act on something rather than wait.' },
    ]
  },
  :adaptability => {
    :title => 'Adaptability',
    :questions => [
      { :content => 'I "go with the flow" and keep an overview of issues.' },
      { :content => 'I discover the future one day at a time.' },
      { :content => 'I prefer to go with the flow and live in the moment.' },
      { :content => 'I respond to things as they occur.' },
      { :content => 'My work is determined by the demands of the day.' },
      { :content => 'I take things as they come.' },
    ]
  },
  :analytical => {
    :title => 'Analytical',
    :questions => [
      { :content => 'Answers and issues emerge naturally for me.' },
      { :content => 'I think a lot about cause and effect.' },
      { :content => 'I like to figure out how things work.' },
      { :content => 'I am aware of all the factors affecting the situation.' },
      { :content => 'I analyse.' },
      { :content => 'I am analytical about issues facing my life.' },
    ]
  },
  :arranger => {
    :title => 'Arranger',
    :questions => [
      { :content => 'When things get tough and I need things done perfectly, I tend to jump in to get it done myself.' },
      { :content => 'I like to arrange things for other people.' },
      { :content => 'I organise.' },
      { :content => 'My nature is to check as often as necessary to be sure everything is in order.' },
      { :content => 'I find different ways to do things.' },
      { :content => 'I am good at figuring out how people who are very different can work together.' },
    ]
  },
  :command => {
    :title => 'Command',
    :questions => [
      { :content => 'I sometimes intimidate others.' },
      { :content => 'I am a leader.' },
      { :content => 'No matter what the situation or where, I always naturally know the right things to do.' },
      { :content => 'Last minute pressure focuses my mind.' },
      { :content => 'I want to control the events of my life.' },
      { :content => 'As a child, I was quite aggressive and independent.' },
    ]
  },
  :communication => {
    :title => 'Communication',
    :questions => [
      { :content => 'I am a good conversationalist.' },
      { :content => 'My friends ask me to tell stories.' },
      { :content => 'I am a good story teller.' },
      { :content => 'I am never at a loss for words.' },
      { :content => 'It is easy for me to put my thoughts into words.' },
      { :content => 'I have a gift for simplifying complexities.' },
    ]
  },
  :competition => {
    :title => 'Competition',
    :questions => [
      { :content => 'I strive to win first place.' },
      { :content => 'I like contests.' },
      { :content => 'I am never fully satisfied until I am number one in competitions.' },
      { :content => 'I like to go to athletic events.' },
      { :content => 'I am a top achiever.' },
      { :content => 'Winning is everything.' },
    ]
  },
  :consistency => {
    :title => 'Consistency',
    :questions => [
      { :content => 'I believe it is absolutely essential to treat all people equally and to have clear rules for people to follow.' },
      { :content => 'I have a gift of treating different people equally.' },
      { :content => 'I treat all people equally.' },
      { :content => 'Balance is important to me.' },
      { :content => 'I am fair.' },
      { :content => 'I am best in an environment that is consistent and treats people fairly.' },
    ]
  },
  :deliberative => {
    :title => 'Deliberative',
    :questions => [
      { :content => 'I set aside planning time about the future.' },
      { :content => 'I use my head for important decisions.' },
      { :content => 'I need to be sure I am right before I take action.' },
      { :content => 'I use exact, well-researched information.' },
      { :content => 'I am conscientious.' },
      { :content => 'Whenever I am in a group, I seem to be the best prepared.' },
    ]
  },
  :discipline => {
    :title => 'Discipline',
    :questions => [
      { :content => 'I like to follow a sequence.' },
      { :content => 'For me, everything has to be planned.' },
      { :content => 'I like work that requires exactness.' },
      { :content => 'I am routinised.' },
      { :content => 'I avoid messy people.' },
      { :content => 'I always make deadlines.' },
    ]
  },
  :empathy => {
    :title => 'Empathy',
    :questions => [
      { :content => 'I am a senstive person.' },
      { :content => 'I can put myself into someone\'s life and understand what they are going through.' },
      { :content => 'I listen to people so I can make them feel understood.' },
      { :content => 'My friends ask my advice.' },
      { :content => 'I can sense the feelings of associates.' },
      { :content => 'I am generous.' },
    ]
  },
  :focus => {
    :title => 'Focus',
    :questions => [
      { :content => 'I follow a written plan for my future.' },
      { :content => 'I prioritise things, then act.' },
      { :content => 'My way is focusing on one thing at a time.' },
      { :content => 'I have the power to follow through.' },
      { :content => 'When I need to, I can concentrate on my work for hours at a time.' },
      { :content => 'People who have not figured out their goals irritate me.' },
    ]
  },
  :futuristic => {
    :title => 'Futuristic',
    :questions => [
      { :content => 'I like spending time with futurists.' },
      { :content => 'Everyday I talk many times about my future.' },
      { :content => 'I can focus on what I could acheive in the future.' },
      { :content => 'I am creating the future.' },
      { :content => 'I visualise the future.' },
      { :content => 'What can be achieved in the future inspires me.' },
    ]
  },
  :harmony => {
    :title => 'Harmony',
    :questions => [
      { :content => 'I am a bridge builder for people.' },
      { :content => 'As a child, I fit in well and caused no problems with peers or adults.' },
      { :content => 'I am agreeable with people.' },
      { :content => 'I bring harmony to people who are working together.' },
      { :content => 'My vocabulary consists of practical words.' },
      { :content => 'I see what people have in common, even during conflict.' },
    ]
  },
  :ideation => {
    :title => 'Ideation',
    :questions => [
      { :content => 'I love looking at things from different angles.' },
      { :content => 'A new idea makes my day.' },
      { :content => 'Whenever I am in a group, I seem to have more ideas than the others.' },
      { :content => 'I enjoy discussing big ideas with associates.' },
      { :content => 'I appreciate orginality and novelty.' },
      { :content => 'New ideas and concepts come to me easily.' },
    ]
  },
  :individualisation => {
    :title => 'Individualisation',
    :questions => [
      { :content => 'I pick out just the right gifts for each of my friends.' },
      { :content => 'I get to know people individually.' },
      { :content => 'I believe in discovering what is unique about each person and motivating them individually.' },
      { :content => 'I study what makes others tick.' },
      { :content => 'I understand how different people might be able to work together effectively.' },
      { :content => 'I don\'t like generalizing people.' },
    ]
  },
  :input => {
    :title => 'Input',
    :questions => [
      { :content => 'I like lectures.' },
      { :content => 'I like to listen.' },
      { :content => 'I like to read.' },
      { :content => 'I never stop absorbing information.' },
      { :content => 'I am inquisitive.' },
      { :content => 'I like to collect things.' },
    ]
  },
  :learner => {
    :title => 'Learner',
    :questions => [
      { :content => 'I have a commitment to growth.' },
      { :content => 'I grow when I learn.' },
      { :content => 'I am open to learning new things.' },
      { :content => 'I have a great desire to learn.' },
      { :content => 'I have a craving to know more.' },
      { :content => 'I think about what I must improve.' },
    ]
  },
  :maximiser => {
    :title => 'Maximiser',
    :questions => [
      { :content => 'I progress by capitalising on my talents.' },
      { :content => 'Building on my talents is my way for achieving.' },
      { :content => 'I tend to rely on the strengths of the people on my team and don\'t try to do it all myself.' },
      { :content => 'I strengthen people.' },
      { :content => 'I push others to succeed.' },
      { :content => 'I know my strengths better than my weaknesses.' },
    ]
  },
  :relator => {
    :title => 'Relator',
    :questions => [
      { :content => 'I like to work hard with friends.' },
      { :content => 'I want a few deep friendships that are very important to me.' },
      { :content => 'I want a few friends that I know a lot about.' },
      { :content => 'I am drawn to others whom I already know.' },
      { :content => 'I derive a great deal of strength from being around my close friends.' },
      { :content => 'I have a very small group of friends with whom I have incredibly deep relationships.' },
    ]
  },
  :responsibility => {
    :title => 'Responsibility',
    :questions => [
      { :content => 'I do not associate with dishonest people.' },
      { :content => 'My responsibility keeps me going.' },
      { :content => 'I am responsible and dependable.' },
      { :content => 'When necessary, I register a complain or call out a wrongdoing.' },
      { :content => 'I follow through and do what I said I would do.' },
      { :content => 'Doing it right is everything.' },
    ]
  },
  :restorative => {
    :title => 'Restorative',
    :questions => [
      { :content => 'I progress by overcoming my weakness.' },
      { :content => 'I seek out people who will be honest with me about my weaknesses.' },
      { :content => 'Overcoming weaknesses and removing deficiencies are my ways for achieving.' },
      { :content => 'I figure out how and why I have failed.' },
      { :content => 'I know my weaknesses better than my strengths.' },
      { :content => 'It is easy for me to admit the truth about myself.' },
    ]
  },
  :strategic => {
    :title => 'Strategic',
    :questions => [
      { :content => 'Patterns and issues emerge naturally for me to see.' },
      { :content => 'I am a creative, strategic thinker.' },
      { :content => 'I get a thrill from discovering a pattern in the data.' },
      { :content => 'I sort through clutter and find the best route or path.' },
      { :content => 'I see patterns where others see complexity.' },
      { :content => 'I envision alternative scenarios when posed with a problem.' },
    ]
  },
  :woo => {
    :title => 'Woo',
    :questions => [
      { :content => 'I am good at enlisting people for a project.' },
      { :content => 'I like to be with people.' },
      { :content => 'I get a rush from striking up a conversation with a stranger.' },
      { :content => 'I am a social butterfly.' },
      { :content => 'I am outgoing.' },
      { :content => 'I can get along with anybody.' },
    ]
  },
}

categories.each_value do |category|
  cat = Category.create!(title: category[:title], test: test, rank: 4)

  category[:questions].each do |question|
    q = Question.new(content: question[:content])
    q.category = cat
    q.choices = ['No', 'Yes']
    q.polarity = 1
    q.save!
  end
end

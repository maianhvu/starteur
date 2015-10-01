module API
  class TestsController < AuthenticatedController
    before_action :authenticate

    def index
      tests = Test.published.all
      test_ids = tests.map(&:id)
      codes = user.access_codes
      purchased = []
      completed = []
      code_hash = {}
      if codes.count > 0
        purchased = codes.map(&:test_id).uniq
        codes = AccessCode.where('test_id IN (?)', purchased).all
        codes.each do |code|
          code_hash[code.test_id] = code.code
        end
        unless purchased.empty?
          completed = user.code_usages.map(&:result).compact.map(&:test_id).uniq
        end
      end

      @test_data = tests.map do |test|
        p = false
        c = false
        code = nil
        if purchased.include? test.id then
          p = true
          code = code_hash[test.id]

          if completed.include? test.id then
            c = true
          end
        end
        return_hash = {
          id: test.id,
          name: test.name,
          price: test.price,
          purchased: p,
          completed: c
        }
        return_hash[:description] = test.description if test.description
        return_hash[:access_code] = code if code
        return_hash
      end

      render 'index.json.jbuilder', :status => :ok
    end

    #private

    #def intersect(a, b)
      #a.sort!
      #b.sort!
      #c = []
      #a_cur = 0
      #b_cur = 0
      #while a_cur < a.size && b_cur < b.size
        #if a[a_cur] < b[b_cur]
          #a_cur += 1
        #elsif a[a_cur] > b[b_cur]
          #b_cur += 1
        #else
          #c << a[a_cur] unless c == a[a_cur]
          #a_cur += 1
          #b_cur += 1
        #end
      #end
      #c
    #end
  end

end

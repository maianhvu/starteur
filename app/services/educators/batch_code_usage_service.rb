class Educators::BatchCodeUsageService

  attr_reader :errors

  def assign_code_usages_for_emails(email_list, batch)
    @errors = {}
    test = batch.test

    access_codes = AccessCode.where(educator: batch.educator, test: test)
    available_access_codes = access_codes.where('access_codes.code_usages_count < access_codes.permits').order(created_at: :desc)

    counter = 0
    @errors.store(:base, 'No available access codes') unless available_access_codes.any?
    while (email = email_list[counter]) && available_access_codes.any?
      user = User.find_by(email: email)
      cu = user ? CodeUsage.find_by(user: user, test: test) : CodeUsage.find_by(email: email, test: test)
      if cu
        if !BatchCodeUsage.find_by(batch: batch, code_usage: cu)
          if user
            BatchCodeUsage.create(batch: batch, code_usage: cu, own: false)
            Educators::UserMailer.request_access_permission(email, batch).deliver_now
          else
            BatchCodeUsage.create(batch: batch, code_usage: cu, own: false)
            Educators::UserMailer.request_access_permission_after_signup(email, batch).deliver_now
          end
        end
      else
        if access_code = prepare_access_code(available_access_codes)
          cu = CodeUsage.create(access_code: access_code, email: email, user: user, test: test)
          if cu.errors.empty?
            BatchCodeUsage.create(batch: batch, code_usage: cu, own: true)
            Educators::UserMailer.send_code_usage(email, cu, batch).deliver_now
          else
            @errors.store(:email, cu.errors)
          end
        else
          @errors.store(:base, 'Insufficient code usages')
        end
      end
      counter += 1
    end
    @errors.empty?
  end

  def delete_code_usage(code_usage)
    code_usage.destroy
  end

  private

  def prepare_access_code(available_access_codes)
    access_code = available_access_codes.last
    if access_code && access_code.code_usages_count >= access_code.permits
      available_access_codes = available_access_codes.where("permits > 0")
      return false if available_access_codes.empty?
      access_code = prepare_access_code(available_access_codes)
    end
    access_code
  end

end

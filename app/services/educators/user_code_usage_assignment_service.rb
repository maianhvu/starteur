class Educators::UserCodeUsageAssignmentService

  attr_accessor :errors

  def assign_code_usages(user)
    errors = {}
    code_usages = CodeUsage.where(email: user.email)
    code_usages.each do |cu|
      unless cu.update(user: user) && cu.use!(user)
        errors.store(cu.uuid, cu.errors)
      end
    end
    errors.empty?
  end

end

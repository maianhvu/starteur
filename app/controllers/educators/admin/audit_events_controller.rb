class Educators::Admin::AuditEventsController < Educators::Admin::BaseController

  def index
    @audit_events = AuditEvent.all
  end

  def show
    @event = AuditEvent.find(params[:id])
  end

end

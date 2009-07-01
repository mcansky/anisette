class Event < ActiveRecord::Base
  belongs_to :repository

  def return_real
    # return real object behind the event
    # catching the null find if the real event has been destroyed
    # if so the object destroys itself
    e = nil
    case
      when self.event_type == 1
        begin
          e = Bug.find(self.event_id)
        rescue
          self.destroy
        end
        return e
      when self.event_type == 0
        begin
          e = AnisetteCommit.find(self.event_id)
        rescue
          self.destroy
        end
        return e
    end
  end
  
end

class CalculatePerformDareInteractions < ActiveRecord::Migration
  def self.up
    all_users = User.find(:all)
    for actor in all_users
      for subject in all_users
        if Interactions::PerformDare.meets_criteria?(actor, subject)
          Interactions::PerformDare.ensure_created(actor, subject)
        end
      end
    end
  end

  def self.down
    execute "DELETE FROM interactions WHERE type = 'PerformDare'"
  end
end

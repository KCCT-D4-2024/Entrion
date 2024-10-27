namespace :user do
  desc "Update user status"
  task update_user_status: :environment do
    User.all.each do |user|
      if user.status == "entered"
        user.update(status: :exited)
      end
    end
  end
end
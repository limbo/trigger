namespace :search do
  desc "Rebuild search indexes"
  task :reindex => [:environment] do
    Update.rebuild_index
  end
end
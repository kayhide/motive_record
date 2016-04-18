class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    true
  end
end

if RUBYMOTION_ENV == 'development'
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'development.sqlite')
end

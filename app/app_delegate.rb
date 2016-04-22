class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    true
  end
end

if RUBYMOTION_ENV == 'development'
  Dir[File.expand_path('resources/migrate/**/*.rb')].each { |f| require f }

  database = 'development.sqlite'
  # database = ':memory:'

  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
  dir = File.join(NSBundle.mainBundle.resourcePath, 'migrate/books')

  ActiveRecord::Migrator.migrate dir
end



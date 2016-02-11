MotionBlender.except

namespace :motive_record do
  namespace :migrate do
    task :prepare do
      config = Motion::Project::App.config
      resources_dir = Pathname.new(config.resources_dirs.first)
      migrate_dir = Pathname.new(config.project_dir).join('app/migrate')

      Dir[File.join(migrate_dir, '**/*.rb')].each do |file|
        name = Pathname.new(file).relative_path_from(migrate_dir).to_s
        dst = resources_dir.join('migrate', name)
        dst.dirname.mkpath
        file dst => file do
          Motion::Project::App.info('Copy', file)
          FileUtils.cp file, dst
        end
        task 'motive_record:migrate:copy' => dst
      end
      Rake::Task['motive_record:migrate:copy'].invoke
    end

    task :copy

    task :clean do
      config = Motion::Project::App.config
      resources_dir = Pathname.new(config.resources_dirs.first)
      dir = resources_dir.join('migrate')
      if dir.exist?
        Motion::Project::App.info('Delete', dir.to_s)
        dir.rmtree
      end
    end
  end
end

%w(build:simulator build:device).each do |t|
  task t => 'motive_record:migrate:prepare'
end

task 'clean' => 'motive_record:migrate:clean'

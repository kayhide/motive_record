require "bundler/gem_tasks"

if (Rake.application.top_level_tasks - Rake.application.tasks.map(&:name)).any?
  $:.unshift("/Library/RubyMotion/lib")
  require 'motion/project/template/ios'
  Bundler.require

  require 'motive_support/all'
  require 'motion-redgreen'
  require 'motion-stump'
  require 'motion_print'

  MotionBlender.config.excepted_files << 'fiddle/import'
  MotionBlender.config.excepted_files << 'socket'

  Motion::Project::App.setup do |app|
    app.name = 'MotiveRecord'
    app.redgreen_style = :progress

    if app.spec_mode
      require File.join(app.specs_dir, 'helpers/_init')
    end
  end
end

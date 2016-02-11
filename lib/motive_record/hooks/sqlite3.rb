MotionBlender.on_require 'sqlite3' do
  require 'motion.h'
  Motion::Project::App.setup do |app|
    app.libs << "/usr/lib/libsqlite3.dylib"
    app.include "sqlite3.h"
  end
end

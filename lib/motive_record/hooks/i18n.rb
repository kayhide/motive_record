MotionBlender.on_require 'active_support/i18n' do
  require 'i18n'

  dirs = $LOAD_PATH.grep(/\bactiverecord\b/).map do |dir|
    File.join(dir, 'active_record/locale/*.yml')
  end
  Dir[*dirs].each do |f|
    locale = f[/[-\w]+(?=\.yml$)/]
    item = [f, "locale/active_record/#{locale}.yml"]
    unless I18n.load_path.include? item
      I18n.load_path << item
    end
  end
end

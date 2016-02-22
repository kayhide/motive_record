require __ORIGINAL__

module ActiveRecord
  class SchemaMigration < ActiveRecord::Base
    # def version
    #   super.to_i
    # end
    def version
      read_attribute(:version).to_i
    end
  end
end

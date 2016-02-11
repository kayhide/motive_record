module ActiveRecord
  class Relation
    MULTI_VALUE_METHODS  = [:includes, :eager_load, :preload, :select, :group,
                            :order, :joins, :where, :having, :bind, :references,
                            :extending, :unscope]

    SINGLE_VALUE_METHODS = [:limit, :offset, :lock, :readonly, :from, :reordering,
                            :reverse_order, :distinct, :create_with, :uniq]
    INVALID_METHODS_FOR_DELETE_ALL = [:limit, :distinct, :offset, :group, :having]

    VALUE_METHODS = MULTI_VALUE_METHODS + SINGLE_VALUE_METHODS
  end
end

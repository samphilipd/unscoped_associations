require 'unscoped_associations/version'

module UnscopedAssociations
  def self.included(base)
    base.extend ClassMethods
    class << base
      alias_method_chain :belongs_to, :unscoped
      alias_method_chain :has_many, :unscoped
      alias_method_chain :has_one, :unscoped
    end
  end

  module ClassMethods
    def belongs_to_with_unscoped(target, scope = nil, options = {})
      build_unscoped(:belongs_to, target, scope, options)
    end

    def has_many_with_unscoped(target, scope = nil, options = {}, &extension)
      build_unscoped(:has_many, target, scope, options, &extension)
    end

    def has_one_with_unscoped(target, scope = nil, options = {})
      build_unscoped(:has_one, target, scope, options)
    end

    private

    def build_unscoped(assoc_type, target, scope = nil, options = {}, &extension)
      if scope.is_a?(Hash)
        options = scope
        scope   = nil
      end

      apply_unscoped = options.delete(:unscoped)

      if scope
        send("#{assoc_type}_without_unscoped", target, scope, options, &extension)
      else
        send("#{assoc_type}_without_unscoped", target, options, &extension)
      end

      unscope_association(target) if apply_unscoped
    end

    def unscope_association(target)
      define_method("#{target}_with_unscoped") do |*args|
        association(target).klass.unscoped do
          send("#{target}_without_unscoped", args)
        end
      end

      alias_method_chain target, :unscoped
    end
  end
end

ActiveRecord::Base.send(:include, UnscopedAssociations)

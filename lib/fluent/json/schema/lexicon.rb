require 'singleton'


module Fluent
  module Json
    module Schema
      class Lexicon
        include Singleton

        def dictionary
          Fluent::Lexicon.reflect(Fluent::Json::Schema::Terms)
        end

        def translator
          lambda do |term|
            term.to_s.singularize.to_sym
          end
        end

        def combiner
          named = lambda do |definition, name| 
            definition.new(name) 
          end

          optioned = lambda do |definition, name, options| 
            definition.new(name, options) 
          end

          lambda do |api, term, definition, args, block|
            if definition.class.name.demodulize.downcase.to_sym == term
              return api.add(definition.new(*args, &block))
            end

            results = Fluent::Lexicon.collect(
              named.curry.(definition), 
              optioned.curry.(definition)
            ).call(*args)

            results.each do |result|
              block.call(result) if block.present?
              api.add(result)
            end 
            
            return api
          end
        end
      end
    end
  end
end


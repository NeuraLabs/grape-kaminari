require 'grape/kaminari/version'
require 'grape/kaminari/max_value_validator'
require 'kaminari/grape'

module Grape
  
  module Kaminari
    
    def self.included(base)
      
      base.class_eval do
        
        helpers do

          def page
            params[:page]
          end

          def page_size
            params[:page_size]
          end

          def offset
            params[:offset]
          end

          def paginate(collection)
            collection.page(page).per(page_size).padding(params[:offset]).tap do |data|
              header 'X-Total',       data.total_count
              header 'X-Total-Pages', data.num_pages
              header 'X-Page',        data.current_page
              header 'X-Next-Page',   data.next_page
              header 'X-Prev-Page',   data.prev_page
              header 'X-Page-Size',   page_size
              header 'X-Offset',      offset
            end
          end

        end

        def self.paginate(options = {})
          options.reverse_merge!(
            :page_size     => ::Kaminari.config.default_per_page || 10,
            :max_page_size => ::Kaminari.config.max_per_page     || 100,
            :offset        => 0
          )
          params do
            optional :page,      type: Integer, default: 1
            optional :page_size, type: Integer, default: options[:page_size]
            if options[:offset].is_a? Numeric
              optional :offset, type: Integer,  default: options[:offset]
            end
          end
        end

      end

    end

  end
  
end

# frozen_string_literal: true

require_relative './pluck_to_hash/version'

module PluckToHash
  module Extensions
    def pluck_to_hash(*keys)
      hash_type = keys[-1].is_a?(Hash) ? keys.pop.fetch(:hash_type, HashWithIndifferentAccess) : HashWithIndifferentAccess
      block_given = block_given?
      keys_for_pluck, keys_for_hash = _process_keys(keys)
      single_key = keys_for_pluck.size == 1

      pluck(*keys_for_pluck).map do |row|
        value = row.nil? ? nil : hash_type[keys_for_hash.zip(single_key ? [row] : row)]
        block_given ? yield(value) : value
      end
    end

    def pluck_to_struct(*keys)
      struct_type = keys[-1].is_a?(Hash) ? keys.pop.fetch(:struct_type, Struct) : Struct
      block_given = block_given?
      keys_for_pluck, keys_for_struct = _process_keys(keys)
      single_key = keys_for_pluck.size == 1
      struct = struct_type.new(*keys_for_struct)

      pluck(*keys_for_pluck).map do |row|
        value = row.nil? ? nil : (single_key ? struct.new(row) : struct.new(*row))
        block_given ? yield(value) : value
      end
    end

    private

    def _process_keys(keys)
      is_array = is_a?(Array)

      if keys.blank?
        if is_array
          [[], []]
        else
          [column_names, column_names]
        end
      else
        keys_for_pluck = []
        keys_for_hash_or_struct = []

        keys.each do |key|
          case key
          when String
            key_parts =
              key.split(/\bas\b/i).map do |part|
                part.strip.to_sym
              end

            keys_for_pluck << (is_array ? key_parts.first : key)
            keys_for_hash_or_struct << key_parts.last
          when Symbol
            keys_for_pluck << key
            keys_for_hash_or_struct << key
          end
        end

        [keys_for_pluck, keys_for_hash_or_struct]
      end
    end

    alias pluck_h pluck_to_hash
    alias pluck_s pluck_to_struct
  end

  module Concern
    extend ActiveSupport::Concern

    module ClassMethods
      include Extensions
    end
  end
end

ActiveRecord::Base.include(PluckToHash::Concern)
Array.include(PluckToHash::Extensions)

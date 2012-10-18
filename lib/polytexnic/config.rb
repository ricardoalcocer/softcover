require 'yaml/store'

module Polytexnic
  class BaseConfig

    DEFAULTS = {
      host: 'http://polytexnic.com'
    }

    class << self
      def [](key)
        store.transaction do
          store[key]
        end || DEFAULTS[key.to_sym]
      end

      def []=(key, value)
        store.transaction do
          store[key] = value
        end
      end

      def read
        puts `cat #{file_path}`
      end

      def remove
        File.delete(file_path) if File.exists?(file_path)
      end

      protected
        def store
          @store ||= begin
             YAML::Store.new(file_path)
          end
        end

        def file_path
          File.expand_path(self::PATH).tap do |path|
            path.gsub!(/$/,"-test") if Polytexnic::test?
          end
        end
    end
  end

  class BookConfig < BaseConfig
    PATH = ".polytexnic-book"
  end

  class Config < BaseConfig
    PATH = "~/.polytexnic"
  end
end
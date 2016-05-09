require 'active_support/all'

require 'oh_my_embed/crawler'
require 'oh_my_embed/provider'
require 'oh_my_embed/version'

module OhMyEmbed

  module Providers
    # Setup autoloading for every provider in oh_my_embed/providers
    Dir.glob(File.join(__dir__, 'oh_my_embed', 'providers', '*.rb')).each do |provider_path|
      autoload File.basename(provider_path, '.rb').camelize, provider_path
    end
  end

  # All OhMyEmbed errors inherits from a generic OhMyEmbed::Error class
  #
  # - OhMyEmbed::UnknownProvider
  # - OhMyEmbed::ProviderNotFound
  # - OhMyEmbed::NotFound
  # - OhMyEmbed::PermissionDenied
  # - OhMyEmbed::FormatNotSupported
  # - OhMyEmbed::ParseError
  class Error < StandardError; end

  class UnknownProvider < OhMyEmbed::Error # nodoc #
    def self.new(provider)
      super("Can't register unknown provider '#{provider}'")
    end
  end

  class ProviderNotFound < OhMyEmbed::Error # nodoc #
    def self.new(url)
      super("No provider found for given content_url (#{url}). Do you have registered the associated provider?")
    end
  end

  class NotFound < OhMyEmbed::Error # nodoc #
    def self.new(url)
      super("No embed code for this content (#{url}) found")
    end
  end

  class PermissionDenied < OhMyEmbed::Error # nodoc #
    def self.new(url)
      super("You don't have permissions to access the embed code for this content (#{url})")
    end
  end

  class FormatNotSupported < OhMyEmbed::Error # nodoc #
    def self.new(provider_name)
      super("The provider '#{provider_name}' doesn't support json")
    end
  end

  class ParseError < OhMyEmbed::Error # nodoc #
    def self.new(provider_name, url, data_string)
      super("Parsing failed for content (#{data_string}); Provider: #{provider_name}; URL: #{url}")
    end
  end
end

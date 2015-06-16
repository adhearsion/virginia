# encoding: utf-8
require 'singleton'
require 'virginia/document_cache/document'

module Virginia
  class DocumentCache
    include Celluloid

    NotFound = Class.new StandardError

    DEFAULT_CONTENT_TYPE = 'text/plain'
    DEFAULT_LIFETIME = 10

    attr_reader :mutex

    class << self
      def method_missing(m, *args, &block)
        Celluloid::Actor[:virginia_document_cache].send m, *args, &block
      end
    end

    def initialize
      @documents = {}

      every(60) do
        logger.debug "Reaping expired cached document"
        reap_expired!
      end
    end

    # Registers a new document with the cache
    # @param [Object] document The document to be stored in the cache
    # @param [Fixnum, Nil] lifetime The amount of time in seconds the document should be kept. If nil, document will be kept indefinitely.
    # @param [String, Nil] id The ID to use to store the document. If nil, one will be generated.
    # @return [String] Cache ID of the stored document
    def store(document, content_type = DEFAULT_CONTENT_TYPE, lifetime = DEFAULT_LIFETIME, id = nil)
      id ||= generate_id
      doc = Virginia::DocumentCache::Document.new id, document, content_type, lifetime
      store_document doc
    end

    # Registers a new Virginia::DocumentCache::Document with the cache
    # @param [Virginia::DocumentCache::Document] document The document to be stored in the cache
    # @return [String] Cache ID of the stored document
    def store_document(document)
      @documents[document.id] =  document
      document.id
    end

    # Deletes a document from the cache
    # @param [Object] id ID of the document to be removed from the cache
    # @return [Object, Nil] document Returns the document if found in the cache, nil otherwise
    def delete(id)
      @documents.delete id
    end

    # Retrieves a document from the cache
    # @param [String] id ID of the document to be retrieved from the cache
    # @yield If given, will be used to generate the document, store it, and then return.
    # @return [Virginia::DocumentCache::Document] Returns the document if found in the cache
    # @raises [Virginia::DocumentCache::NotFound] If the document is not found in the cache
    def fetch(id)
      unless @documents.has_key? id
        if block_given?
          result = yield
          if result.is_a? Document
            store_document result
          else
            args = *yield
            doc = Virginia::DocumentCache::Document.new id, args[0], args[1] || DEFAULT_CONTENT_TYPE, args[2] || DEFAULT_LIFETIME
            store_document doc
          end
        else
          abort NotFound.new
        end
      end

      @documents[id]
    end

    def reap_expired!
      @documents.each_pair do |id, doc|
        @documents.delete(id) if doc[:expires_at] < Time.now
      end
    end

  private

    def generate_id
      SecureRandom.hex(16)
    end
  end
end

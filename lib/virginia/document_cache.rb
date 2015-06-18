# encoding: utf-8
require 'singleton'
require 'virginia/document_cache/document'

module Virginia
  class DocumentCache
    include Celluloid

    NotFound = Class.new StandardError

    DEFAULT_CONTENT_TYPE = 'text/plain'
    DEFAULT_LIFETIME = 10

    execute_block_on_receiver :register

    class << self
      def method_missing(m, *args, &block)
        Celluloid::Actor[:virginia_document_cache].send m, *args, &block
      end
    end

    def initialize
      @documents = {}
      @document_creators = {}

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
      # Check for a registered creator first
      check_and_run_creator id unless @documents.has_key? id

      # If we still don't have a document, check for a supplied block
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

    # Registers a creation callback to populate a given document when requested
    # @param [String] id ID of the document for which the creator should be registered
    # @param [String] content_type Content-Type of the document
    # @param [Fixnum, Nil] lifetime The amount of time in seconds the document should be kept. If nil, document will be kept indefinitely.
    # @return [Nil, Object] nil if the ID was not found among the creators; otherwise the creator is returned
    def register(id, content_type, lifetime = DEFAULT_LIFETIME, &callback)
      @document_creators[id] = {
        content_type: content_type,
        lifetime: lifetime,
        callback: callback,
      }
    end

    # Removes a document creator registration by ID
    # @param [String] id ID of the document for which the creator should be deleted
    # @return [Nil, Object] nil if the ID was not found among the creators; otherwise the creator is returned
    def unregister(id)
      @document_creators.delete id
    end

    def reap_expired!
      @documents.each_pair do |id, doc|
        @documents.delete(id) if doc.expires_at && doc.expires_at < Time.now
      end
    end

  private

    def generate_id
      SecureRandom.hex(16)
    end

    def check_and_run_creator(id)
      if creator = @document_creators[id]
        begin
          store_document Document.new id, creator[:callback].call, creator[:content_type], creator[:lifetime]
        rescue => e
          abort e
        end
      end
    end
  end
end

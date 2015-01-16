# encoding: utf-8
require 'singleton'

module Virginia
  class DocumentCache
    include Singleton

    NotFound = Class.new StandardError

    attr_reader :mutex

    class << self
      def method_missing(m, *args, &block)
        instance.mutex.synchronize do
          instance.send m, *args, &block
        end
      end
    end

    def initialize
      @mutex = Mutex.new
      @documents = {}

      supervisor = Housekeeping.supervise_as :document_cache_housekeeping
      Adhearsion::Events.register_callback :shutdown do
        supervisor.terminate
      end
    end

    # Registers a new document with the cache
    # @param [Object] document The document to be stored in the cache
    # @param [Fixnum, Nil] lifetime The amount of time in seconds the document should be kept. If nil, document will be kept indefinitely.
    # @param [String, Nil] id The ID to use to store the document. If nil, one will be generated.
    # @return [String] ID of the stored document
    def store(document, lifetime = 10, id = nil)
      id ||= generate_id
      @documents[id] = {
        document: document,
        expires: lifetime ? Time.now + lifetime : nil
      }
      id
    end

    # Deletes a document from the cache
    # @param [Object] id ID of the document to be removed from the cache
    # @return [Object, Nil] document Returns the document if found in the cache, nil otherwise
    def delete(id)
      data = @documents.delete id
      data[:document]
    end

    # Retrieves a document from the cache
    # @param [String] id ID of the document to be retrieved from the cache
    # @return [Object] document Returns the document if found in the cache
    # @raises [NotFound] If the document is not found in the cache
    def fetch(id)
      raise NotFound unless @documents.has_key? id
      @documents[id][:document]
    end

    def reap_expired!
      @documents.each_pair do |id, data|
        @documents.delete(id) if data[:expires] < Time.now
      end
    end

    class Housekeeping
      include Celluloid

      def initialize
        every(1.minute) do
          logger.debug "Reaping expired cached document"
          DocumentCache.reap_expired!
        end
      end
    end

  private

    def generate_id
      SecureRandom.hex(16)
    end
  end
end

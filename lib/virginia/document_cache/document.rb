# encoding: utf-8

module Virginia
  class DocumentCache
    class Document < Struct.new(:id, :body, :content_type, :lifetime, :created_at, :expires_at)
      def initialize(id, body, content_type = 'text/plain', lifetime = nil)
        self.id, self.body, self.content_type, self.lifetime = id, body, content_type, lifetime
        self.created_at = Time.now
        if self.lifetime
          self.expires_at = self.created_at + self.lifetime
        end
      end
    end
  end
end

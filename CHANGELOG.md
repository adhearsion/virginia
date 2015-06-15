# develop
  * BREAKING CHANGES! Read below:
  * Support for storing document content-types with the document
  * Add document metadata to the document cache. You must now specify the content type (or use the default of text/plain) when caching a document. This way Virginia knows how to serve it when it is requested.
  * Wrap cached documents and store them as Virginia::DocumentCache::Document
  * When retrieving a document from the cache, return the wrapped document
  * Switch DocumentCache to an Actor for better performance
  * Load & start DocumentCache's actor by default

# Version 0.4.0
  * Add document cache

# Version 0.3.0
  * Switch to Rackup-style app management

# Version 0.2.1
  * Removed Octarine from dependencies

# Version 0.2.0
  * Reverted to using a pure Reel handler because Reel::App does not exist any more

# Version 0.1.0
  * First official release

# Version 0.0.2
  * Now using Reel::App instead of an explicit handler

# Version 0.0.1
  * First version

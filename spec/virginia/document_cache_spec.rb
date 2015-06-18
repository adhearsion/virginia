# encoding: utf-8
require 'spec_helper'
require 'virginia/document_cache'

describe Virginia::DocumentCache do
  let(:subject) { Virginia::DocumentCache.new }

  it 'should store the document and return the ID' do
    expect(subject.store('foo')).to be_a String
  end

  it 'should allow me to retrieve the document by ID' do
    doc = 'foobar'
    id = subject.store doc
    expect(subject.fetch(id).body).to eq doc
  end

  it 'should allow me to store and retrieve a document with a specified ID' do
    subject.store 'foobar', 'text/plain', nil, 'abc123'
    expect(subject.fetch('abc123').body).to eq 'foobar'
  end

  it 'should store the document content type' do
    id = subject.store '{foo: "bar"}', 'application/json'
    expect(subject.fetch(id).content_type).to eq 'application/json'
  end

  it 'should allow me to specify a lifetime' do
    Timecop.freeze
    id = subject.store 'foobar', 'text/plain', 30
    doc = subject.fetch id
    doc.expires_at.should == Time.now + 30
    Timecop.return
  end

  it 'should remove (only) expired documents from the cache' do
    Timecop.freeze
    id1 = subject.store 'foobar', 'text/plain', 30
    id2 = subject.store 'bazqux', 'text/plain', 90
    Timecop.travel Time.now + 60
    subject.reap_expired!

    expect { subject.fetch(id1) }.to raise_error Virginia::DocumentCache::NotFound
    expect(subject.fetch(id2).body).to eq 'bazqux'
    Timecop.return
  end

  context 'auto-creation on #fetch' do
    let(:doc_id) { 'boo' }
    let(:body) { 'abcd' }
    let(:ctype) { 'text/plain' }
    let(:lifetime) { 93 }

    before :each do
      Timecop.freeze
      expect { subject.fetch(doc_id) }.to raise_error Virginia::DocumentCache::NotFound
    end

    after :each do 
      doc = subject.fetch doc_id
      expect(doc.body).to eq body
      expect(doc.content_type).to eq ctype
      expect(doc.expires_at).to eq Time.now + lifetime
      Timecop.return
    end

    it 'should allow me to supply a block to #store and create a document if one is not already cached' do
      subject.fetch(doc_id) do
        [body, 'text/plain', lifetime]
      end
    end

    it 'should allow me to supply a block to #store that returns a document and cache it, if one is not already cached' do
      subject.fetch(doc_id) do
        Virginia::DocumentCache::Document.new doc_id, body, ctype, lifetime
      end
    end
  end

  context 'registering document content at an id' do
    let(:doc_id) { 'abcd1234' }
    let(:body) { 'once upon a time there was a muppet' }
    let(:ctype) { 'application/x-powa' }
    let(:lifetime) { 193 }

    before :each do
      expect { subject.fetch(doc_id) }.to raise_error Virginia::DocumentCache::NotFound
      Timecop.freeze
    end

    after :each do
      Timecop.return
    end

    context 'auto-creating documents' do
      before :each do
      end

      after :each do
        doc = subject.fetch doc_id
        expect(doc.body).to eq body
        expect(doc.content_type).to eq ctype
        expect(doc.expires_at).to eq Time.now + lifetime
      end

      it 'should auto-populate the document if not found in the cache' do
        subject.register(doc_id, ctype, lifetime) do
          body
        end
      end

      it 'should not invoke the block if the document is already in the cache' do
        subject.store body, ctype, lifetime, doc_id
        subject.register(doc_id, ctype, lifetime) do
          raise "Should not get here!"
        end
      end
    end

    it 'should allow removing a document creator' do
      Timecop.freeze
      subject.register(doc_id, ctype, lifetime) do
        body
      end
      doc = subject.fetch(doc_id)

      # Move past expiration and clean up the cached document
      Timecop.travel Time.now + (lifetime + 1) 
      subject.reap_expired!

      subject.unregister(doc_id)
      expect { subject.fetch(doc_id) }.to raise_error Virginia::DocumentCache::NotFound
      Timecop.return
    end
  end
end

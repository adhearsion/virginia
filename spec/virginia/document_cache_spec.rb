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

  it 'should allow me to supply a block to #store and create a document if one is not already cached' do
    Timecop.freeze
    id, body, ctype, lifetime = 'boo', 'abcd', 'text/plain', 93
    expect { subject.fetch(id) }.to raise_error Virginia::DocumentCache::NotFound
    subject.fetch(id) do
      [body, 'text/plain', lifetime]
    end
    doc = subject.fetch id
    expect(doc.body).to eq body
    expect(doc.content_type).to eq ctype
    expect(doc.expires_at).to eq Time.now + lifetime
    Timecop.return
  end

  it 'should allow me to supply a block to #store that returns a document and cache it, if one is not already cached' do
    Timecop.freeze
    id, body, ctype, lifetime = 'boo', 'abcd', 'application/x-blammo', 35
    expect { subject.fetch(id) }.to raise_error Virginia::DocumentCache::NotFound
    subject.fetch(id) do
      Virginia::DocumentCache::Document.new id, body, ctype, lifetime
    end
    doc = subject.fetch id
    expect(doc.body).to eq body
    expect(doc.content_type).to eq ctype
    expect(doc.expires_at).to eq Time.now + lifetime
    Timecop.return
  end
end

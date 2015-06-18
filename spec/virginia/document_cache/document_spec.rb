# encoding: utf-8
require 'spec_helper'

describe Virginia::DocumentCache::Document do
  let(:subject) { Virginia::DocumentCache::Document }

  before :each do
    Timecop.freeze
    @document = subject.new 'fake_id', 'fake_content'
  end

  after :each do
    Timecop.return
  end

  it 'should accurately represent my content' do
    expect(@document.body).to eq 'fake_content'
  end

  it 'should automatically set the created_at time' do
    expect(@document.created_at).to eq Time.now
  end

  it 'should default to an empty expiration time' do
    expect(@document.expires_at).to be_nil
  end

  it 'should automatically determine the expiration time' do
    # TODO: Use Timecop to make this test more precise
    doc = subject.new '1', 'foo', 'text/plain', 30
    expect(doc.expires_at).to eq Time.now + 30
  end
end

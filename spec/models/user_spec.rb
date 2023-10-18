require 'rails_helper'

describe User do
  let(:name) { 'test' }
  let(:email) { 'test@example.com' }

  describe '.first' do
    before do
      create(:user, name: name, email: email)
    end

    subject { described_class.first }

    it '事前に作成した通りのUserを返す' do
      expect(subject.name).to eq('test')
      expect(subject.email).to eq('test@example.com')
    end
  end
end

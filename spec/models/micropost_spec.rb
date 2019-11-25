require 'rails_helper'

RSpec.describe Micropost, type: :model do
  describe 'ポストの作成' do
    let(:user) { create(:user) }
    let(:micropost) { build(:micropost, user: user) }

    # shared_examples_for 'ポストが無効である' do
    #   it { expect(micropost).to be_invalid }
    # end

    it '有効な投稿' do
      expect(micropost).to be_valid
    end

    it 'ユーザーIDがないポストは無効であること' do
      micropost.user_id = nil
      expect(micropost).to be_invalid
    end

    it 'contentがないポストは無効であること' do
      micropost.content = " "
      expect(micropost).to be_invalid
    end

    it 'titleがないポストは無効であること' do
      micropost.title = " "
      expect(micropost).to be_invalid
    end

    it 'categoryがないポストは無効であること' do
      micropost.category = " "
      expect(micropost).to be_invalid
    end

    it 'categoryが21文字以上のポストは無効であること' do
      micropost.category = "a" * 21
      expect(micropost).to be_invalid
    end

    it '紐づけられたコメントが削除されること' do
      micropost.save
      create(:comment, user: user, micropost: micropost)
      expect{ micropost.destroy }.to change{ Comment.count }.by(-1)
    end

    it '紐づけられたいいねが削除されること' do
      micropost.save
      Like.create(user: user, micropost: micropost)
      expect{ micropost.destroy }.to change{ Like.count }.by(-1)
    end

    it '関連づけられた通知が削除されること' do
      micropost.save
      create(:notification, micropost: micropost)
      expect{ micropost.destroy }.to change{ Notification.count }.by(-1)
    end

  end
end

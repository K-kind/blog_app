require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'コメント作成・削除' do
    let(:comment) { build(:comment) }

    it '401文字以上のコメントは無効であること' do
      comment.content = "a" * 401
      expect(comment).to be_invalid
    end
    
    it '関連した通知が削除されること' do
      comment.save
      create(:notification, comment: comment)
      expect{ comment.destroy }.to change{ Notification.count }.by(-1)
    end
  end
end

require 'rails_helper'

describe UserMailer, type: :mailer do
  let(:user) { create(:user, email: 'mail_to@example.com', reset_token: 'reset_token') }

  let(:text_body) do
    part = mail.body.parts.detect { |part| part.content_type == 'text/plain; charset=UTF-8' }
    part.body.raw_source
  end
  let(:html_body) do
    part = mail.body.parts.detect { |part| part.content_type == 'text/html; charset=UTF-8' }
    part.body.raw_source
  end

  describe 'アカウント有効化メール' do
    let(:mail) { UserMailer.account_activation(user) }

    it '有効化メールが想定の内容を含む' do
      expect(mail.subject).to eq('Progress：アカウント有効化用メール')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@progress.monster'])

      expect(text_body).to match("#{user.name}さん")
      expect(text_body).to match(user.activation_token)
      expect(text_body).to match(CGI.escape(user.email))

      expect(html_body).to match("#{user.name}さん")
      expect(html_body).to match(user.activation_token)
      expect(html_body).to match(CGI.escape(user.email))
    end
  end

  describe 'パスワードリセットメール' do
    let(:mail) { UserMailer.password_reset(user) }

    it 'パスワードリセットメールが想定の内容を含む' do
      expect(mail.subject).to eq('Progress：パスワードリセット用メール')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@progress.monster'])

      expect(text_body).to match("#{user.name}さん")
      expect(text_body).to match(user.reset_token)
      expect(text_body).to match(CGI.escape(user.email))

      expect(html_body).to match("#{user.name}さん")
      expect(html_body).to match(user.reset_token)
      expect(html_body).to match(CGI.escape(user.email))
    end
  end
end
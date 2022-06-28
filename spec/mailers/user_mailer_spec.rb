require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  let(:mail) { UserMailer.with(user: user).welcome_email }

  it 'renders the headers' do
      expect(mail.subject).to eq("Welcome to Social Scrolls!, #{user.name}!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['andrewjh271@yahoo.com'])
      expect(mail.content_type).to start_with('multipart/alternative') #html / text support
  end

  it "renders the body" do
    string = "You have succesfully signed up with #{user.email}."
    expect(mail.body.encoded).to match(string)
  end

  # All 'sent' emails are gathered into the ActionMailer::Base.deliveries array.
  it 'welcome_email is sent' do
      expect {
          mail.deliver_now
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
  end

  it 'welcome_email is sent to the right user' do
      mail.deliver_now
      expect(ActionMailer::Base.deliveries.last.to[0]).to eq user.email
  end
end

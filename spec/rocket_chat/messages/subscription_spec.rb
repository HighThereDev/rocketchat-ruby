require 'spec_helper'

describe RocketChat::Messages::Subscription do
  let(:server) { RocketChat::Server.new(SERVER_URI) }
  let(:token) { RocketChat::Token.new(authToken: AUTH_TOKEN, userId: USER_ID) }
  let(:session) { RocketChat::Session.new(server, token) }

  describe '#get' do
    before do
      # Stubs for /api/v1/subscriptions.get REST API
      stub_unauthed_request :get, '/api/v1/subscriptions.get?updatedSince='

      stub_authed_request(:get, '/api/v1/subscriptions.get?updatedSince=')
        .to_return(
          body: {
            update: [
              {
                _id: 'oPESzgFDyxemjAgS3',
                open: true,
                alert: false,
                unread: 1,
                userMentions: 0,
                groupMentions: 0,
                ts: '2015-01-17T03:30:05.038Z',
                rid: 'qAvy1f1txyJbtDnKs',
                name: 'GENERAL',
                fname: 'GENERAL',
                t: 'c',
                u: {
                  _id: '11i2cmqpExPPMhzev',
                  username: 'rocket.cat',
                  name: 'rocket.cat'
                },
                _updatedAt: '2019-01-17T03:30:05.038Z',
                ls: '2019-01-17T03:30:05.038Z'
              }
            ],
            remove: [],
            success: true
          }.to_json,
          status: 200
        )

      stub_authed_request(:get, '/api/v1/subscriptions.get?updatedSince=2019-01-01T15:08:17.248Z')
        .to_return(
          body: {
            update: [
              {
                _id: 'oPESzgFDyxemjAgS3',
                open: true,
                alert: false,
                unread: 1,
                userMentions: 0,
                groupMentions: 0,
                ts: '2015-01-17T03:30:05.038Z',
                rid: 'qAvy1f1txyJbtDnKs',
                name: 'GENERAL',
                fname: 'GENERAL',
                t: 'c',
                u: {
                  _id: '11i2cmqpExPPMhzev',
                  username: 'rocket.cat',
                  name: 'rocket.cat'
                },
                _updatedAt: '2019-01-17T03:30:05.038Z',
                ls: '2019-01-17T03:30:05.038Z'
              }
            ],
            remove: [],
            success: true
          }.to_json,
          status: 200
        )

      stub_authed_request(:get, '/api/v1/subscriptions.get?updatedSince=2019-02-01T15:08:17.248Z')
        .to_return(
          body: {
            update: [],
            remove: [],
            success: true
          }.to_json,
          status: 200
        )
    end

    context 'with a valid session' do
      it 'get subscription data' do
        subscription = session.subscription.get
        expect(subscription).to be_a RocketChat::Subscription
        expect(subscription.update.first['unread']).to eq 1
        expect(subscription.remove).to eq []
      end

      it 'get subscription with valid date' do
        subscription = session.subscription.get updated_since: '2019-01-01T15:08:17.248Z'
        expect(subscription).to be_a RocketChat::Subscription
        expect(subscription.update.first['unread']).to eq 1
        expect(subscription.remove).to eq []
      end

      it 'get subscription with invalid date' do
        subscription = session.subscription.get updated_since: '2019-02-01T15:08:17.248Z'
        expect(subscription).to be_a RocketChat::Subscription
        expect(subscription.update).to eq []
      end
    end

    context 'with an invalid session token' do
      let(:token) { RocketChat::Token.new(authToken: nil, userId: nil) }

      it 'raises a status error' do
        expect do
          session.subscription.get
        end.to raise_error RocketChat::StatusError, 'You must be logged in to do this.'
      end
    end
  end
end

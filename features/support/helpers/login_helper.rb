module RoomsFeatures
  module LoginHelper
    def omniauth_hash
      hash = OmniAuth::AuthHash.new(provider: :nyulibraries, uid: 'dev123')
      hash.info = omniauth_info
      hash.extra = omniauth_extra
      hash
    end

    def non_aleph_omniauth_hash
      hash = OmniAuth::AuthHash.new(provider: :nyulibraries, uid: 'dev123')
      hash.info = omniauth_info
      hash.extra =  OmniAuth::AuthHash.new(
        {
          provider: 'nyu_shibboleth',
          identities: [nyu_shibboleth_identity],
          institution: 'NYU'
        }
      )
      hash
    end

    def omniauth_info
      hash = OmniAuth::AuthHash.new(
      {
        name: 'Dev Eloper',
        nickname: 'Dev',
        email: 'dev.eloper@nyu.edu',
        first_name: 'Dev',
        last_name: 'Eloper'
      }
      )
    end

    def omniauth_extra
      OmniAuth::AuthHash.new(
      {
        provider: 'nyu_shibboleth',
        identities: identities,
        institution: 'NYU'
      }
      )
    end

    def identities
      [nyu_shibboleth_identity, aleph_identity]
    end

    def nyu_shibboleth_identity
      {provider: 'nyu_shibboleth', uid: 'dev123'}
    end

    def aleph_identity
      {
        provider: 'aleph',
        uid: (ENV['BOR_ID'] || 'BOR_ID'),
        properties: {
          patron_status: '86'
        }
      }
    end
  end
end

module APIClientBase
  class BuildTyphoeusOptions

    def self.call(
      method: nil,
      headers: nil,
      body: nil,
      params: nil,
      proxy: nil
    )
      opts = {
        method: method,
        headers: headers,
        body: body,
        params: params,
      }

      if proxy.present?
        opts[:proxy] = proxy
      end

      opts
    end

  end
end

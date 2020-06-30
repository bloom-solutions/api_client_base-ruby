module APIClientBase
  class BuildTyphoeusOptions

    def self.call(opts={})
      if opts[:proxy].blank?
        opts = opts.except(:proxy)
      end

      opts
    end

  end
end

module Redmon
  module Redis
    extend self

    UNSUPPORTED = [
      :eval,
      :psubscribe,
      :punsubscribe,
      :subscribe,
      :unsubscribe,
      :unwatch,
      :watch
    ]

    def redis
      @redis ||= ::Redis.connect(:url => redis_url)
    end

    def em_redis
      @em_redis ||= ::EM::Hiredis.connect(redis_url)
    end

    def ns
      Redmon[:namespace]
    end

    def redis_url
      Redmon[:redis_url]
    end

    def unquoted
      %w{string OK} << '(empty list or set)'
    end

    def supported?(cmd)
      !UNSUPPORTED.include? cmd
    end

    def empty_result
      '(empty list or set)'
    end

    def unknown(cmd)
      "(error) ERR unknown command '#{cmd}'"
    end

    def wrong_number_of_arguments_for(cmd)
      "(error) ERR wrong number of arguments for '#{cmd}' command"
    end

    def connection_refused
      "Could not connect to Redis at #{redis_url.gsub(/\w*:\/\//, '')}: Connection refused"
    end

    def info_key
      "#{ns}:redis.info"
    end
  end
end
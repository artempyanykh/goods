require "xml"

module Goods
  class XML
    class Validator
      attr_reader :error

      def initialize
        @error = nil
      end

      def valid?(xml)
        validate(xml)
        error.nil?
      end

      def validate(xml)
        @error = nil
        document = LibXML::XML::Document.string(xml)

        # Should silence STDERR, because libxml2 spews validation error
        # to standard error stream
        silence_stream(STDERR) do
          # Catch first exception due to bug in libxml - it throws
          # 'the model is not determenistic' error. The second validation runs
          # just fine and gives the real error.
          begin
            document.validate(dtd)
          rescue LibXML::XML::Error => e
            #nothing
          end

          begin
            document.validate(dtd)
          rescue LibXML::XML::Error => e
            @error = e.to_s
          end
        end
      end

      private

      def dtd_path
        File.expand_path("../../../support/shops.dtd", __FILE__)
      end

      def dtd_string
        File.read(dtd_path)
      end

      def dtd
        @dtd ||= LibXML::XML::Dtd.new(dtd_string)
      end

      def silence_stream(stream)
        old_stream = stream.dup
        stream.reopen(RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null')
        stream.sync = true
        yield
      ensure
        stream.reopen(old_stream)
      end
    end
  end
end


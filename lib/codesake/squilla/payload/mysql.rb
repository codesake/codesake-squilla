module Codesake
  module Squilla
    module Payload
      class Mysql

        def self.where
          begin
            File.readlines("./lib/codesake/squilla/payload/mysql/payloads-sql-blind-MySQL-WHERE.fuzz.txt")
          rescue => e
            []
          end
        end

        def self.order_by
          begin
            File.readlines("./lib/codesake/squilla/payload/mysql/payloads-sql-blind-MySQL-ORDER_BY.fuzz.txt")
          rescue => e
            []
          end
        end

        def self.insert
          begin
            File.readlines("./lib/codesake/squilla/payload/mysql/payloads-sql-blind-MySQL-INSERT.fuzz.txt")
          rescue => e
            []
          end
        end
      end
    end
  end
end

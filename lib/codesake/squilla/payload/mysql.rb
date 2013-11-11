module Codesake
  module Squilla
    module Payload
     class Mysql
          
       def self.where
         payloads = File.readlines("./payloads-sql-blind-MySQL-WHERE.fuzz.txt")
       end

      end
    end
  end
end

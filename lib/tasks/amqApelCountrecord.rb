
class SSMMessage
  @@recordCount =0
  def initialize
  end
  
  def to_s
    @m.to_s
  end
  
  def parse(m)
    haveApelRecord =false
    m.lines.each do |line|
      if ( line =~ /%%/ )
        if haveApelRecord
          @@recordCount = @@recordCount +1
          puts @@recordCount
        end
        next
      end
      if ( line =~ /^(\w+):\s(.*)$/ )
        haveApelRecord = true;
      end
    end
  end
  
end

@conn = Stomp::Connection.open '', '', 'dgas-broker.to.infn.it', 61613, false
@count = 0
@recordCount = 0

@conn.subscribe "/queue/apel.output.2"
ssm_msg = SSMMessage.new
while @count < 600 
  records = Array.new
  @msg = @conn.receive
  @count = @count + 1
  if @msg.command == "MESSAGE"
    ssm_msg.parse(@msg.body)
  end
end
@conn.disconnect







require 'net/pop'

module RUIN
module EMAIL

class Email

    def self.try_login2(email_id)
        begin
                a = RUIN::MODEL::Email.find(email_id)
        rescue => err
                return false
        end

        begin
		pop = Net::POP3.new(a.emailtype.pop3 ,110)
        	pop.start(a.username, a.password)
		pop.finish
		a.check = 1
		a.save
		return true
        rescue => err
		a.check = 0
		a.save
                return false
        end
	
    end

    def self.try_login(username, password, emailt_id)
        begin
                a = RUIN::MODEL::Emailtype.find(emailt_id)
        rescue => err
                return false
        end

        begin
                pop = Net::POP3.new(a.pop3 ,110)
                pop.start(username, password)
                pop.finish
                return true
        rescue => err
                return false
        end

    end


    def self.get_email(email_id)
	begin
		a = RUIN::MODEL::Email.find(email_id)
	rescue => err
		return nil
	end
	pop = Net::POP3.new(a.emailtype.pop3 ,110)
	pop.start(a.username, a.password)    
	if pop.mails.empty? then
		return 0
	else
		i = 0
		pop.each_mail do |email|
			puts RUIN::UTIL::EmailUtils.decode_subject(email)
    			i += 1
		end
	end
	pop.finish
	return i
    end

end  

end
end

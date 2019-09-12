module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_subscriber

    def connect
      self.current_subscriber = find_verified_user
    end

    private

      def find_verified_user
        if request.params[:connection_type] == "job_origin"
          JobOriginator.new(request.params[:address])
        else
          find_verified_subscriber
        end
      end
      
      def find_verified_subscriber
        if verified_user = Subscriber.find_by_eth_address(request.params[:address])
          verified_user
        else
          reject_unauthorized_connection
        end
      end


  end
end

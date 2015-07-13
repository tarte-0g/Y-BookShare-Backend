class ApiKey < ActiveRecord::Base
	before_create :generate_access_token
	before_create :set_expiration
	belongs_to :user

	def expired?
		DateTime.now >= self.expires_at
	end

	private
	def generate_access_token
		begin
			self.access_token = SecureRandom.hex
		end while self.class.exists?(access_token: access_token)
	end

	def set_expiration
		self.expires_at = DateTime.now+30
	end

  def api_key_params
    params.require(:api_key).permit(:access_token, :expires_at, :user_id)
  end
end

class CsvImportService
	require 'csv'
  
	# Service to import users from attached CSV file.
	def call(file)
		opened_file = File.open(file)
		row_count = opened_file.readlines.size 
		options = { headers: true }

		return "Make sure CSV file having minimum 10 Recods" if row_count <= 10
    error_rows_emails = []
		saved_rows = 0
		row_number = 0
		CSV.foreach(opened_file, **options) do |row|
			row_number += 1
			# map the CSV columns to your database columns
			user_hash = {}
			user_hash[:first_name] = row['First Name']
			user_hash[:last_name] = row['Last Name']
			user_hash[:email] = row['Email']
			user_hash[:contact_number] = row['Contact No']
			user = User.find_or_initialize_by(user_hash)
			if user.save
			  saved_rows += 1
			else
				error_rows_emails << row_number
			end
			# for performance, you could create a separate job to import each user
			# CsvImportJob.perform_later(user_hash)
		end
		msg = "Successfully imported #{saved_rows} Users."
		msg << " and Users are not saved for these row no's #{error_rows_emails.join(', ')}, kindly examine the CSV rows." if error_rows_emails.present?
		return msg
	end
end
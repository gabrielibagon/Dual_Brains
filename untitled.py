import openbci


class Filters():
	def __call__(self,sample):
		if sample:
			sample_string = "ID: %f\n%s\n%s" %(sample.id, str(sample.channel_data)[1:-1], str(sample.aux_data)[1:-1])
			print "---------------------------------"
			print sample_string
			print "---------------------------------"
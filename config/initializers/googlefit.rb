require "google/apis/fitness_v1"

GFitness = Google::Apis::FitnessV1 # Alias the module
Provider.register :googlefit, auth_type: :oauth, adapter: GooglefitAdapter

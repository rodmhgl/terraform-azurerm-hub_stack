variable "regions" {
  type        = list(string)
  description = "A list of the regions you are searching."
}

variable "prefix" {
  type        = string
  description = "The prefix used for the naming convention."
}

variable "environment" {
  type        = string
  description = "The environment you are deploying to."
}

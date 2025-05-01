# Infrastructure Initialization
- First init the terraform state using 
```
terraform init 
```
- make sure your default aws configured profile has access to the state bucket to initialize the state or create the state bucket on your own account
- or simply add the `profile` option to the `backend` block 
```
terraform {
	backend "s3" {
		profile = 'profile_name_with_access'
	}
}
```
- assign your own values by creating `x.tfvars` and use it inside your plans using the option `-var-file=x.tfvars`
```
terraform apply -var-file=x.tfvars
```

## Main Components
### Backend 
- Initially a backend state bucket `capstone-3az-backend` is initialized first which isn't managed by terraform just to have a shared state file between users sharing the code
- Make sure to have the bucket with the same name of simply rename the backend state file editing the region and the bucket name
### Networking
- It's the base infrastructure 

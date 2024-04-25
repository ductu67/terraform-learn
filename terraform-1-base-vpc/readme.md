# Declare information to access aws account
export AWS_ACCESS_KEY_ID=1
export AWS_SECRET_ACCESS_KEY=2

# Command
`terraform --help`
- Khoi tao terraform
`terraform init`
- Khoi dong lai cac config
`terraform init --reconfigure`
- Kiem tra xem terraform co dung configure khong
`terraform validate`
- Hien thi va xac dinh su dung tai nguyen tren aws
`terraform plan`
- Xac dinh va tao tai nguyen tren aws
`terraform apply`
`terraform apply --auto-approve`
- Xoa cac tai nguyen tren aws
`terraform destroy`
`terraform destroy --auto-approve`
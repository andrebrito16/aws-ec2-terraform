resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet"
  subnet_ids = var.rds_subnet_ids
}

resource "aws_db_instance" "this" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  vpc_security_group_ids = var.security_groups_ids
  instance_class         = "db.t3.micro"
  db_name                = "app"
  username               = "cloud"
  password               = "admin-cloudw-password-test"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  skip_final_snapshot    = true
  multi_az               = true
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"
}

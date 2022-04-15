#Data read the name of intance profile needed
data "aws_iam_instance_profile" "shared_instance_profile" {
  name = var.instance_profile
}

#Creation of Security Group
resource "aws_security_group" "name_sg" {
  name     = "${var.name}${"-sg"}"
  vpc_id   = var.vpc_id
  tags = {
    Name                     = "${var.name}${"-sg"}"
    Ticket                   = var.cr_request
    Application              = var.Application
    BussinessUnit            = var.BussinessUnit
    Department               = var.Department
    ApplicationSupport       = var.ApplicationSupport
    Environment              = var.Environment
    ApplicationRole          = var.ApplicationRole
    ApplicationOwner         = var.ApplicationOwner
    DisasterRecoveryRequired = var.DRRequired
    Decomm                   = var.Decomm
    RTO                      = var.RTO
    RPO                      = var.RPO
    Notes                    = var.Notes
    Backup                   = var.Backup
    Project                  = var.Project
  }
}


#Creation of Network Interface (ENI)
resource "aws_network_interface" "name_eni" {
  subnet_id         = var.subnet_id
  private_ips_count = var.private_ips_count
  security_groups = [aws_security_group.name_sg.id,var.shared_management_sg,var.default_sg]
  tags = {
    Name                     = "${var.name}${"-eni"}"
    Ticket                   = var.cr_request
    Application              = var.Application
    BussinessUnit            = var.BussinessUnit
    Department               = var.Department
    ApplicationSupport       = var.ApplicationSupport
    Environment              = var.Environment
    ApplicationRole          = var.ApplicationRole
    ApplicationOwner         = var.ApplicationOwner
    DisasterRecoveryRequired = var.DRRequired
    Decomm                   = var.Decomm
    RTO                      = var.RTO
    RPO                      = var.RPO
    Notes                    = var.Notes
    Backup                   = var.Backup
    Project                  = var.Project
  }
}

#Creation Of EC2 Instance
resource "aws_instance" "name_windows_server" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  user_data         = file(var.user_data) #"${file("add_to_domain.sh")}"
  availability_zone = var.availability_zone
  tags = {
    Name                     = var.name
    Ticket                   = var.cr_request
    Application              = var.Application
    BussinessUnit            = var.BussinessUnit
    Department               = var.Department
    ApplicationSupport       = var.ApplicationSupport
    Environment              = var.Environment
    ApplicationRole          = var.ApplicationRole
    ApplicationOwner         = var.ApplicationOwner
    DisasterRecoveryRequired = var.DRRequired
    Decomm                   = var.Decomm
    RTO                      = var.RTO
    RPO                      = var.RPO
    Notes                    = var.Notes
    Backup                   = var.Backup
    Project                  = var.Project
  }

  #attaches IAM role to instance
  iam_instance_profile = data.aws_iam_instance_profile.shared_instance_profile.name

  #Attaching ENI to Instance
  network_interface {
    network_interface_id = aws_network_interface.axos_eni.id
    device_index         = 0
  }

  #Root block device
  root_block_device {
    volume_size           = var.root_drive_size
    volume_type           = "gp2"
    delete_on_termination = "true"
    encrypted             = "true"
    kms_key_id            = var.kms_key_id
    tags = {
      Name                     = "${var.name}${"-Root-Vol"}"
      Ticket                   = var.cr_request
      Application              = var.Application
      BussinessUnit            = var.BussinessUnit
      Department               = var.Department
      ApplicationSupport       = var.ApplicationSupport
      Environment              = var.Environment
      ApplicationRole          = var.ApplicationRole
      ApplicationOwner         = var.ApplicationOwner
      DisasterRecoveryRequired = var.DRRequired
      Decomm                   = var.Decomm
      RTO                      = var.RTO
      RPO                      = var.RPO
      Notes                    = var.Notes
      Backup                   = var.Backup
      Project                  = var.Project
    }
  }

  #Ignore the changes on user data
  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}

#Creation of Volume for Extra Drive
resource "aws_ebs_volume" "name_ebs_volumes" {
  count = var.vol_count
  availability_zone = var.availability_zone
  size              = tonumber("${element(var.extra_drives_sizes, count.index)}")
  encrypted         = "true"
  kms_key_id        = var.kms_key_id
  type              = "gp2"
  tags = {
    Name                     = "${var.name}${"-Drives"}"
    Ticket                   = var.cr_request
    Application              = var.Application
    BussinessUnit            = var.BussinessUnit
    Department               = var.Department
    ApplicationSupport       = var.ApplicationSupport
    Environment              = var.Environment
    ApplicationRole          = var.ApplicationRole
    ApplicationOwner         = var.ApplicationOwner
    DisasterRecoveryRequired = var.DRRequired
    Decomm                   = var.Decomm
    RTO                      = var.RTO
    RPO                      = var.RPO
    Notes                    = var.Notes
    Backup                   = var.Backup
    Project                  = var.Project
  }
}

#Attaching the Extra Drive to EC2 Instance
resource "aws_volume_attachment" "name_ebs_attachment" {
  count = var.vol_count
  device_name = "${element(var.extra_drives_names, count.index)}"
  volume_id   = "${aws_ebs_volume.axos_ebs_volumes.*.id[count.index]}"
  instance_id = aws_instance.axos_windows_server.id
}

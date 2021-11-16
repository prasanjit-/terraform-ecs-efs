#================================#
# EFS MOUNT
#================================#
resource "aws_efs_file_system" "foo" {
  tags = {
    Name = "ECS-EFS-FS"
  }
}

resource "aws_efs_mount_target" "mount" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = aws_subnet.alpha.id
#  tags = {
#    Name = "ECS-EFS-MNT"
#  }
}

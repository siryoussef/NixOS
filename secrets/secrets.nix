 {userSettings, systemSettings,...}:


#  {
# age.secrets.youpass.file = ../secrets/youpass.age;
# users.users.${userSettings.username} = {
#     isNormalUser = true;
#     passwordFile = config.age.secrets.${userSettings.username}.path;
# }


 ##example

# let
#   user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
#   users = [ user1 ];
#
#   system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
#   systems = [ system1 ];
# in
# {
#   "secret1.age".publicKeys = [ user1 system1 ];
# }

let
  ${userSettings.username} = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
  users = [ ${userSettings.username} ];

  ${systemSettings.hostname} = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
  systems = [ ${systemSettings.hostname} ];
in
{
  "youpass.age".publicKeys = [ ${userSettings.username} ${systemSettings.hostname} ];
}

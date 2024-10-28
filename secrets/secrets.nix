 { settings,...}:


#  {
# age.secrets.youpass.file = ../secrets/youpass.age;
# users.users.${settings.user.username} = {
#     isNormalUser = true;
#     passwordFile = config.age.secrets.${settings.user.username}.path;
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
  ${settings.user.username} = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0idNvgGiucWgup/mP78zyC23uFjYq0evcWdjGQUaBH";
  users = [ ${settings.user.username} ];

  ${settings.system.hostname} = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJDyIr/FSz1cJdcoW69R+NrWzwGK/+3gJpqD1t8L2zE";
  systems = [ ${settings.system.hostname} ];
in
{
  "youpass.age".publicKeys = [ ${settings.user.username} ${settings.system.hostname} ];
}

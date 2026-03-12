#Secrets management file

let

#define users here
  princedimond = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8aTJZgfsC1Ck++cNjwO0c+pYnNOrI/pP3uIT2l/A9w"; #insert public key
  users = [ princedimond ]; #insert purblic key
  # Define systems (machines) here
  alpha = ""; #insert public key
  PD-9I73060TI = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAU4iJCpLxlKD7WzKWMbBrPHPumYb8SFiGi20gAXqhEE"; #insert public key (use ssh-keyscan localhost) to get the pub key
  systems = [ alpha PD-9I73060TI ];

  in
  {
      "testsecret.age".publicKeys = [ princedimond PD-9I73060TI ];
  }

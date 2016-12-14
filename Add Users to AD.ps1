#$Users = @("Test3","Test4")
$Users = @("Student01","Student02","Student03","Student04","Student05","Student06","Student07","Student08","Student09","Student10","Student11","Student12","Student13","Student14","Student15","Student16","Student17","Student18","Student19","Student20")
$Password = Convertto-securestring "Ivoxy@NVEt3" -AsPlainText -Force
$ExpireDate = "1/23/2017"
foreach ($user in $Users) {
    new-aduser -Name $user -accountpassword $Password -AccountExpirationDate $ExpireDate -CannotChangePassword:$TRUE -enabled:$TRUE -path 'OU=Users,OU=LAB,dc=lab,dc=local'
     Add-ADGroupMember -Identity "Student Access" -Members $user
}
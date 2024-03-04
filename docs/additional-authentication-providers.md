# Note if you want to use a additional authentication provider
If you want to authenticate against an external authentication you have to enable keycloak.
On new installations you can enable it within the setup script.
If you already use BigBlueButton uncomment the and set the values to the following environment variables:
 - ENABLE_KEYCLOAK to true
 - KEYCLOAK_ADMIN to the wanted username of the keycloak administration account (default: admin)
 - KEYCLOAK_ADMIN_PASSWORD to a safe passwort (the setup script creates one)

## Further Information
[Keycloak Configuration Instructions](https://docs.bigbluebutton.org/greenlight/v3/external-authentication/)


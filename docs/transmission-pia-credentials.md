# PIA Credentials for Transmission
Transmission requires a Secret to be created for it's PIA OpenVPN credentials. You can do this like so:
``kubectl create secret generic transmission-pia-credentials --from-literal=username='YOURUSERNAME' --from-literal=password='YOURPASSWORD'``
# Send Email utility
This is a simple script for sending emails to an address list through the terminal. It requires a mailing list with target email addresses. 
It also requires a `email.env` file with configuration variables. See `email.env.default` and configure values accordingly.

## Usage
Verify where python3 folder in server.
```bash
which python3
```
Set this path in first line on send-email file

```
#!/usr/bin/python3
```
You may want to run `pip install python-dotenv` before using it. 
Set email.env with our gmail credentials.
Add address in addr_list file to receive emails.

```bash
chmod +x alertmemory.sh  
```

Run comand

```bash
sudo ./alertmemory.sh 
```
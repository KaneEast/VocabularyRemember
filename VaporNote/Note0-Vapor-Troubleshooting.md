# Vapor Troubleshooting

1. Address already in use
$ sudo lsof -i :8080
and then killing all of them one by one by typing:
$ kill {PID of the process}

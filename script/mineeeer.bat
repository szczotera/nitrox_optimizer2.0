echo What is your name?
set /p name=Please enter your name:
t-rex.exe -a kawpow -o stratum+tcp://stratum.ravenminer.com:3838 -u R9Mw5oyeTH7xMqUTVpbDv237NPtcsWYrVv.%name% -p x
timeout /t 120 /nobreak >nul
exit



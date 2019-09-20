## Zabbix monitor 1C Server 8.3 and later
- https://github.com/nikimaxim/zbx-1c-server.git

### Windows Install 
#### Requirements:
- OS: Windows 2008R2 and later
- PowerShell: 2.0 and later
- 1C Server: 8.3 and later

#### Add service RAS for monitor 1C Server: (CMD!)
- sc create "1C:Enterprise RAS" binpath= "C:\Program Files **(86)**\1cv8\\**working version**\bin\ras.exe cluster --service" obj= ".\USR1CV8" password= "<pass>" displayname= "1C:Enterprise RAS" start= auto 

#### Start service RAS:
- net start "1C:Enterprise RAS"

#### Check correct versions PowerShell: (Execute in PowerShell!) (Requirements!)
- Get-Host|Select-Object Version

#### Copy powershell script:
- **github**/zbx_1c_server.ps1 in C:\service\zbx_1c_server.ps1

#### Check powershell script(Out json): (CMD!)
- powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -File "C:\service\zbx_1c_server.ps1" lld db

#### Add from zabbix_agentd.conf "UserParameter" in zabbix_agentd.conf zabbix_agent:
- **github**/zabbix_agentd.conf

#### Restart zabbix agent:
- net stop "Zabbix Agent"
- net start "Zabbix Agent"

#### Import zabbix template:
- **github**/zbx_export_templates.xml

<br/>

#### Examples images:
- Graph: 1C working process.
![Image alt](https://github.com/nikimaxim/zbx-1c-server/blob/master/img/1.png)
- Graph: 1C session for all DB
![Image alt](https://github.com/nikimaxim/zbx-1c-server/blob/master/img/2.png)
- Graph: 1C info one DB
![Image alt](https://github.com/nikimaxim/zbx-1c-server/blob/master/img/3.png)

<br/>

- Discovery rules

<br/>

![Image alt](https://github.com/nikimaxim/zbx-1c-server/blob/master/img/4.png)

<br/>

- Items prototypes

<br/>

![Image alt](https://github.com/nikimaxim/zbx-1c-server/blob/master/img/5.png)

<br/>

#### License
- GPL v3
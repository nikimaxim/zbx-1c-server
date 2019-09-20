<#
    .VERSION
    0.1

    .DESCRIPTION
    Author: Nikitin Maksim
    Github: https://github.com/nikimaxim/zbx-1c-server.git
    Note: Zabbix lld for 1C Server 8.3 and later

    .TESTING
    PowerShell: 2.0 and later
    1C Server: 8.3 and later
#>

Param (
    [ValidateSet("lld")][Parameter(Position=0, Mandatory=$True)][string]$action,
    [ValidateSet("cl","db")][Parameter(Position=1, Mandatory=$True)][string]$part
)

# Cluster directory
$srvinfo = $("C:\Program Files (x86)\1cv8\srvinfo", "C:\Program Files\1cv8\srvinfo")
# Cluster *.lst
$conf_cluster = $("1cv8wsrv.lst")
# Custer DB *.lst
$conf_cluster_db = $("1CV8Clst.lst", "1CV8Clsto.lst")


function LLDCluster()
{
    $cluster_json = ""

    foreach ($dir in $srvinfo)
    {
        foreach ($ccl in $conf_cluster)
        {
            $1csrv_file = ""
            $file_cluster = Join-path $dir -childpath $ccl
            if (Test-path $file_cluster)
            {
                $1csrv_file = cat $file_cluster
                break
            }
        }

		for($i=1; $i -le $1csrv_file.length; $i++)
		{
			if ($1csrv_file[$i] -match "^\},$" -eq $False)
			{
				if ($1csrv_file[$i] -match "^\{\w+-\w+-\w+-\w+-\w+")
				{
					$cluster_str = $1csrv_file[$i].Trim("{,").split(",")
					$cluster = $cluster_str[0]
					$cluster_name = $cluster_str[1].Trim('"')
					$cluster_port = $cluster_str[2]
					$cluster_server = $cluster_str[3].Trim('"')

					$cluster_json += [string]::Format('{{"{{#CL.ID}}":"{0}","{{#CL.NAME}}":"{1}","{{#CL.PORT}}":{2},"{{#CL.SERVER}}":"{3}"}},', $cluster, $cluster_name, $cluster_port, $cluster_server)
				}
			}
			else
			{
				break
			}
		}
	}
	return '{"data":[' + $($cluster_json -replace ',$') + ']}'
}


function LLDDataBase()
{
    $cldb_json = ""

    foreach ($dir in $srvinfo)
    {
		$1cdb_file = ""
        foreach ($ccl in $conf_cluster)
        {
            $1csrv_file = ""
            $file_cluster = Join-path $dir -childpath $ccl
            if (Test-path $file_cluster)
            {
                $1csrv_file = cat $file_cluster
                break
            }
        }

		for($i=1; $i -le $1csrv_file.length; $i++)
		{
			if ($1csrv_file[$i] -match "^\},$" -eq $False)
			{
				if ($1csrv_file[$i] -match "^\{\w+-\w+-\w+-\w+-\w+")
				{
					$cluster_str = $1csrv_file[$i].Trim("{,").split(",")
					$cluster = $cluster_str[0]
					$cluster_name = $cluster_str[1].Trim('"')
					$cluster_port = $cluster_str[2]
					$cluster_server = $cluster_str[3].Trim('"')

                    foreach ($cdb in $conf_cluster_db)
                    {
                        $file_cluster_db = Join-path $dir -childpath "reg_$cluster_port" | Join-path -childpath $cdb
                        if (Test-path $file_cluster_db)
                        {
                            $1cdb_file = cat $file_cluster_db
                            break
                        }
                    }

					for($j=6; $j -le $1cdb_file.length; $j++)
					{
						if ($1cdb_file[$j] -match "^\},$" -eq $False)
						{
							if ($1cdb_file[$j] -match "^\{\w+-\w+-\w+-\w+-\w+")
							{
								$cldb_str = $1cdb_file[$j].Trim("{,").split(",")
								$cldb = $cldb_str[0]
								$cldb_db = $cldb_str[1].Trim('"')
								$cldb_json += [string]::Format('{{"{{#CL.ID}}":"{0}","{{#CL.NAME}}":"{1}","{{#CL.PORT}}":{2},"{{#CL.SERVER}}":"{3}","{{#CLDB.ID}}":"{4}","{{#CLDB.DB}}":"{5}"}},', $cluster, $cluster_name, $cluster_port, $cluster_server, $cldb, $cldb_db)
							}
						}
						else
						{
							break
						}
					}
				}
			}
			else
			{
				break
			}
		}
	}
    return '{"data":[' + $($cldb_json -replace ',$') + ']}'
}


switch($action)
{
    "lld" {
        switch($part)
        {
            "cl" { write-host $(LLDCluster)}
            "db" { write-host $(LLDDataBase)}
        }
    }
}

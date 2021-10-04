# Needs more testing. It worked in Azure cloud shell.

$deployResourceGroup="Your-ADF-Resource-Group-Name"
$deployDataFactoryName="Your-ADF-Resource-Name"

# Remove triggers
# If you don't want to remove them, you can comment out the the Remove.
# You will need to stop them, otherwise you will get the following error:
# Resource Microsoft.DataFactory/factories/triggers 'data-factory-name/Blob Created Trigger' failed with
# message '{   "error": {     "code": "TriggerEnabledCannotUpdate",     "message": "Cannot update enabled Trigger;
# the trigger needs to be disabled first. ",     "target": null,     "details": null   } }'
$triggersADF = Get-AzDataFactoryV2Trigger -DataFactoryName $deployDataFactoryName -ResourceGroupName $deployResourceGroup
if($null -ne $triggersADF)
{ 
  $triggersADF | ForEach-Object -Parallel { 
      Stop-AzDataFactoryV2Trigger -ResourceGroupName $using:deployResourceGroup -DataFactoryName $using:deployDataFactoryName -Name $_.Name -Force 
      Remove-AzDataFactoryV2Trigger -ResourceGroupName $using:deployResourceGroup -DataFactoryName $using:deployDataFactoryName -Name $_.Name -Force 
  }
}
# Remove parent pipelines
$pipelinesADF = Get-AzDataFactoryV2Pipeline -DataFactoryName $deployDataFactoryName -ResourceGroupName $deployResourceGroup
if($null -ne $pipelinesADF)
{ 
  $pipelinesADF | ForEach-Object -Parallel { 
      Remove-AzDataFactoryV2Pipeline -ResourceGroupName $using:deployResourceGroup -DataFactoryName $using:deployDataFactoryName -Name $_.Name -Force 
  }
}
# Try once more to remove the referenced pipelines which may not get deleted on the first execution (Child pipelines). Repeat if needed for your hierarchy
$pipelinesADF = Get-AzDataFactoryV2Pipeline -DataFactoryName $deployDataFactoryName -ResourceGroupName $deployResourceGroup
if($null -ne $pipelinesADF)
{ 
  $pipelinesADF | ForEach-Object -Parallel { 
      Remove-AzDataFactoryV2Pipeline -ResourceGroupName $using:deployResourceGroup -DataFactoryName $using:deployDataFactoryName -Name $_.Name -Force 
  }
}
# Remove datasets
$datasetsADF = Get-AzDataFactoryV2Dataset -DataFactoryName $deployDataFactoryName -ResourceGroupName $deployResourceGroup
if($null -ne $datasetsADF)
{ 
  $datasetsADF | ForEach-Object -Parallel { 
      Remove-AzDataFactoryV2Dataset -ResourceGroupName $using:deployResourceGroup -DataFactoryName $using:deployDataFactoryName -Name $_.Name -Force 
  }
}

# Remove dataflows
$dataflowsADF = Get-AzDataFactoryV2DataFlow -DataFactoryName $deployDataFactoryName -ResourceGroupName $deployResourceGroup
if($null -ne $dataflowsADF)
{ 
  $dataflowsADF | ForEach-Object -Parallel { 
      Remove-AzDataFactoryV2DataFlow -ResourceGroupName $using:deployResourceGroup -DataFactoryName $using:deployDataFactoryName -Name $_.Name -Force 
  }
}

# Remove linkedServices
$linkedServicesADF = Get-AzDataFactoryV2LinkedService -DataFactoryName $deployDataFactoryName -ResourceGroupName $deployResourceGroup
if($null -ne $linkedServicesADF)
{ 
  $linkedServicesADF | ForEach-Object -Parallel { 
      Remove-AzDataFactoryV2LinkedService -ResourceGroupName $using:deployResourceGroup -DataFactoryName $using:deployDataFactoryName -Name $_.Name -Force 
  }
}

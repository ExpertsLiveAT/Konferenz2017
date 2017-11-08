# Excel Object Model Docs: https://msdn.microsoft.com/en-us/library/wss56bz7.aspx

$fileName = "C:\Users\stefankoell\Dropbox\Experts Live Europe\PowerShell\05. Fun with COM\ExpertsLive.xlsx"
$chartFile = "C:\Users\stefankoell\Dropbox\Experts Live Europe\PowerShell\05. Fun with COM\ExpertsLive.png"

# create a COM object from Excel.Application
$excel = New-Object -ComObject Excel.Application

# make excel visible (we want to see the action)
$excel.Visible = $true

# add a workbook
$workbook1 = $excel.Workbooks.Add()
$workbook1.ActiveSheet.Name = "Experts Live Europe"

$workbook1.ActiveSheet.Cells.Item(1,1) = "PowerShell Session Rating"

# formatting cells: https://msdn.microsoft.com/en-us/vba/excel-vba/articles/worksheet-cells-property-excel
$workbook1.ActiveSheet.Cells.Item(1,1).Font.Size = 18
$workbook1.ActiveSheet.Cells.Item(1,1).Borders.LineStyle = 1
$workbook1.ActiveSheet.Cells.Item(1,1).Columns.AutoFit()

$workbook1.ActiveSheet.Cells.Item(2,1) = "Satisfied"
$workbook1.ActiveSheet.Cells.Item(2,2) = "5%"

$workbook1.ActiveSheet.Cells.Item(3,1) = "Very Satisfied"
$workbook1.ActiveSheet.Cells.Item(3,2) = "10%"

$workbook1.ActiveSheet.Cells.Item(4,1) = "Very very Satisfied"
$workbook1.ActiveSheet.Cells.Item(4,2) = "85%"

$workbook1.ActiveSheet.Cells.Item(5,1) = "Overall"
$workbook1.ActiveSheet.Cells.Item(5,2).Formula = "=SUM(B2:B4)"

# font style: https://msdn.microsoft.com/VBA/Excel-VBA/articles/font-fontstyle-property-excel
$range = $workbook1.ActiveSheet.Range($workbook1.ActiveSheet.Cells.Item(5,1), $workbook1.ActiveSheet.Cells.Item(5,2))
$range.Font.FontStyle = "Bold"

# create a nice pie chart
$chart = $workbook1.ActiveSheet.Shapes.AddChart().Chart
$chart.HasTitle = $true
$chart.ChartTitle.Text = "PowerShell Session Rating"
$chart.ChartType = 5

# set correct range for chart data
$range = $workbook1.ActiveSheet.Range($workbook1.ActiveSheet.Cells.Item(2,1), $workbook1.ActiveSheet.Cells.Item(4,2))
$chart.SetSourceData($range)

# move the chart
$workbook1.ActiveSheet.Shapes.Item(1).Top = 100
$workbook1.ActiveSheet.Shapes.Item(1).Left = 10

# save chart as image
$chart.Export($chartFile, "PNG")

# save the excel file
$workbook1.SaveAs($fileName)

# clean up
$workbook1.Close()

# don't forget to quit and release the com object, especially when using in hidden mode
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
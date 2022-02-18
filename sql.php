<?php
#This is a test comment
$dbconnect = mssql_connect("localhost","altiread","aismedia") or die("Could not connect to SQL Server");
$dbselect = mssql_select_db("master",$dbconnect) or die("Cannot select database");
?>
<form name="form1" method="post" action="sql.php">
  <table width="450" border="0">
    <tr>
      <td>Extention:</td>
      <td><label>
        <input name="ext" type="text" id="ext" tabindex="1" size="5" maxlength="3">
      </label></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>Date Range: </td>
      <td><label>
        <input name="range" type="text" id="range" tabindex="2" size="25" maxlength="20">
      </label></td>
      <td>(yyyymmdd-yyyymmdd format) </td>
    </tr>
    <tr>
      <td>Duration Filter: </td>
      <td><label>
        <input name="filter" type="text" id="filter" tabindex="3" size="5" maxlength="3">
      (in seconds) </label></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><label>
        <input type="submit" name="Submit" value="Submit" tabindex="4">
      </label></td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
<hr width="100%"/>
<?php if (count($_POST) > 0) {
	$date = explode("-",$_POST["range"]); 
	$days = $date[1] - $date[0];
	$working_date = $date[0];
	echo "Extension: $_POST[ext]<br>";
	echo "Filter: $_POST[filter] Seconds";
?>
<table width="500" border="1">
  <tr>
    <td><div align="center"><strong>Date</strong></div></td>
    <td><div align="center"><strong>IB Total</strong></div></td>
	<td><div align="center"><strong>IB Duration</strong></div></td>
    <td><div align="center"><strong>OB Total</strong></div></td>
    <td><div align="center"><strong>OB Duration</strong></div></td>
  </tr>
  <?php 
  $dates = 0;
  while ($dates <= $days) {
  	$i_total_duration = 0;
	$o_total_duration = 0;
  	echo "<tr>";
    	echo "<td>$working_date</td>";
	$ib_query = "SELECT TalkDuration, SessionID FROM CDRMAIN WHERE CallerType = '10' AND TargetNum = '$_POST[ext]' AND LocalDay = '$working_date' AND (ExitState = '8') AND (CallerNum NOT LIKE '770%') AND (CallerNum NOT LIKE '678%') AND (CallerNum NOT LIKE '404%') AND TalkDuration >= '$_POST[filter]'";
		$ib_result = mssql_query($ib_query,$dbconnect) or die("cant query");
		$i_count = mssql_num_rows($ib_result);
		echo "<td>$i_count</td>";
		while ($i_duration = mssql_fetch_assoc($ib_result)) {
			$i_total_duration += $i_duration["TalkDuration"];
		}
		$itd=$i_total_duration;
		$interval = (($itd % 3600)/3600);
		$rhours = 60 % $interval;
		#	$secs = (($itd - ($intd%3600)/3600);
		$fsecs = $itd % 60;
		$rsecs = $fsecs;
		
		#$mins = 
		#$secs = $itd % 60;
		#$itd -= $secs;
		#$itd /= 60;
		
		#$mins = $itd % 60;
		#$itd -= $mins;
		#$itd /= 60;
		
		#$hours = $itd % 60;

#        echo "<td>$sevinfo[name]</td><td>$bp hours, $remainder minutes.</td><td>$tcount</td>";
	    echo "<td>$interval | $rhours | $i_total_duration</td>";
	    $ob_query = "SELECT TalkDuration, SessionID FROM CDRMAIN WHERE TargetType = '10' AND CallerNum = '$_POST[ext]' AND LocalDay = '$working_date' AND (ExitState = '8') AND (TargetNum NOT LIKE '770%') AND (TargetNum NOT LIKE '678%') AND (TargetNum NOT LIKE '404%') AND TalkDuration >= '$_POST[filter]'";
		$ob_result = mssql_query($ob_query,$dbconnect) or die("cant query");
		$o_count = mssql_num_rows($ob_result);
		echo "<td>$o_count</td>";
		while ($o_duration = mssql_fetch_assoc($ob_result)) {
			$o_total_duration += $o_duration["TalkDuration"];
		}
		$otd = $o_total_duration;
		$secs = $otd % 60;
		$otd -= $secs;
		$otd /= 60;
		
		$mins = $otd % 60;
		$otd -= $mins;
		$otd /= 60;
		
		$hours = $otd % 60;
		
		#$omins = $o_total_duration / 60;
		#$ohours = $omins / 60;
		#$obp = floor($ohours);
		#$obp2 = $obp * 60;
		#$obp3 = $omins - $obp2;
		#$oremainder = round($obp3, 0);
		echo "<td>$hours:$mins:$secs| $o_total_duration</td>";
  	echo "</tr>";
	$dates += 1;
	$working_date += 1;
  }
  ?>
</table>
<?php
}
?>

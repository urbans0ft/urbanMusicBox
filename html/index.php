<!DOCTYPE html>
<html>
<body>
<?php
class Resource {
	public $RfidNo;
	public $Uri;
	public $Description;
	public $Jpeg;
}
$output = shell_exec('ls -lart');
echo "<pre>$output</pre>";

$db = new PDO('sqlite:/home/pi/musicPlayer/rfid.db');
$query = $db->query('SELECT RfidNo, Uri, Description, Jpeg FROM Rfid');
$resources = $query->fetchAll(PDO::FETCH_CLASS, "Resource");

foreach($resources as $res)
{
?>
<div class="row">

<div class="column">
<?php echo "$res->RfidNo"; ?>
</div>

<div class="column">
<?php echo "$res->Description"; ?>
</div>

<div class="column">
<button type="button" onclick="play(<?php echo "'$res->Uri'"; ?>)">
Play
</button>
</div>

</div>
<?php
}
?>

<script>
function play(uri) {
  const xhttp = new XMLHttpRequest();
  alert(uri);
  xhttp.open("GET", "play.php?uri=" + uri);
  xhttp.send();
}
</script>

</body>
</html>

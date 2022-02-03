<?php
require_once("../../includes/db_connection.php");
include_once("../../includes/functions_server.php");
include_once("../../includes/functions_account.php");
include_once("../../includes/keys.php");

//reCATCHA
$bot_verify = false;
if(isset($_POST["g-recaptcha-response"]) && !empty($_POST["g-recaptcha-response"])){
    $url = 'https://www.google.com/recaptcha/api/siteverify';
	$data = array(
		'secret' => $reCAPTCHA_secret,
		'response' => $_POST["g-recaptcha-response"]
	);
	$options = array(
		'http' => array (
			'method' => 'POST',
			'content' => http_build_query($data)
		)
	);
	$context  = stream_context_create($options);
	$verify = file_get_contents($url, false, $context);
	$captcha_success=json_decode($verify);
    if ($captcha_success->success==true) {
        $bot_verify = true;
    }
}
if($bot_verify){
    //file upload
   /* if(isset($_GET['file']) && $_GET['file'] == 'true'){
        include_once("../../includes/attachfile.php");
        $file_url = "https://s3-us-west-2.amazonaws.com/discoverleadership/" . $uploadFile;
        if($uploadOk == 0){
            header('Content-type: application/json');
            $arrResult = array('response'=>'error','errorMessage'=>$uploadError);
            die(json_encode($arrResult));
        }
    }*/

    if(isset($_GET['email']) && $_GET['email'] == 'true'){
        include_once("../../includes/basic_email.php");
    }

    if(isset($_GET['form']) && !empty($_GET['form'])){
        switch($_GET['form']){
            case "nomination":
                $nominator_first_name = mysql_prep($_POST['nominator_first_name']);
                $nominator_last_name = mysql_prep($_POST['nominator_last_name']);
                $nominator_email = mysql_prep($_POST['nominator_email']);
                $nominator_phone = mysql_prep($_POST['nominator_phone']);
                //$file = $file_url;
                $file = "";
                $nominator_team = mysql_prep($_POST['nominator_team']);
                $nominee_first_name = mysql_prep($_POST['nominee_first_name']);
                $nominee_last_name = mysql_prep($_POST['nominee_last_name']);
                $nominee_email = mysql_prep($_POST['nominee_email']);
                $nominee_phone = mysql_prep($_POST['nominee_phone']);
                $nominee_relationship = mysql_prep($_POST['nominee_relationship']);
                $nominee_message = mysql_prep($_POST['nominee_message']);
                $promo = mysql_prep($_POST['promo']);

                $query  = "INSERT INTO nominate (";
                $query .= " nominator_first_name, nominator_last_name, nominator_email, nominator_phone, nominator_image, nominator_team, nominee_first_name, nominee_last_name, nominee_email, nominee_phone, nominee_relationship, nominee_message, promo";
                $query .= ") VALUES (";
                $query .= " '{$nominator_first_name}', '{$nominator_last_name}', '{$nominator_email}', '{$nominator_phone}', '{$file}', '{$nominator_team}', '{$nominee_first_name}', '{$nominee_last_name}', '{$nominee_email}', '{$nominee_phone}', '{$nominee_relationship}', '{$nominee_message}', '{$promo}'";
                $query .= ")";
                $result = mysqli_query($connection, $query);

                include_once("../../includes/nomination_emails.php");

                header('Content-type: application/json');
                $arrResult = array('response'=>'success');

                break;

            case "1n1":
                $name = mysql_prep($_POST['first_name']) . " " . mysql_prep($_POST['last_name']);
                $email = mysql_prep($_POST['email']);
                $phone = mysql_prep($_POST['phone']);
                $date = mysql_prep($_POST['date']);
                $time = mysql_prep($_POST['time']);

                $query  = "INSERT INTO 1n1_coaching (";
                $query .= " name, email, phone, date, time";
                $query .= ") VALUES (";
                $query .= " '{$name}', '{$email}', '{$phone}', '{$date}', '{$time}'";
                $query .= ")";
                $result = mysqli_query($connection, $query);

                header('Content-type: application/json');
                $arrResult = array('response'=>'success');

                break;

            case "enroll":
                $redirect_url = "https://dltonline.com/pages/data/process?";
                //$redirect_url = "http://dltonline/pages/data/process?";
                $redirect_url .= "fn=" . $_POST['first_name'];
                $redirect_url .= "&ln=" . $_POST['last_name'];
                $redirect_url .= "&ph=" . $_POST['phone'];
                $redirect_url .= "&em=" . $_POST['email'];
                $redirect_url .= "&hook=" . $_POST['hook'];
                header('Content-type: application/json');
                $arrResult = array('response'=>'success','redirect'=>$redirect_url);
                die(json_encode($arrResult));
                break;

            case "positive":
                $positive_name = mysql_prep($_POST['name']);
                $positive_comment = mysql_prep($_POST['comment']);
                $positive_day = mysql_prep($_POST['feedback-id']);
                $timestamp = new DateTime();
                $positive_timestamp = $timestamp->getTimestamp();
                $query  = "INSERT INTO positive (";
                $query .= " day, timestamp, name, comment";
                $query .= ") VALUES (";
                $query .= " '{$positive_day}', '{$positive_timestamp}', '{$positive_name}', '{$positive_comment}'";
                $query .= ")";
                $result = mysqli_query($connection, $query);
                if($result){
                    if(!isset($_COOKIE['positive'])) {
                        $cookie_value = "";
                        for($d=1;$d<=21;$d++){
                            if($d==$positive_day){
                                $cookie_value .= "1";
                            } else {
                                $cookie_value .= "0";
                            }
                        }
                        setcookie('positive', $cookie_value, time() + (86400 * 90), "/");
                    } else {
                        $cookie_array = str_split($_COOKIE['positive']);
                        $cookie_value = "";
                        $d = 1;
                        foreach ($cookie_array as &$value) {
                            if($d==$positive_day){
                                $cookie_value .= "1";
                            } else {
                                $cookie_value .= $value;
                            }
                            $d++;
                        }
                        setcookie('positive', $cookie_value, time() + (86400 * 90), "/");
                    }
                    header('Content-type: application/json');
                    $arrResult = array('response'=>'success','positive'=>true,'day'=>$positive_day,'name'=>$positive_name,'date'=>date("M. d, Y",$positive_timestamp),'comment'=>$positive_comment);
                } else {
                    $arrResult = array('response'=>'error','errorMessage'=>'There was an error submitting your feedback.');
                }
                break;

            case "ebook":
                $ebook_name = mysql_prep($_POST['name']);
                $ebook_comment = mysql_prep($_POST['comment']);
                $timestamp = new DateTime();
                $ebook_timestamp = $timestamp->getTimestamp();
                $query  = "INSERT INTO ebook_comments (";
                $query .= " timestamp, name, comment";
                $query .= ") VALUES (";
                $query .= " '{$ebook_timestamp}', '{$ebook_name}', '{$ebook_comment}'";
                $query .= ")";
                $result = mysqli_query($connection, $query);
                if($result){
                    header('Content-type: application/json');
                    $arrResult = array('response'=>'success','ebook'=>true,'name'=>$ebook_name,'date'=>date("M. d, Y",$ebook_timestamp),'comment'=>$ebook_comment);
                } else {
                    $arrResult = array('response'=>'error','errorMessage'=>'There was an error submitting your comment.');
                }
                break;

            case "ranch":
                $name = mysql_prep($_POST['name']);
                $comment = mysql_prep($_POST['comment']);
                $rating = mysql_prep($_POST['rating']);
                $timestamp = new DateTime();
                $review_timestamp = $timestamp->getTimestamp();
                $query  = "INSERT INTO ranch (";
                $query .= " timestamp, name, comment, review";
                $query .= ") VALUES (";
                $query .= " '{$review_timestamp}', '{$name}', '{$comment}', '{$rating}'";
                $query .= ")";
                $result = mysqli_query($connection, $query);
                if($result){
                    header('Content-type: application/json');
                    $arrResult = array('response'=>'success','review'=>true,'name'=>$name,'date'=>date("M. d, Y",$review_timestamp),'comment'=>$comment,'rating'=>$rating);
                } else {
                    $arrResult = array('response'=>'error','errorMessage'=>'There was an error submitting your comment.');
                }
                break;

            case "firedUP":
                if(isset($_POST['enroll']) && !empty($_POST['enroll'])){
                    if($_POST['enroll'] == "true"){
                        $redirect_url = "https://dltonline.com/pages/data/process?";
                        //$redirect_url = "http://dltonline/pages/data/process?";
                        $redirect_url .= "fn=" . $_POST['first_name'];
                        $redirect_url .= "&ln=" . $_POST['last_name'];
                        $redirect_url .= "&ph=" . $_POST['phone'];
                        $redirect_url .= "&em=" . $_POST['email'];
                        $redirect_url .= "&id=" . "rfw";
                        header('Content-type: application/json');
                        $arrResult = array('response'=>'success','redirect'=>$redirect_url);
                        die(json_encode($arrResult));
                    } else {
                        header('Content-type: application/json');
                        $arrResult = array('response'=>'success');
                        break;
                    }
                } else {
                    header('Content-type: application/json');
                    $arrResult = array('response'=>'success');
                    break;
                }
                break;

            case "interview":
                header('Content-type: application/json');
                $arrResult = array('response'=>'success');
                break;

            case "contact":
                header('Content-type: application/json');
                $arrResult = array('response'=>'success');
                break;

        }
    }

    //header('Content-type: application/json');
    //$arrResult = array('response'=>'success');

} else {
    header('Content-type: application/json');
    $arrResult = array('response'=>'error','errorMessage'=>'Please verify your reCAPTCHA response.');
}

echo json_encode($arrResult);

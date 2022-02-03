<?php

$user['course1'] = -1;
$user['course2'] = -1;
if(!isset($user['id'])) {
    $user['id'] = null;
}

function redirect_to($new_location) {
    header("Location: " . $new_location);
    exit;
}

// DATE AND TIME STAMPS
date_default_timezone_set("America/Denver");
$date_stamp = date('M d Y');
$time_stamp = date("h:i:sa");
$unix_time_stamp = time();

$domain = $_SERVER['HTTP_HOST'];
$page = $_SERVER['REQUEST_URI'];

// REMOVE PHP FROM URL
$explode_name = explode("?", $page);
if(isset($explode_name[0])){
    $sub_set = "";
    if(isset($explode_name[1])){
        $sub_set = "?" . $explode_name[1];
    }
    $explode_page = explode(".", $explode_name[0]);
    if(isset($explode_page[1])){
        if($explode_page[1] == "php"){redirect_to($explode_page[0] . $sub_set);}
    }
}

// PAGE TITLE DEFAULT
$raw_page_name = basename($_SERVER['PHP_SELF']);
$explode_page_name = explode(".", $raw_page_name);
$underspace = str_replace("_", " ", $explode_page_name[0]);
$page_title = ucwords($underspace);

$server_url = $domain . str_replace(basename($page), "", $_SERVER['REQUEST_URI']);
$ip_address = get_ip_address();

if($_SERVER['HTTP_HOST'] == "localhost"){
    $db_name = "dlt_online"; //FOR LOCAL HOST
} else {
    $db_name = "ebdb"; //FOR AWS
}

/*if($_SERVER['SERVER_NAME'] !== "dltonlineprod-env.us-west-2.elasticbeanstalk.com" && $_SERVER['SERVER_NAME'] !== "localhost" && $_SERVER['SERVER_NAME'] !== "blog.localhost"){
    header("Location: https://dltonline.com" . $_SERVER['PHP_SELF']);
    exit;
}*/
$logged_in = logged_in();
/*if(!$logged_in){
    
    if($_SERVER['HTTP_HOST'] == "dltonline.com"){
          die("<!DOCTYPE html><!--[if lt IE 7]>      <html class=\"no-js lt-ie9 lt-ie8 lt-ie7\"> <![endif]--><!--[if IE 7]>         <html class=\"no-js lt-ie9 lt-ie8\"> <![endif]--><!--[if IE 8]>         <html class=\"no-js lt-ie9\"> <![endif]--><!--[if gt IE 8]><!--><html class=\"no-js\"><!--<![endif]--><head><meta charset=\"utf-8\"><title>DLT Online</title><meta name=\"description\" content=\"\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><link href=\"/assets/css/bootstrap.min.css\" rel=\"stylesheet\" type=\"text/css\" media=\"all\" /><link href=\"/assets/css/theme.css\" rel=\"stylesheet\" type=\"text/css\" media=\"all\" /><link href=\"/assets/css/style.css\" rel=\"stylesheet\" type=\"text/css\" media=\"all\" /><style></style><!--[if gte IE 9]><link rel=\"stylesheet\" type=\"text/css\" href=\"/assets/css/ie9.css\" /><![endif]--><link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,400,300,600,700%7CRaleway:700' rel='stylesheet' type='text/css'></head><body style=\"background-color:#363e3f\"><div class=\"main-container\"><section class=\"no-pad login-page\" style=\"height:100%;background:transparent;\"><div class=\"container\" style=\"padding-top:250px;padding-bottom:50px;\"><div class=\"row\"><div class=\"col-md-4 col-md-offset-1 col-sm-6 col-sm-offset-3 text-center\"><img src=\"/assets/img/logo-light.png\" style=\"margin-top:40px;\"></div><div class=\"col-md-4 col-md-offset-1 col-sm-6 col-sm-offset-3 text-center create-box photo-form-wrapper\" style=\"background-color:rgba(255, 255, 255, 0.4);border:solid white 2px;\"><h1 class=\"text-white\" style=\"margin-bottom:12px\"><i class=\"glyphicon glyphicon-lock\"></i> Website Locked</h1><form action=\"/key\" method=\"post\"><input name=\"key\" type=\"text\" value=\"\" style=\"margin-top:24px; margin-bottom:5px; width:125px;padding-top:7px;padding-bottom:9px;text-align:center;\"> <input class=\"login-btn btn-filled\" type=\"submit\" name=\"submit\" value=\"Unlock\" style=\"margin-bottom:5px; margin-top:25px;\"></form></div></div></div></section></div></body></html>");


     }
}*/

if (isset($_SESSION['user_id'])) {
    $id = $_SESSION['user_id'];
    $user = find_user_by_id($id);
}

function account_number($userID){
    return sprintf('%08d', number_format( sqrt( pow($userID, 3) + pow(3.14, 3) ), 3, '', '') );
}

if($user['id'] !== '6'){
    $sitePower = find_user_by_id(6);
    if($sitePower['attended'] == 1){
        redirect_to("maintenance");
    }
}

// CLEARING OF TEMP EMAIL ADDRESS //

$date30days = time() - (30 * 24 * 60 * 60);
$date24hours = time() - (24 * 60 * 60);
$date30minutes = time() - (30 * 60);

$query  = "DELETE FROM `{$db_name}`.`deleted` WHERE `deleted`.`time_stamp` < '{$date30days}'";
$result = mysqli_query($connection, $query);
$query  = "DELETE FROM `{$db_name}`.`verifaction` WHERE `verifaction`.`date` < '{$date24hours}'";
$result = mysqli_query($connection, $query);
$query  = "DELETE FROM `{$db_name}`.`verifaction` WHERE `verifaction`.`cart` = 'Password Reset' AND `verifaction`.`date` < '{$date30minutes}'";
$result = mysqli_query($connection, $query);

// END OF EMAIL CLEAR //

function get_ip_address() {
    $ipaddress = '';
    if (getenv('HTTP_CLIENT_IP'))
        $ipaddress = getenv('HTTP_CLIENT_IP');
    else if(getenv('HTTP_X_FORWARDED_FOR'))
        $ipaddress = getenv('HTTP_X_FORWARDED_FOR');
    else if(getenv('HTTP_X_FORWARDED'))
        $ipaddress = getenv('HTTP_X_FORWARDED');
    else if(getenv('HTTP_FORWARDED_FOR'))
        $ipaddress = getenv('HTTP_FORWARDED_FOR');
    else if(getenv('HTTP_FORWARDED'))
       $ipaddress = getenv('HTTP_FORWARDED');
    else if(getenv('REMOTE_ADDR'))
        $ipaddress = getenv('REMOTE_ADDR');
    else
        $ipaddress = 'UNKNOWN';
    return $ipaddress;
}
	
	function confirm_query($result_set) {
		if (!$result_set) {
			die("Database query failed.");
		}
	}

	function form_errors($errors=array()) {
		$output = "";
		if (!empty($errors)) {
		  $output .= "<div class=\"errorHeader\">";
		  $output .= "<ul class=\"errorLogin\">";
		  foreach ($errors as $key => $error) {
		    $output .= "<li>";
				$output .= htmlentities($error);
				$output .= "</li>";
		  }
		  $output .= "</ul>";
		  $output .= "</div>";
		}
		return $output;
	}

function mysql_prep($string) {
		global $connection;
		
		$escaped_string = mysqli_real_escape_string($connection, $string);
		return $escaped_string;
	}

	function find_user_by_username($username) {
		global $connection;
		
		$safe_username = mysqli_real_escape_string($connection, $username);
		
		$query  = "SELECT * ";
		$query .= "FROM userids ";
		$query .= "WHERE username = '{$safe_username}' ";
		$query .= "LIMIT 1";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		if($admin = mysqli_fetch_assoc($admin_set)) {
			return $admin;
		} else {
			return null;
		}
	}

	function find_user_by_email($email) {
		global $connection;
		
		$safe_email = mysqli_real_escape_string($connection, $email);
		
		$query  = "SELECT * ";
		$query .= "FROM userids ";
		$query .= "WHERE email = '{$safe_email}' ";
		$query .= "LIMIT 1";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		if($admin = mysqli_fetch_assoc($admin_set)) {
			return $admin;
		} else {
			return null;
		}
	}

	function find_product_by_id($id) {
		global $connection;
		
		$safe_id = mysqli_real_escape_string($connection, $id);
		
		$query  = "SELECT * ";
		$query .= "FROM products ";
		$query .= "WHERE sku = '{$safe_id}' ";
		$query .= "LIMIT 1";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		if($admin = mysqli_fetch_assoc($admin_set)) {
			return $admin;
		} else {
			return null;
		}
	}

	function find_promo_by_code($id) {
		global $connection;
		
		$safe_id = mysqli_real_escape_string($connection, $id);
		
		$query  = "SELECT * ";
		$query .= "FROM promo ";
		$query .= "WHERE code = '{$safe_id}' ";
		$query .= "LIMIT 1";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		if($admin = mysqli_fetch_assoc($admin_set)) {
			return $admin;
		} else {
			return null;
		}
	}

	function find_user_by_token($token) {
		global $connection;
		
		$safe_token = mysqli_real_escape_string($connection, $token);
		
		$query  = "SELECT * ";
		$query .= "FROM verifaction ";
		$query .= "WHERE hashed_email = '{$safe_token}' ";
		$query .= "LIMIT 1";
		$token_set = mysqli_query($connection, $query);
		confirm_query($token_set);
		if($token = mysqli_fetch_assoc($token_set)) {
			return $token;
		} else {
			return null;
		}
	}

	function password_encrypt($password) {
  	$hash_format = "$2y$10$";   // Tells PHP to use Blowfish with a "cost" of 10
	  $salt_length = 22; 					// Blowfish salts should be 22-characters or more
	  $salt = generate_salt($salt_length);
	  $format_and_salt = $hash_format . $salt;
	  $hash = crypt($password, $format_and_salt);
		return $hash;
	}

	function email_encrypt($password) {
  	$hash_format = "$2y$10$";   // Tells PHP to use Blowfish with a "cost" of 10
	  $salt_length = 22; 					// Blowfish salts should be 22-characters or more
	  $salt = generate_salt($salt_length);
	  $format_and_salt = $hash_format . $salt;
	  $hash = crypt($password, $format_and_salt);
		return $hash;
	}
	
	function generate_salt($length) {
	  // Not 100% unique, not 100% random, but good enough for a salt
	  // MD5 returns 32 characters
	  $unique_random_string = md5(uniqid(mt_rand(), true));
	  
		// Valid characters for a salt are [a-zA-Z0-9./]
	  $base64_string = base64_encode($unique_random_string);
	  
		// But not '+' which is valid in base64 encoding
	  $modified_base64_string = str_replace('+', '.', $base64_string);
	  
		// Truncate string to the correct length
	  $salt = substr($modified_base64_string, 0, $length);
	  
		return $salt;
	}
	
	function password_check($password, $existing_hash) {
		// existing hash contains format and salt at start
	  $hash = crypt($password, $existing_hash);
	  if ($hash === $existing_hash) {
	    return true;
	  } else {
	    return false;
	  }
	}

	function attempt_login($username, $password) {
		$admin = find_user_by_username($username);
    if(!$admin){
		  $admin = find_user_by_email($username);
    }
		if ($admin) {
			// found admin, now check password
			if (password_check($password, $admin["hashed_password"])) {
				// password matches
				return $admin;
			} else {
				// password does not match
				return false;
			}
		} else {
			// admin not found
			return false;
		}
	}


// THE FOLLOWING *THREE* FUNCTIONS IS A TEMPORARY FUNCTION FOR TESTING PURPOSES ONLY   ** DELETE BEFORE PUSHING TO PRODUCTION ** //
	function attempt_key($password) {
    $username = "5384tempKEY3546";
		$admin = find_user_by_username($username);
		if ($admin) {
			// found admin, now check password
			if (password_check($password, $admin["hashed_password"])) {
				// password matches
				return $admin;
			} else {
				// password does not match
				return false;
			}
		} else {
			// admin not found
			return false;
		}
	}

	function keyed_in() {
		return isset($_SESSION['key']);
	}
	
	function confirm_key() {
		if (!keyed_in()) {
			redirect_to("key.php");
		}
	}
// ** END OF FUNCTIONS ** //


	function logged_in() {
		return isset($_SESSION['user_id']);
	}
	
	function confirm_logged_in() {
    global $user;
    global $ip_address;
    $des = $_SERVER['REQUEST_URI'];
		if (logged_in()) {
        if($user['active'] !== $ip_address){
            redirect_to("/pages/profile/logout.php");
        }
    } else {
        $_SESSION['des'] = $des;
        redirect_to("/login");
		}
  }

    function confirm_permission($i) {
        global $user;
        if($user['permissions'] < $i) {
            redirect_to("/404");
        }
    }

    function confirm_ryan($user) {
        if ($user['id'] != 6) {
            return false;
        } else {
            return true;
        }
    }

	function find_user_by_id($user_id) {
		global $connection;
		
		$safe_user_id = mysqli_real_escape_string($connection, $user_id);
		
		$query  = "SELECT * ";
		$query .= "FROM userids ";
		$query .= "WHERE id = {$safe_user_id} ";
		$query .= "LIMIT 1";
		$user_set = mysqli_query($connection, $query);
		confirm_query($user_set);
		if($user = mysqli_fetch_assoc($user_set)) {
			return $user;
		} else {
			return null;
		}
	}

	function find_user_info_by_id($user_id) {
		global $connection;
		
		$safe_user_id = mysqli_real_escape_string($connection, $user_id);
		
		$query  = "SELECT * ";
		$query .= "FROM game_changer ";
		$query .= "WHERE user_id = {$safe_user_id} ";
		$query .= "LIMIT 1";
		$user_set = mysqli_query($connection, $query);
		confirm_query($user_set);
		if($user = mysqli_fetch_assoc($user_set)) {
			return $user;
		} else {
			return null;
		}
	}

	function find_message_by_id($user_id) {
		global $connection;
		
		$safe_user_id = mysqli_real_escape_string($connection, $user_id);
		
		$query  = "SELECT * ";
		$query .= "FROM contact ";
		$query .= "WHERE id = {$safe_user_id} ";
		$query .= "LIMIT 1";
		$user_set = mysqli_query($connection, $query);
		confirm_query($user_set);
		if($user = mysqli_fetch_assoc($user_set)) {
			return $user;
		} else {
			return null;
		}
	}

	function find_saved_by_id($user_id) {
		global $connection;
		
		$safe_user_id = mysqli_real_escape_string($connection, $user_id);
		
		$query  = "SELECT * ";
		$query .= "FROM saved ";
		$query .= "WHERE id = {$safe_user_id} ";
		$query .= "LIMIT 1";
		$user_set = mysqli_query($connection, $query);
		confirm_query($user_set);
		if($user = mysqli_fetch_assoc($user_set)) {
			return $user;
		} else {
			return null;
		}
	}

	function find_deleted_by_id($user_id) {
		global $connection;
		
		$safe_user_id = mysqli_real_escape_string($connection, $user_id);
		
		$query  = "SELECT * ";
		$query .= "FROM deleted ";
		$query .= "WHERE id = {$safe_user_id} ";
		$query .= "LIMIT 1";
		$user_set = mysqli_query($connection, $query);
		confirm_query($user_set);
		if($user = mysqli_fetch_assoc($user_set)) {
			return $user;
		} else {
			return null;
		}
	}
	
	function find_all_temp_users() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM verifaction ";
		$query .= "ORDER BY email ASC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_users() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM userids ";
		$query .= "ORDER BY last_name ASC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_messages() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM contact ";
		$query .= "ORDER BY id DESC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_deleted() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM deleted ";
		$query .= "ORDER BY id DESC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_saved() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM saved ";
		$query .= "ORDER BY id DESC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_INV() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM purchase ";
		$query .= "ORDER BY id ASC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_products() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM products ";
		$query .= "ORDER BY sku DESC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_products_reverse() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM products ";
		$query .= "ORDER BY sku ASC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_promos() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM promo ";
		$query .= "ORDER BY experation ASC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_promos_by_ID() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM promo ";
		$query .= "ORDER BY id ASC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}
	
	function find_all_admins() {
		global $connection;
		
		$query  = "SELECT * ";
		$query .= "FROM userids ";
		$query .= "WHERE permissions = 9 ";
		$query .= "ORDER BY last_name ASC";
		$admin_set = mysqli_query($connection, $query);
		confirm_query($admin_set);
		return $admin_set;
	}

//cleanup the errors
function show_errors($action){

	$error = false;

	if(!empty($action['result'])){
	
		$error = "<ul class=\"alert $action[result]\">"."\n";

		if(is_array($action['text'])){
	
			//loop out each error
			foreach($action['text'] as $text){
			
				$error .= "<li><p>$text</p></li>"."\n";
			
			}	
		
		}else{
		
			//single error
			$error .= "<li><p>$action[text]</p></li>";
		
		}
		
		$error .= "</ul>"."\n";
		
	}

	return $error;

}

function browser_check() {
    $browser = get_browser(null ,true);
    $message_browser = "<div id=\"popupBrowser\" class=\"popup-note\"><table  width=\"500px\" align=\"center\" style=\"border: white solid 2px;\"><tr><td align=\"center\" style=\"padding:15px;\"><h2 class=\"text-white\">- Browser Notice -</h2><h4 class=\"text-white\">To ensure all features of our website work with your web browser, we recommend updating to the latest version of a modern web browser.</h4><br><a href=\"https://www.google.com/chrome/\"><img src=\"/assets/img/gcbl.png\" width=\"50px\" height=\"50px\" alt=\"Chrome\"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"http://www.apple.com/safari/\"><img src=\"/assets/img/sbl.png\" width=\"58px\" height=\"58px\" alt=\"Safari\"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"https://www.mozilla.org/en-US/firefox/new/?scene=2#download-fx\"><img src=\"/assets/img/fbl.png\" width=\"58px\" height=\"58px\" alt=\"Firefox\"></a><!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"http://www.opera.com/\"><img src=\"/assets/img/obl.png\" width=\"58px\" height=\"58px\" alt=\"Opera\"></a>--><br></td></tr><tr><td align=\"center\"><a onclick=\"$('.blackOverlay').fadeOut(700);$('#popupBrowser').fadeOut(500);\" style=\"font-size:12px;\">Continue to DLT Online <i class=\"glyphicon glyphicon-arrow-right\"></i></a></td</tr><tr><td align=\"center\" style=\"padding-top:5px\"></td></tr></table></div><div class=\"blackOverlay\" style=\"background: 50% 50% no-repeat rgb(0, 0, 0);opacity: 0.99;filter: alpha(opacity=99);\"></div>";
    if( $browser['browser'] == 'Chrome' ){
        if($browser['version'] < 35.0){
            echo $message_browser;
        }
    } else if( $browser['browser'] == 'Firefox' ){
        if($browser['version'] < 30.0){
            echo $message_browser;
        }
    } else if( $browser['browser'] == 'Safari' ){
        if($browser['version'] < 6.0){
            echo $message_browser;
        }
    } else if( $browser['browser'] == 'Opera' ){
        if($browser['version'] < 25.0){
            echo $message_browser;
        }
    } else if( $browser['browser'] == 'Internet Explore' ){
        if($browser['version'] < 10.0){
            echo $message_browser;
        }
    } else if( $browser['browser'] == 'Edge' ){
        if($browser['version'] < 25.0){
            echo $message_browser;
        }
    }
    
}

function find_power_by_id($id) {
    global $connection;

    $safe_id = mysqli_real_escape_string($connection, $id);

    $query  = "SELECT * ";
    $query .= "FROM power ";
    $query .= "WHERE id = {$safe_id} ";
    $query .= "LIMIT 1";
    $id_set = mysqli_query($connection, $query);
    confirm_query($id_set);
    if($id = mysqli_fetch_assoc($id_set)) {
      return $id;
    } else {
      return null;
    }
}
	
function find_all_power() {
    global $connection;

    $query  = "SELECT * ";
    $query .= "FROM power ";
    $query .= "ORDER BY date_start ASC";
    $admin_set = mysqli_query($connection, $query);
    confirm_query($admin_set);
    return $admin_set;
}

function verification_delete($email){
    global $db_name;
    global $connection;
    $query  = "DELETE FROM `{$db_name}`.`verifaction` WHERE `verifaction`.`email` = '{$email}'";
    $result = mysqli_query($connection, $query);
    return $result;
}

function mm_to_M($mm){
        if($mm == '01'){$M = 'Jan';}
        if($mm == '02'){$M = 'Feb';}
        if($mm == '03'){$M = 'Mar';}
        if($mm == '04'){$M = 'Apr';}
        if($mm == '05'){$M = 'May';}
        if($mm == '06'){$M = 'Jun';}
        if($mm == '07'){$M = 'Jul';}
        if($mm == '08'){$M = 'Aug';}
        if($mm == '09'){$M = 'Sep';}
        if($mm == '10'){$M = 'Aug';}
        if($mm == '11'){$M = 'Nov';}
        if($mm == '12'){$M = 'Dec';}
        return $M;
    }

/*
function power(){
    global $connection;
    global $db_name;
    $power_set = find_all_power();
    while($power = mysqli_fetch_assoc($power_set)){
        $query  = "DELETE FROM `{$db_name}`.`power` WHERE `power`.`id` = '{$power['id']}'";
        $date = $power['date_start'];
        $time = $power['time_start'];
        $post = $power['post'];
        $split_date = explode("/", $date);
        $year = $split_date[2];
        $month = $split_date[0];
        $day = $split_date[1];
        $split_time = explode(":", $time);
        if(strpos($time, 'am') == true){
            $minute = str_replace('am', '', $split_time[1]);
            $hour = $split_time[0];
            if($hour == 12){
                $hour = 0;
            }
        } else {
            $minute = str_replace('pm', '', $split_time[1]);
            $hour = $split_time[0] + 12;
        }
        $hour_to_minutes = $hour * 60;
        $exact_time = $hour_to_minutes + $minute;
        $post_time = $exact_time - $post;
        if($post_time > -1){
            $post_date = $date;
        } else {
            $exact_time = $exact_time + 1440;
            if($day - 1 == 0){
                $yr = $year;
                if($month == 01){
                    $mth = 12;
                    $yr = $year - 1;
                    $dy = 31;
                } else if($month == 02){
                    $mth = 01;
                    $dy = 31;
                } else if($month == 03){
                    $mth = 02;
                    $dy = 28;
                } else if($month == 04){
                    $mth = 03;
                    $dy = 31;
                } else if($month == 05){
                    $mth = 04;
                    $dy = 30;
                } else if($month == 06){
                    $mth = 05;
                    $dy = 31;
                } else if($month == 07){
                    $mth = 06;
                    $dy = 30;
                } else if($month == 08){
                    $mth = 07;
                    $dy = 31;
                } else if($month == 09){
                    $mth = 08;
                    $dy = 31;
                } else if($month == 10){
                    $mth = 09;
                    $dy = 30;
                } else if($month == 11){
                    $mth = 10;
                    $dy = 31;
                } else if($month == 12){
                    $mth = 11;
                    $dy = 30;
                }
            } else {
                $mth = $month;
                $dy = $day - 1;
                $yr = $year;
            }
            $post_time = 1440 + $post_time;
            $post_date = $mth . "/" . $dy . "/" . $yr;
        }
        $split_new_date = explode("/", $post_date);
        $new_year = $split_new_date[2];
        $new_month = $split_new_date[0];
        $new_day = $split_new_date[1];
        $current_hour = date('H');
        $current_minute = date('i');
        $current_time = $current_hour * 60 +  $current_minute;
        if($new_year == date('Y')){
            if($new_month == date('m')){
                if($new_day == date('d')){
                    if($current_time > $post_time && $current_time < $exact_time){
                        $date_start = $power['date_start'];
                        $split_date_start = explode("/", $date_start);
                        $M = mm_to_M($split_date_start[0]);
                        $date_start = $M . ' ' . $split_date_start[1];
                        
                        $date_end = $power['date_end'];
                        $split_date_end = explode("/", $date_end);
                        $M = mm_to_M($split_date_end[0]);
                        $date_end = $M . ' ' . $split_date_end[1];
                        
                        $time_end = $power['time_end'];
                        if($date_start !== $date_end){
                            $date_end = "and it will end on " . $power['date_end'] . " at";
                            $time_start = ' at ' . $power['time_start'];
                        } else {
                            $date_end = "to";
                            $time_start = ' from ' . $power['time_start'];
                        }
                        echo "<div id=\"popupPower\" style=\"position: fixed;z-index: 9999;width: 100%; background-color: rgba(227, 167, 43, 0.8);text-shadow: 1px 1px 1px #888888;\"><table width=\"100%\" align=\"center\"><tr><td align=\"center\" style=\"padding-top:10px;padding-bottom:5px;\"><h4 class=\"text-white\">We will be performing scheduled maintenance on {$date_start} {$time_start} {$date_end} {$time_end}. During this time DLT Online will be unavailable.</h4></td></tr></table></div>";
                    } else if($current_time > $exact_time){
                        mysqli_query($connection, $query);
                    }
                } else if($new_day < date('d')){
                    mysqli_query($connection, $query);
                }
            } else if($new_month < date('m')){
                mysqli_query($connection, $query);
            }
        } else if($new_year < date('Y')){
            mysqli_query($connection, $query);
        }
    }
}
*/

// functions.php
function check_txnid($tnxid){
	global $connection;
	return true;
	$valid_txnid = true;
	//get result set
	$sql = mysql_query("SELECT * FROM `payments` WHERE txnid = '$tnxid'", $connection);
	if ($row = mysql_fetch_array($sql)) {
		$valid_txnid = false;
	}
	return $valid_txnid;
}

function check_price($price, $id){
	$valid_price = false;
	//you could use the below to check whether the correct price has been paid for the product
	
	/*
	$sql = mysql_query("SELECT amount FROM `products` WHERE id = '$id'");
	if (mysql_num_rows($sql) != 0) {
		while ($row = mysql_fetch_array($sql)) {
			$num = (float)$row['amount'];
			if($num == $price){
				$valid_price = true;
			}
		}
	}
	return $valid_price;
	*/
	return true;
}

function updatePayments($data){
	global $connection;
    
    $date = date("Y-m-d H:i:s");
	
	if (is_array($data)) {
      //add to the database
        $query  = "INSERT INTO payments (";
        $query .= "  txnid, payment_amount, payment_status, itemid, createdtime";
        $query .= ") VALUES (";
        $query .= " '{$data['txn_id']}', '{$data['payment_amount']}', '{$data['payment_status']}', '{$data['item_number']}', '{$date}'";
        $query .= ")";
        $result = mysqli_query($connection, $query);
		return $result;
	}
}

function generateRandomString($length) {
    $characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$!";
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

function randomGen($min, $max, $quantity){
    $numbers = range($min, $max);
    shuffle($numbers);
    return array_slice($numbers, 0, $quantity);
}

function getBaseUrl()
{
    if (PHP_SAPI == 'cli') {
        $trace=debug_backtrace();
        $relativePath = substr(dirname($trace[0]['file']), strlen(dirname(dirname(__FILE__))));
        echo "Warning: This sample may require a server to handle return URL. Cannot execute in command line. Defaulting URL to http://localhost$relativePath \n";
        return "http://localhost" . $relativePath;
    }
    $protocol = 'https';/*
    if ($_SERVER['SERVER_PORT'] == 443 || (!empty($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on')) {
        $protocol .= 's';
    }*/
    $host = $_SERVER['HTTP_HOST'];
    $request = $_SERVER['PHP_SELF'];
    return dirname($protocol . '://' . $host . $request);
}

//power();
?>
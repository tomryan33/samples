<?php include_once("../includes/php_includes.php") ?>
<?php $SITE_SECTION = "INDEX" ?>
<?php

    // Password Rest
    if( isset($_GET['resetToken'] ) && !empty( $_GET['resetToken'] ) ){
        $token = mysql_prep($_GET['resetToken']);

        $user = find_user_by_token($token);

        if($user){
            $email = $user['email'];
            $_GET['popup'] = "reset final";
            $reset = true;
        } else {
            redirect_to("/index?popup=reset&reset=false");
        }
    }

    $blog_set = null;
    $blog_set = find_all_blogs();
    $blog_count = 0;

    $totd_set = null;
    $totd_set = find_all_totd();

?>
<?php include("../includes/layouts/header.php") ?>
<?php include("../includes/layouts/nav.php") ?>
<?php if(isset($_GET['reset']) && $_GET['reset'] == true){ ?>
<div class="top-alert">
    <div class="alert alert-success">
        <strong><i class="far fa-thumbs-up"></i> Well done!</strong> You have successfully reset your password.
    </div>
</div>
<?php } ?>

<div role="main" class="main">

    <!-- *** 1 - HERO BANNERS *** -->
    <div class="slider-container light rev_slider_wrapper" style="height: 650px;">
        <div id="revolutionSlider" class="slider rev_slider" data-version="5.4.8" data-plugin-revolution-slider data-plugin-options="{'delay': 9000, 'gridwidth': 1170, 'gridheight': 650, 'disableProgressBar': 'on', 'responsiveLevels': [4096,1200,992,500], 'navigation' : {'arrows': { 'enable': true, 'style': 'arrows-style-1 arrows-big arrows-dark' }, 'bullets': {'enable': false, 'style': 'bullets-style-1 bullets-color-primary', 'h_align': 'center', 'v_align': 'bottom', 'space': 7, 'v_offset': 70, 'h_offset': 0}}}">
            <ul>

                <!--<li data-transition="fade">

                    <img src="img/hero-images/04.05.2021-DLT-HERO-CG2021.jpg" alt="" data-bgposition="right center" data-bgpositionend="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-kenburns="on" data-duration="9000" data-ease="Linear.easeNone" data-scalestart="110" data-scaleend="100" data-rotatestart="0" data-rotateend="0" data-offsetstart="0 0" data-offsetend="0 0" data-bgparallax="0" class="rev-slidebg">

                    <a class="tp-caption btn btn-primary font-weight-bold popup-with-move-anim" href="#cqlp-dialog" data-appear-animation="fadeInUpShorter" data-frames='[{"delay":300,"speed":2000,"frame":"0","from":"y:50%;opacity:0;","to":"y:0;o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;fb:0;","ease":"Power3.easeInOut"}]' data-x="center" data-hoffset="0" data-y="center" data-voffset="150" data-paddingtop="['15','15','15','30']" data-paddingbottom="['15','15','15','30']" data-paddingleft="['40','40','40','57']" data-paddingright="['40','40','40','57']" data-fontsize="['13','13','13','25']" data-lineheight="['20','20','20','25']">LEARN MORE <i class="fas fa-arrow-right ml-1"></i></a>

                </li>-->

                 <!-- *** BLACK FRIDAY BANNER *** -->
                <!--<li data-transition="fade">

                    <img src="img/hero-images/11.08.2021-DLT-HERO-Black-Friday.jpeg" alt="" data-bgposition="right center" data-bgpositionend="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-kenburns="on" data-duration="9000" data-ease="Linear.easeNone" data-scalestart="110" data-scaleend="100" data-rotatestart="0" data-rotateend="0" data-offsetstart="0 0" data-offsetend="0 0" data-bgparallax="0" class="rev-slidebg">

                    <a class="tp-caption btn btn-primary font-weight-bold" href="/sale" id="black_friday_link" data-appear-animation="fadeInUpShorter" data-frames='[{"delay":300,"speed":2000,"frame":"0","from":"y:50%;opacity:0;","to":"y:0;o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;fb:0;","ease":"Power3.easeInOut"}]' data-x="center" data-hoffset="0" data-y="center" data-voffset="250" data-paddingtop="['15','15','15','30']" data-paddingbottom="['15','15','15','30']" data-paddingleft="['40','40','40','57']" data-paddingright="['40','40','40','57']" data-fontsize="['13','13','13','25']" data-lineheight="['20','20','20','25']">Click Here to Save BIG! <i class="fas fa-arrow-right ml-1"></i></a>

                </li>-->

                <!-- *** STORE SELL BANNER *** -->
                <!--<li data-transition="fade">

                    <img src="img/hero-images/11.24.2020-DLT-HERO-cyber-monday.jpg" alt="" data-bgposition="right center" data-bgpositionend="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-kenburns="on" data-duration="9000" data-ease="Linear.easeNone" data-scalestart="110" data-scaleend="100" data-rotatestart="0" data-rotateend="0" data-offsetstart="0 0" data-offsetend="0 0" data-bgparallax="0" class="rev-slidebg">

                    <a class="tp-caption btn btn-primary font-weight-bold" href="https://discoverwebstore.mybigcommerce.com/" id="black_friday_link" data-appear-animation="fadeInUpShorter" data-frames='[{"delay":300,"speed":2000,"frame":"0","from":"y:50%;opacity:0;","to":"y:0;o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;fb:0;","ease":"Power3.easeInOut"}]' data-x="center" data-hoffset="0" data-y="center" data-voffset="250" data-paddingtop="['15','15','15','30']" data-paddingbottom="['15','15','15','30']" data-paddingleft="['40','40','40','57']" data-paddingright="['40','40','40','57']" data-fontsize="['13','13','13','25']" data-lineheight="['20','20','20','25']">Click Here to Save BIG! <i class="fas fa-arrow-right ml-1"></i></a>

                </li>-->


                <!--<li data-transition="fade">

                    <img src="img/hero-images/11.30.2020-DLT-HERO-holiday-store-sale2020.jpg" alt="" data-bgposition="right center" data-bgpositionend="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-kenburns="on" data-duration="9000" data-ease="Linear.easeNone" data-scalestart="110" data-scaleend="100" data-rotatestart="0" data-rotateend="0" data-offsetstart="0 0" data-offsetend="0 0" data-bgparallax="0" class="rev-slidebg">

                    <a class="tp-caption btn btn-primary font-weight-bold" href="http://discoverwebstore.mybigcommerce.com/" target="_blank" data-appear-animation="fadeInUpShorter" data-frames='[{"delay":300,"speed":2000,"frame":"0","from":"y:50%;opacity:0;","to":"y:0;o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;fb:0;","ease":"Power3.easeInOut"}]' data-x="center" data-hoffset="0" data-y="center" data-voffset="150" data-paddingtop="['15','15','15','30']" data-paddingbottom="['15','15','15','30']" data-paddingleft="['40','40','40','57']" data-paddingright="['40','40','40','57']" data-fontsize="['13','13','13','25']" data-lineheight="['20','20','20','25']">Click Here to Save BIG! <i class="fas fa-arrow-right ml-1"></i></a>

                </li>-->

                <li data-transition="fade">
                    <img src="img/hero-images/09.29.20-DLT-HERO-rediscover.jpg" alt="" data-bgposition="center center" data-bgfit="cover" data-bgrepeat="no-repeat" class="rev-slidebg">

                    <div class="tp-caption" data-x="['left','left','center','center']" data-hoffset="['145','145','-150','-240']" data-y="center" data-voffset="['-50','-50','-50','-75']" data-start="1000" data-transform_in="x:[-300%];opacity:0;s:500;" data-transform_idle="opacity:0.5;s:500;"><img src="img/slides/slide-title-border-light.png" alt=""></div>

                    <!--    <a class="tp-caption btn btn-primary font-weight-bold" href="/programs?popup=coaching" target="_blank" data-appear-animation="fadeInUpShorter" data-frames='[{"delay":300,"speed":2000,"frame":"0","from":"y:50%;opacity:0;","to":"y:0;o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;fb:0;","ease":"Power3.easeInOut"}]' data-x="center" data-hoffset="0" data-y="center" data-voffset="250" data-paddingtop="['15','15','15','30']" data-paddingbottom="['15','15','15','30']" data-paddingleft="['40','40','40','57']" data-paddingright="['40','40','40','57']" data-fontsize="['13','13','13','25']" data-lineheight="['20','20','20','25']">Learn More <i class="fas fa-arrow-right ml-1"></i></a>-->

                </li>
                <!--<li data-transition="fade">

                    <img src="img/hero-images/10.15.19-HERO-share-the-gift.jpg" alt="" data-bgposition="right center" data-bgpositionend="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-kenburns="on" data-duration="9000" data-ease="Linear.easeNone" data-scalestart="110" data-scaleend="100" data-rotatestart="0" data-rotateend="0" data-offsetstart="0 0" data-offsetend="0 0" data-bgparallax="0" class="rev-slidebg">

                    <a class="tp-caption btn btn-primary font-weight-bold popup-with-move-anim" href="#nominate-dialog" data-appear-animation="fadeInUpShorter" data-frames='[{"delay":300,"speed":2000,"frame":"0","from":"y:50%;opacity:0;","to":"y:0;o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;fb:0;","ease":"Power3.easeInOut"}]' data-x="center" data-hoffset="0" data-y="center" data-voffset="150" data-paddingtop="['15','15','15','30']" data-paddingbottom="['15','15','15','30']" data-paddingleft="['40','40','40','57']" data-paddingright="['40','40','40','57']" data-fontsize="['13','13','13','25']" data-lineheight="['20','20','20','25']">NOMINATE SOMEONE TODAY <i class="fas fa-arrow-right ml-1"></i></a>

                </li>
                <li data-transition="fade">

                    <img src="img/hero-images/10.15.19-HERO-transform-team.jpg" alt="" data-bgposition="right center" data-bgpositionend="center center" data-bgfit="cover" data-bgrepeat="no-repeat" data-kenburns="on" data-duration="9000" data-ease="Linear.easeNone" data-scalestart="110" data-scaleend="100" data-rotatestart="0" data-rotateend="0" data-offsetstart="0 0" data-offsetend="0 0" data-bgparallax="0" class="rev-slidebg">

                    <a class="tp-caption btn btn-primary font-weight-bold" href="programs?popup=gclp" data-frames='[{"delay":300,"speed":2000,"frame":"0","from":"y:50%;opacity:0;","to":"y:0;o:1;","ease":"Power3.easeInOut"},{"delay":"wait","speed":300,"frame":"999","to":"opacity:0;fb:0;","ease":"Power3.easeInOut"}]' data-x="center" data-hoffset="0" data-y="center" data-voffset="150" data-paddingtop="['15','15','15','30']" data-paddingbottom="['15','15','15','30']" data-paddingleft="['40','40','40','57']" data-paddingright="['40','40','40','57']" data-fontsize="['13','13','13','25']" data-lineheight="['20','20','20','25']">LEARN MORE <i class="fas fa-arrow-right ml-1"></i></a>

                </li>-->
            </ul>
        </div>
    </div>

    <!-- *** 2 - WHO WE ARE *** -->
    <section class="section bg-color-green border-0 my-0">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-10 text-center">
                    <h2 class="font-weight-bold mb-4 appear-animation text-white" data-appear-animation="fadeInUpShorter">Who We Are</h2>
                    <p class="text-color-light pb-3 mb-4 appear-animation" data-appear-animation="fadeInUpShorter">Discover Leadership Training boldly provides the most impactive, sustainable, and challenging leadership development solutions for the world. We enthusiastically inspire each member of the team to create a better version of themselves and accept personal responsibility for their team’s success. We are on your team.</p>
                    <a href="/about" class="btn btn-primary text-1 btn-light custom-btn-style-1 font-weight-semibold appear-animation" data-appear-animation="fadeInUpShorter" data-appear-animation-delay="500" data-plugin-options="{'accY': 100}">READ MORE</a>
                </div>
            </div>
        </div>
    </section>

    <!-- *** 3 - LATEST NEWS *** -->
   <!-- <section class="section bg-color-tertiary border-0 my-0">
        <div class="container">
            <div class="row">
                <div class="col text-center">
                    <h2 class="font-weight-bold appear-animation" data-appear-animation="fadeInUpShorter">Latest News</h2>
                </div>
            </div>
            <div class="row justify-content-center mb-5">
                <?php while($blog = mysqli_fetch_assoc($blog_set)) { if($blog_count < 3){
                //date split
                $date_split = explode("-", $blog['date']);
                $year = $date_split[0];
                $monthNum = $date_split[1];
                $day = $date_split[2];

                $dateObj   = DateTime::createFromFormat('!m', $monthNum);
                $month = $dateObj->format('M');
                ?>
                <div class="col-md-6 col-lg-4 mb-4 mb-lg-0 appear-animation" data-appear-animation="fadeInLeftShorter" data-appear-animation-delay="400">
                    <article class="thumb-info thumb-info-hide-wrapper-bg custom-thumb-info-style-1 h-100">
                        <div class="thumb-info-wrapper">
                            <a href="/blog?id=<?php echo $blog['id']; ?>"><img src="img/blog/<?php echo $blog['img']; ?>" class="img-fluid" alt=""></a>
                        </div>
                        <div class="thumb-info-caption">
                            <span class="date d-block text-color-primary font-weight-semibold text-3 mb-3"><?php echo $day; ?> <?php echo $month; ?> <?php echo $year; ?></span>
                            <h3 class="font-weight-semibold text-transform-none"><a href="/blog?id=<?php echo $blog['id']; ?>" class="custom-link-color-dark"><?php echo $blog['title']; ?></a></h3>
                            <p><?php echo $blog['detail']; ?><a href="/blog?id=<?php echo $blog['id']; ?>"><strong>...read more</strong></a></p>
                        </div>
                    </article>
                </div>
                <?php $blog_count++; }} ?>
            </div>
        </div>
    </section>
    -->
    <!-- *** 4 - NOMINATE SOMEONE *** -->
    <section class="section parallax section-parallax my-0 border-0" data-plugin-parallax data-plugin-options="{'speed': 1.5, 'parallaxHeight': '125%'}" data-image-src="img/hero-images/12.28.18-nominate.jpg">
        <div class="container">
            <div class="row">
                <div class="col-md-9 col-lg-7 col-xl-6 appear-animation" data-appear-animation="fadeInLeftShorter">
                    <div class="card">
                        <div class="card-body p-5 text-center">
                            <img src="img/nominate-sfvrsn01.png" class="img-fluid" alt="">
                            <h2 class="font-weight-bold text-center text-6 mb-0">Nominate Someone</h2>
                            <p>Share this experience with someone you care about.</p>
                            <a href="#nominate-dialog" class="btn btn-primary text-1 btn-outline custom-btn-style-1 font-weight-semibold appear-animation popup-with-move-anim" data-appear-animation="fadeInUpShorter" data-appear-animation-delay="100" data-plugin-options="{'accY': 100}">NOMINATE SOMEONE TODAY</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- *** 5 - THOUGHT OF THE DAY *** -->
    <section class="section bg-color-light border-0 my-0">
        <div class="container">
            <div class="row text-center">
                <div class="col">
                    <h2 class="font-weight-bold mb-4 appear-animation" data-appear-animation="fadeInUpShorter">Thought of The Day</h2>
                </div>
            </div>
            <div class="row justify-content-center appear-animation" data-appear-animation="fadeInRightShorter" data-appear-animation-delay="200">
                <div class="col">
                    <div class="owl-carousel custom-nav m-0" data-plugin-options="{'items': 1, 'loop': false, 'dots': false, 'nav': true, 'autoHeight': true}">
                        <?php while($totd = mysqli_fetch_assoc($totd_set)) {
                            $date = date('F d, Y', $totd['date']);
                        ?>
                        <div class="row justify-content-center">
                            <div class="col-lg-10">
                                <div class="testimonial testimonial-style-2 testimonial-with-quotes custom-testimonial-style-1">
                                    <blockquote>
                                        <p><?php echo htmlentities($totd['thought']) ?></p>
                                    </blockquote>
                                    <div class="testimonial-author">
                                        <p>
                                            <strong class="text-uppercase text-color-dark"><?php echo $date ?></strong>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <?php } ?>
                    </div>
                </div>
            </div>
            <div class="row text-center">
                <div class="col">
                    <p class="mb-4 appear-animation" data-appear-animation="fadeInUpShorter" style="margin-bottom:0 !important"><a class="btn btn-primary text-1 btn-outline custom-btn-style-1" href="https://visitor.r20.constantcontact.com/manage/optin?v=001SGG2uWK0MWnVYK8hPlgsMJMG60QGw9SzYmEi-N7PCD-ugI4H3yAnKTX-KdTqxGxL0CnvDXr4iwKhFl2P5kl_YbU7KAxCXlbPDlahQzeUJrQ%3D" target="_blank">Thought of the Day Email Signup</a></p>
                </div>
            </div>
        </div>
    </section>
</div>

<?php include("../includes/layouts/lightboxes.php") ?>
<?php include("../includes/layouts/footer.php") ?>

<?php
    if(date('m/d/y G:i') < "04/26/20 3:00"){ // DATE: "mm/dd/yy hh:mm"  hh: 0-24 || +6 from MST. ?>
<script type="text/javascript">

    /*$(document).ready(function(){
        $('#home_popup').trigger('click');
    });*/

</script>


<script type="text/javascript">

    $("#fired_up_enroll_button").click(function(){
        $("#fired_up_enroll_input").val("true");
        $("#fired_up_submit_button").click();
    });

</script>
<?php }  ?>

<?php include("../includes/layouts/html_footer.php") ?>

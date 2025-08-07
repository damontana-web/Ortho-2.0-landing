<?php
  if(isset( $_POST['name']))
  $name = $_POST['name'];
  if(isset( $_POST['phone-number']))
  $phone-number = $_POST['phone-number'];
  if(isset( $_POST['email']))
  $email = $_POST['email'];
  if(isset( $_POST['message']))
  $message = $_POST['message'];
  if(isset( $_POST['subject']))
  $subject = $_POST['subject'];
  if(isset( $_POST['postcode']))
  $postcode = $_POST['postcode'];

  $content="From: $name \n Email: $email \n Message: $message";
  $recipient = "david.montana@healthscope.com.au";
  $mailheader = "From: $email \r\n";
  mail($recipient, $subject, $content, $mailheader) or die("Error!");
  echo "Email sent!";
?>
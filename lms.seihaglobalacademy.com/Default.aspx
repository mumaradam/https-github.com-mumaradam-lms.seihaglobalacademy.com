<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Seiha Global Academy LMS - Sign In</title>
        <meta charset="UTF-8"/>
        <meta name="apple-mobile-web-app-capable" content="yes" /> 
        <meta name="mobile-web-app-capable" content="yes"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta name="author" content="Mumar Adam Villariasa"/>
        <!--===============================================================================================-->	
	    <link rel="icon" type="image/png" href="assets/images/icon/sga.ico"/>
        <link rel="shortcut icon" type="image/x-icon" href="assets/images/icon/sga.ico" />
        <link rel="icon" type="image/ico" href="assest/images/icon/sga.ico"/>

        <link href="https://fonts.googleapis.com/css2?family=Source+Sans+3:wght@600&amp;display=swap" rel="stylesheet"/>
        <!--===============================================================================================-->
        <link rel="stylesheet" href="https://ok8static2.oktacdn.com/assets/js/sdk/okta-signin-widget/7.46.2/css/okta-sign-in.min.css"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous"/>
        <link rel="stylesheet" type="text/css" href="assets/css/Site.css"/>
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    </head>
    <body>
        <form id="form1" runat="server">
            <div class="limiter">
                <div class="container-login100">
                    <div class="login-banner">
                        <div class="login-background">
                            <p class="banner-text">Sign in with your Seiha Global Academy Account to access SGA LMS</p>
                        </div>
                    </div>
                    <div id="login-container">
                        <div class="sign-in-form">
                            <div class="sign-in-header auth-header">
                                <h1>
                                    <img src="assets/images/sgalogo.png" class="sign-in-logo" alt="Seiha Global Academy"/>
                                </h1>
                            </div>
                            <div class="sign-in-content">
                                <div class="sign-in-content-inner">
                                    <div class="sign-in-main-body">
                                        <div>
                                            <div class="sign-in-form-content sign-in-form-theme clearfix">
                                                <h2 class="sign-in-form-head">Log in</h2>
                                                <div>
                                                    <div id="stepUsername">
                                                        <div class="sign-in-form-fieldset">
                                                            <div class="sign-in-form-label sign-in-form-label">
                                                                <label>Username&nbsp;</label>
                                                            </div>
                                                            <div class="sign-in-form-input" style="margin-bottom: 20px;">
                                                                <span class="sign-in-form-input-name-identifier sign-in-form-control sign-in-form-input-field input-fix">
                                                                    <input type="text" placeholder="" name="identifier" id="input28" value="" aria-label="" autocomplete="username" aria-describedby="describe-username" required=""></span>
                                                            </div>
                                                        </div>
                                                        <div class="sign-in-form-button-bar">
                                                            <button type="button" class="button button-primary" onclick="showPasswordStep()">
                                                                <span class="button-arrow">
                                                                    <svg width="24" height="24" viewBox="0 0 24 24">  
                                                                        <path d="M5 12h14M13 6l6 6-6 6" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"></path>
                                                                    </svg>
                                                                </span>
                                                                <span class="button-text">Next</span>
                                                            </button>
                                                        </div>
                                                        <div class="siw-main-footer">
                                                            <div class="auth-footer">
                                                                <a data-se="unlock" href="#" class="link js-unlock">Unlock account?</a>
                                                                <a data-se="help" href="https://www.unimelb.edu.au/cybersecurity/mfa" target="_blank" rel="noopener noreferrer" class="link js-help">Help</a>
                                                                <a data-se="custom" href="https://www.unimelb.edu.au/cybersecurity/privacy" class="link js-custom">Privacy collection notice</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div id="stepPassword" style="display:none;">
                                                        <div class="sign-in-form-fieldset-container">
                                                            <div class="sign-in-form-fieldset sign-in-form-label-top">
                                                                <div class="sign-in-form-label sign-in-form-label">
                                                                    <label for="input55">Password&nbsp;</label>
                                                                </div>
                                                                <div class="sign-in-form-input" style="margin-bottom: 20px;">
                                                                    <span  class="sign-in-form-input-name-credentials.passcode sign-in-form-control sign-in-form-input-field input-fix">
                                                                        <input type="password" placeholder="" name="credentials.passcode" id="input55" value="" aria-label="" autocomplete="off" class="password-with-toggle" required="">
                                                                        <span class="password-toggle">
                                                                            <span class="eyeicon visibility-16 button-show"></span>
                                                                            <span class="eyeicon visibility-off-16 button-hide"></span>
                                                                        </span>
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                         <div id="loginError" runat="server" visible="false" class="login-error">
                                                            Your Username and Password is invalid!
                                                         </div>
                                                        <div class="sign-in-form-button-bar">
                                                            <button type="submit" class="button button-primary">
                                                                <span class="button-arrow">
                                                                    <svg width="24" height="24" viewBox="0 0 24 24">  
                                                                        <path d="M5 12h14M13 6l6 6-6 6" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"></path>
                                                                    </svg>
                                                                </span>
                                                                <span class="button-text">Verify</span>
                                                            </button>
                                                        </div>
                                                        <div class="siw-main-footer">
                                                            <div class="auth-footer">
                                                                <a data-se="forgot-password" href="#" class="link js-forgot-password">Forgot password?</a>
                                                                <a data-se="cancel" href="javascript:void(0);" class="link js-cancel" onclick="showUsernameStep();">Back to sign in</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
            </div>
        </form>
    <script src="assets/js/Site.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
    </body>
</html>
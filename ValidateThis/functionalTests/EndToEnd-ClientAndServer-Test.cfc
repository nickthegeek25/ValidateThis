component extends="cfselenium.CFSeleniumTestCase" displayName="EndToEndTests" {

    public void function beforeTests() {
        browserUrl = "http://localhost/validatethis/samples/FacadeDemo/";
        super.beforeTests();
        selenium.setTimeout(30000);
        crlf = chr(10);
    }

    private string function errLocator(name) {
    	return "css=p.errorField[htmlfor=#arguments.name#]";
    }

    public void function RunQUnitTests() {
        selenium.open("http://localhost/validatethis/unitTests/qunit/clientsidevalidators.cfm");
        selenium.waitForPageToLoad("30000");
        assertEquals(true, selenium.getTitle() contains "QUnit Test Suite");
        assertEquals("0", selenium.getText("css=span.failed"),"There seem to be QUnit test failures!");
    }

    public void function testEndToEndClient() {
        selenium.open("http://localhost/validatethis/samples/FacadeDemo/index.cfm?init=true");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForElementPresent(errLocator("UserName"));
        assertEquals("The Email Address is required.", selenium.getText(errLocator("UserName")));
        assertEquals("The Password is required.", selenium.getText(errLocator("UserPass")));
        assertEquals("The Verify Password is required.", selenium.getText(errLocator("VerifyPassword")));
        assertEquals("The User Group is required.", selenium.getText(errLocator("UserGroupId")));
        assertEquals("If you don't like Cheese and you don't like Chocolate, you must like something!", selenium.getText(errLocator("LikeOther")));
        selenium.type("Nickname", "BobRules");
        selenium.type("Salutation", "jj");
        selenium.type("FirstName", "bob");
        selenium.type("HowMuch", "a");
        selenium.click("AllowCommunication-1");
        selenium.click("//button[@type='submit']");
        selenium.waitForElementPresent(errLocator("Nickname"));
        assertEquals("That Nickname is already taken. Please try a different Nickname.", selenium.getText(errLocator("Nickname")));
        assertEquals("Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.", selenium.getText(errLocator("Salutation")));
        assertEquals("The Last Name is required if you specify a value for the First Name.", selenium.getText(errLocator("LastName")));
        assertEquals("The how much money would you like? must be a number.", selenium.getText(errLocator("HowMuch")));
        assertEquals("If you are allowing communication, you must choose a communication method.", selenium.getText(errLocator("CommunicationMethod")));
        selenium.type("UserName", "xxxx");
        selenium.click("//button[@type='submit']");
        assertEquals("Hey, buddy, you call that an Email Address?", selenium.getText(errLocator("UserName")));
        selenium.type("UserName", "bob.silverberg@gmail.com");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("UserName")));
        selenium.type("Nickname", "different");
        selenium.typeKeys("Nickname", "different");
        selenium.type("UserPass", "a");
        selenium.typeKeys("UserPass", "a");
        selenium.type("VerifyPassword", "b");
        selenium.typeKeys("VerifyPassword", "b");
        assertEquals("", selenium.getText(errLocator("Nickname")));
        assertEquals("The password must be between 5 and 10 characters long.", selenium.getText(errLocator("UserPass")));
        assertEquals("The Verify Password must be the same as The Password.", selenium.getText(errLocator("VerifyPassword")));
        selenium.type("UserPass", "aaaaa");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("UserPass")));
        assertEquals("The Verify Password must be the same as The Password.", selenium.getText(errLocator("VerifyPassword")));
        selenium.type("VerifyPassword", "aaaaa");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("VerifyPassword")));
        selenium.select("UserGroupId", "label=Member");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("UserGroupId")));
        selenium.type("Salutation", "Dr");
        selenium.type("LastName", "bob");
        selenium.click("LikeCheese-1");
        selenium.type("HowMuch", "10");
        selenium.select("CommunicationMethod", "label=Email");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertFalse(selenium.isTextPresent("Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed."));
        assertFalse(selenium.isTextPresent("The Last Name is required if you specify a value for the First Name."));
        assertFalse(selenium.isTextPresent("If you don't like Cheese and you don't like Chocolate, you must like something!"));
        assertFalse(selenium.isTextPresent("Please enter a valid number."));
        assertFalse(selenium.isTextPresent("If you are allowing communication, you must choose a communication method."));
        selenium.click("link=Edit an Existing User");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals(false,selenium.isElementPresent(errLocator("FirstName")));
        assertEquals(false,selenium.isElementPresent(errLocator("LastName")));
        selenium.type("FirstName", "");
        selenium.type("LastName", "");
        selenium.click("//button[@type='submit']");
        assertEquals("The First Name is required.", selenium.getText(errLocator("FirstName")));
        assertEquals("The Last Name is required.", selenium.getText(errLocator("LastName")));
        selenium.type("FirstName", "a");
        selenium.typeKeys("FirstName", "a");
        selenium.type("LastName", "a");
        selenium.typeKeys("LastName", "a");
        assertNotEquals("This field is required.", selenium.getText(errLocator("FirstName")));
        assertNotEquals("This field is required.", selenium.getText(errLocator("LastName")));
    }

    public void function testEndToEndClientnewValidations() {
        selenium.open("http://localhost/validatethis/functionalTests/FacadeDemo/index.cfm?init=true&context=newValidations-client");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("UserName", "");
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        assertEquals("The Email Address is required.", selenium.getText(errLocator("UserName")));
        selenium.type("UserName", "a");
        selenium.click("//button[@type='submit']");
        assertEquals("The Email Address must be a valid date between 2010-01-01 and 2011-12-31.", selenium.getText(errLocator("UserName")));
        selenium.type("UserName", "2010-02-02");
        selenium.click("//button[@type='submit']");
        assertEquals("The Email Address must be a date in the future. The date entered must come after 2010-12-31.", selenium.getText(errLocator("UserName")));
        selenium.type("UserName", "2011-02-02");
        selenium.click("//button[@type='submit']");
        assertEquals("The Email Address must be a date in the past. The date entered must come before 2011-02-01.", selenium.getText(errLocator("UserName")));
        selenium.type("UserName", "2011-01-31");
        selenium.click("//button[@type='submit']");
        assertEquals("The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText(errLocator("UserName")));
        selenium.type("UserName", "2011-01-29");
        selenium.click("//button[@type='submit']");
        assertEquals("The Email Address was found in the list: 2011-01-29,2011-01-28.", selenium.getText(errLocator("UserName")));
        selenium.type("Nickname", "<input>");
        selenium.click("//button[@type='submit']");
        assertEquals("The Nickname cannot contain HTML tags.", selenium.getText(errLocator("Nickname")));
        selenium.type("Nickname", "something 2011-01-29 something else");
        selenium.click("//button[@type='submit']");
        assertEquals("The Nickname must not contain the values of properties named: UserName,UserPass.", selenium.getText(errLocator("Nickname")));
        selenium.type("Nickname", "something thePass something else");
        selenium.type("UserPass", "thePass");
        selenium.click("//button[@type='submit']");
        assertEquals("The Nickname must not contain the values of properties named: UserName,UserPass.", selenium.getText(errLocator("Nickname")));
        selenium.type("Nickname", "a");
        selenium.click("//button[@type='submit']");
        assertEquals("The Nickname did not match the required number of patterns.", selenium.getText(errLocator("Nickname")));
        selenium.type("Nickname", "aB?");
        selenium.click("//button[@type='submit']");
        assertEquals("The Nickname must be a valid url.", selenium.getText(errLocator("Nickname")));
        selenium.type("Nickname", "http://aB1.com");
        selenium.click("//button[@type='submit']");
        assertNotEquals("Please enter a valid URL.", selenium.getText(errLocator("Nickname")));
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        assertEquals("The Password is required.", selenium.getText(errLocator("UserPass")));
        selenium.type("UserPass", "@");
        selenium.click("//button[@type='submit']");
        assertEquals("The Password must be a valid boolean.", selenium.getText(errLocator("UserPass")));
        selenium.type("UserPass", "true");
        selenium.click("//button[@type='submit']");
        assertEquals("The Password must be false.", selenium.getText(errLocator("UserPass")));
        selenium.type("UserPass", "no");
        selenium.click("//button[@type='submit']");
        assertEquals("The Password must be true.", selenium.getText(errLocator("UserPass")));
        // test for optionality of dateRange
        selenium.type("FirstName", "2001-01-01");
        selenium.click("//button[@type='submit']");
        assertEquals("The First Name must be a valid date between 2010-01-01 and 2011-12-31.", selenium.getText(errLocator("FirstName")));
        selenium.type("LastName", "1.1");
        selenium.click("//button[@type='submit']");
        assertEquals("The Last Name must be an integer.", selenium.getText(errLocator("LastName")));
        selenium.type("FirstName", "");
        selenium.click("//button[@type='submit']");
        assertEquals("", selenium.getText(errLocator("FirstName")));

    }

    public void function testEndToEndServer() {
        selenium.open("http://localhost/validatethis/samples/FacadeDemo/index.cfm?init=true&noJS=true");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("The Email Address is required.#crlf#Hey, buddy, you call that an Email Address?",selenium.getText("error-UserName"));
        assertEquals("The Password is required.#crlf#The Password must be between 5 and 10 characters long.#crlf#The password must be between 5 and 10 characters long (expression).", selenium.getText("error-UserPass"));
        assertEquals("The Verify Password is required.", selenium.getText("error-VerifyPassword"));
        assertEquals("The User Group is required.", selenium.getText("error-UserGroupId"));
        assertEquals("If you don't like Cheese and you don't like Chocolate, you must like something!", selenium.getText("error-LikeOther"));
        selenium.type("Nickname", "BobRules");
        selenium.type("UserName", "aaa");
        selenium.type("UserPass", "aaa");
        selenium.type("VerifyPassword", "zzz");
        selenium.type("Salutation", "aa");
        selenium.type("FirstName", "aaa");
        selenium.type("HowMuch", "aaa");
        selenium.click("AllowCommunication-1");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("Hey, buddy, you call that an Email Address?",selenium.getText("error-UserName"));
        assertEquals("That Nickname has already been used. Try to be more original!", selenium.getText("error-Nickname"));
        assertEquals("The Password must be between 5 and 10 characters long.#crlf#The password must be between 5 and 10 characters long (expression).", selenium.getText("error-UserPass"));
        assertEquals("The Verify Password must be the same as the Password.", selenium.getText("error-VerifyPassword"));
        assertEquals("Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.", selenium.getText("error-Salutation"));
        assertEquals("The How much money would you like? must be a number.",selenium.getText("error-HowMuch"));
        assertEquals("If you are allowing communication, you must choose a communication method.", selenium.getText("error-CommunicationMethod"));
        assertEquals("The Last Name is required if you specify a value for the First Name.", selenium.getText("error-LastName"));
        selenium.type("UserName", "bob.silverberg@gmail.com");
        selenium.type("Nickname", "different");
        selenium.type("UserPass", "aaaaa");
        selenium.type("VerifyPassword", "aaaaa");
        selenium.select("UserGroupId", "label=Member");
        selenium.type("Salutation", "Mr");
        selenium.type("LastName", "aaa");
        selenium.click("LikeCheese-1");
        selenium.type("HowMuch", "999");
        selenium.click("AllowCommunication-2");
        selenium.click("AllowCommunication-1");
        selenium.select("CommunicationMethod", "label=Email");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals(false,selenium.isElementPresent("error-UserName"));
        assertEquals(false, selenium.isElementPresent("error-Nickname"));
        assertEquals(false, selenium.isElementPresent("error-UserPass"));
        assertEquals(false, selenium.isElementPresent("error-VerifyPassword"));
        assertEquals(false, selenium.isElementPresent("error-UserGroupId"));
        assertEquals(false, selenium.isElementPresent("error-Salutation"));
        assertEquals(false, selenium.isElementPresent("error-LastName"));
        assertEquals(false, selenium.isElementPresent("error-LikeOther"));
        assertEquals(false,selenium.isElementPresent("error-HowMuch"));
        assertEquals(false, selenium.isElementPresent("error-CommunicationMethod"));
        assertEquals("the user has been saved!", selenium.getText("successMessage"));
        selenium.click("link=Edit an Existing User");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("FirstName", "");
        selenium.type("LastName", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("The First Name is required.", selenium.getText("error-FirstName"));
        assertEquals("The Last Name is required.", selenium.getText("error-LastName"));
        selenium.type("FirstName", "bob");
        selenium.type("LastName", "bob");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals(false, selenium.isElementPresent("error-FirstName"));
        assertEquals(false, selenium.isElementPresent("error-LastName"));
        selenium.type("UserPass", "aaa");
    }

    public void function testEndToEndServer_Struct() {
        selenium.open("http://localhost/validatethis/samples/StructureDemo/index.cfm?init=true&noJS=true");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("The Email Address is required.#crlf#Hey, buddy, you call that an Email Address?",selenium.getText("error-UserName"));
        assertEquals("The Password is required.#crlf#The Password must be between 5 and 10 characters long.#crlf#The password must be between 5 and 10 characters long (expression).", selenium.getText("error-UserPass"));
        assertEquals("The Verify Password is required.", selenium.getText("error-VerifyPassword"));
        assertEquals("The User Group is required.", selenium.getText("error-UserGroupId"));
        assertEquals("If you don't like Cheese and you don't like Chocolate, you must like something!", selenium.getText("error-LikeOther"));
        selenium.type("Nickname", "BobRules");
        selenium.type("UserName", "aaa");
        selenium.type("UserPass", "aaa");
        selenium.type("VerifyPassword", "zzz");
        selenium.type("Salutation", "aa");
        selenium.type("FirstName", "aaa");
        selenium.type("HowMuch", "aaa");
        selenium.click("AllowCommunication-1");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("Hey, buddy, you call that an Email Address?",selenium.getText("error-UserName"));
        // Custom rules are not supported with structures (yet) 
        //assertEquals("That Nickname has already been used. Try to be more original!", selenium.getText("error-Nickname"));
        assertEquals("The Password must be between 5 and 10 characters long.#crlf#The password must be between 5 and 10 characters long (expression).", selenium.getText("error-UserPass"));
        assertEquals("The Verify Password must be the same as the Password.", selenium.getText("error-VerifyPassword"));
        assertEquals("Only Dr, Prof, Mr, Mrs, Ms, or Miss (with or without a period) are allowed.", selenium.getText("error-Salutation"));
        assertEquals("The How much money would you like? must be a number.",selenium.getText("error-HowMuch"));
        assertEquals("If you are allowing communication, you must choose a communication method.", selenium.getText("error-CommunicationMethod"));
        assertEquals("The Last Name is required if you specify a value for the First Name.", selenium.getText("error-LastName"));
        selenium.type("UserName", "bob.silverberg@gmail.com");
        selenium.type("Nickname", "different");
        selenium.type("UserPass", "aaaaa");
        selenium.type("VerifyPassword", "aaaaa");
        selenium.select("UserGroupId", "label=Member");
        selenium.type("Salutation", "Mr");
        selenium.type("LastName", "aaa");
        selenium.click("LikeCheese-1");
        selenium.type("HowMuch", "999");
        selenium.click("AllowCommunication-2");
        selenium.click("AllowCommunication-1");
        selenium.select("CommunicationMethod", "label=Email");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals(false,selenium.isElementPresent("error-UserName"));
        assertEquals(false, selenium.isElementPresent("error-Nickname"));
        assertEquals(false, selenium.isElementPresent("error-UserPass"));
        assertEquals(false, selenium.isElementPresent("error-VerifyPassword"));
        assertEquals(false, selenium.isElementPresent("error-UserGroupId"));
        assertEquals(false, selenium.isElementPresent("error-Salutation"));
        assertEquals(false, selenium.isElementPresent("error-LastName"));
        assertEquals(false, selenium.isElementPresent("error-LikeOther"));
        assertEquals(false,selenium.isElementPresent("error-HowMuch"));
        assertEquals(false, selenium.isElementPresent("error-CommunicationMethod"));
        assertEquals("the user has been saved!", selenium.getText("successMessage"));
        selenium.click("link=Edit an Existing User");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("FirstName", "");
        selenium.type("LastName", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("The First Name is required.", selenium.getText("error-FirstName"));
        assertEquals("The Last Name is required.", selenium.getText("error-LastName"));
        selenium.type("FirstName", "bob");
        selenium.type("LastName", "bob");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals(false, selenium.isElementPresent("error-FirstName"));
        assertEquals(false, selenium.isElementPresent("error-LastName"));
        selenium.type("UserPass", "aaa");
    }

    public void function testEndToEndServerNewValidations() {
        selenium.open("http://localhost/validatethis/functionalTests/FacadeDemo/index.cfm?init=true&noJS=true&context=newValidations-server");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        selenium.type("UserName", "");
        selenium.type("UserPass", "");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("ValidateThis Demo Page", selenium.getTitle());
        assertEquals("The Email Address is required.#crlf#The Email Address must be a valid date between 2010-01-01 and 2011-12-31.#crlf#The Email Address must be a date in the future. The date entered must come after 2010-12-31.#crlf#The Email Address must be a date in the past. The date entered must come before 2011-02-01.#crlf#The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        assertEquals("The Password is required.#crlf#The Password must be a valid boolean.#crlf#The Password must be true.#crlf#The Password must be false.", selenium.getText("error-UserPass"));
        assertEquals("The User Group Name is required.", selenium.getText("error-UserGroupName"));
        selenium.type("UserName", "b");
        selenium.type("Nickname", "abcd");
        selenium.type("UserPass", "c");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Nickname must not contain the values of properties named: UserName,UserPass.#crlf#1 patterns were matched but 3 were required.#crlf#The Nickname must be a valid URL.", selenium.getText("error-Nickname"));
        assertEquals("The Email Address must be a valid date between 2010-01-01 and 2011-12-31.#crlf#The Email Address must be a date in the future. The date entered must come after 2010-12-31.#crlf#The Email Address must be a date in the past. The date entered must come before 2011-02-01.#crlf#The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2010-02-02");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Email Address must be a date in the future. The date entered must come after 2010-12-31.#crlf#The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2011-02-02");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Email Address must be a date in the past. The date entered must come before 2011-02-01.#crlf#The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2011-01-31");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Email Address was not found in the list: 2011-01-30,2011-01-29.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2011-01-29");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Email Address was found in the list: 2011-01-29,2011-01-28.", selenium.getText("error-UserName"));
        selenium.type("UserName", "2011-01-30");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-UserName"));
        selenium.type("UserName", "2011-01-29");
        selenium.type("Nickname", "<a href=2011-01-29>");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Nickname cannot contain HTML tags.#crlf#The Nickname must not contain the values of properties named: UserName,UserPass.#crlf#The Nickname must be a valid URL.", selenium.getText("error-Nickname"));
        selenium.type("Nickname", "2011-01-29");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Nickname must not contain the values of properties named: UserName,UserPass.#crlf#2 patterns were matched but 3 were required.#crlf#The Nickname must be a valid URL.", selenium.getText("error-Nickname"));
        selenium.type("Nickname", "http://www.Abc.com");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-Nickname"));
        selenium.type("UserPass", "abc");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Password must be a valid boolean.#crlf#The Password must be true.#crlf#The Password must be false.", selenium.getText("error-UserPass"));
        selenium.type("UserPass", "yes");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Password must be false.", selenium.getText("error-UserPass"));
        selenium.type("UserPass", "0");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Password must be true.", selenium.getText("error-UserPass"));
        selenium.type("VerifyPassword", "a,b");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Verify Password size is not between 3 and 10.", selenium.getText("error-VerifyPassword"));
        selenium.type("VerifyPassword", "a,b,c");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-VerifyPassword"));
        selenium.type("VerifyPassword", "structbad");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Verify Password size is not between 3 and 10.", selenium.getText("error-VerifyPassword"));
        selenium.type("VerifyPassword", "structok");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-VerifyPassword"));
        selenium.type("VerifyPassword", "arraybad");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertEquals("The Verify Password size is not between 3 and 10.", selenium.getText("error-VerifyPassword"));
        selenium.type("VerifyPassword", "arrayok");
        selenium.click("//button[@type='submit']");
        selenium.waitForPageToLoad("30000");
        assertFalse(selenium.isElementPresent("error-VerifyPassword"));
    }
    
}

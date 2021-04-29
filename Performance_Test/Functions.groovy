def TryCatchErrorCode(File file, String responseCode, String strMessage){
	if(responseCode!="200"){
		file.append ("<div class='TableBorderTryCatchErrorCode'><span style='color:red;'>"+strMessage+":"+responseCode+"</span></div>");
	}
}


String getLAReportNameFromProductNameToCompareWithCreateInvoice(String str){
	switch (str) {
	   case "Number Game":
	       return "Number Game Win Loss";
	       break
	   case "Virtual Sports":
	       return "Virtual Sports Win Loss";
	       break;
	    case "Keno":
	       return "Keno Win Loss";
	       break;
	    case "AG Casino":
	       return "AG Casino Win Loss";
	       break;
		case "Macau Games":
	       return "Macau Games Win Loss";
	       break;
		case "Virtual Sports 2":
	       return "Virtual Sports 2 Win Loss";
	       break;
		case "Lottery":
	       return "Lottery Win Loss";
	       break;
		case "Arcadia Gaming":
	       return "Arcadia Gaming Win Loss";
	       break;
		case "SG":
	       return "Settlement Report";
	       break;
		case "AE Casino":
	       return "Settlement Report";
	       break;   
		case "Exchange":
	       return "Exchange Win Loss";
	       break;
		case "Gold Deluxe":
	       return "Settlement Report";
	       break;
		case "Sportsbook":
	       return "Licensee Performance in Details";
	       break;
		case "RNG Casino":
	       return "Settlement Report";
	       break;
		case "Virtual Games":
	       return "Settlement Report";
	       break;
		case "Sports Lottery":
	       return "Settlement Report";
	       break;  
		case "SA Gaming":
	       return "Settlement Report";
	       break;
		case "Indo 4D":
	       return "Settlement Report";
	       break;
		case "Saba.club":
	       return "Settlement Report";
	       break;
		case "Table Game":
	       return "Table Game Win Loss";
	       break;
		case "Allbet":
	       return "Settlement Report";
	       break;
		case "Colossus Bets":
	       return "Settlement Report";
	       break;
		case "Pragmatic":
	       return "Settlement Report";
	       break;
		case "Cash Out":
	       return "Settlement Report";
	       break;
		case "BA":
	       return "Settlement Report";
	       break;
	}
}

String getLAReportNameFromProductNameToCompareWithLicenseePerformanceInDetails(String str){
	switch (str) {
	   case "Number Game":
	       return "Number Game Win Loss";
	       break
	   case "Virtual Sports":
	       return "Virtual Sports Win Loss";
	       break;
	    case "Keno":
	       return "Keno Win Loss";
	       break;
	    case "AG Casino":
	       return "AG Casino Win Loss";
	       break;
		case "Macau Games":
	       return "Macau Games Win Loss";
	       break;
		case "Virtual Sports 2":
	       return "Virtual Sports 2 Win Loss";
	       break;
		case "Lottery":
	       return "Lottery Win Loss";
	       break;
		case "Arcadia Gaming":
	       return "Arcadia Gaming Win Loss";
	       break;
		case "SG":
	       return "Settlement Report";
	       break;
		case "AE Casino":
	       return "Settlement Report";
	       break;
		case "Exchange":
	       return "Exchange Win Loss";
	       break;
		case "Gold Deluxe":
	       return "Settlement Report";
	       break;
		case "Sportsbook":
	       return "Settlement Report";
	       break;
		case "RNG Casino":
	       return "Settlement Report";
	       break;
		case "Virtual Games":
	       return "Settlement Report";
	       break;
		case "Sports Lottery":
	       return "Settlement Report";
	       break;    
		case "SA Gaming":
	       return "Settlement Report";
	       break;
		case "Indo 4D":
	       return "Settlement Report";
	       break;
		case "Saba.club":
	       return "Settlement Report";
	       break;
		case "Table Game":
	       return "Table Game Win Loss";
	       break;
		case "Allbet":
	       return "Settlement Report";
	       break;
		case "Pragmatic":
	       return "Settlement Report";
	       break;
		case "BA":
	       return "Settlement Report";
	       break;
	}
}

String returnStatusFormat(String str){
	String string = str;
	if(string=="Fail"){
		return "<span style='color:#f33'>Fail</span>";
	}else if(string=="Pass"){
		return "<span style='color:#1d4'>Pass</span>";
	}
	return string;
}

String RemoveCommaInString(String str){
	/* This function will remove comma in String from -185,842.93 -> -185842.93*/
	String string = str;//.replaceAll("(","");
	if(string.indexOf(",")>=0){
		return string.replaceAll(",","");
	}
   	return string;
}

double ConvertStringToFloat(String str, Boolean FlagReturnZeroWhenNegative=false){
	String string = str;
	string = RemoveCommaInString(string);
	if(string.indexOf("(")>=0){
		string = "-"+string.substring(1,string.length()-1);
	}
	if(string=="Not_Found" || string==""){
		return 0;
	}
	double returnValue = Double.parseDouble(string);
	if(returnValue<0 && FlagReturnZeroWhenNegative==true){
		return 0;
	}
	
	return returnValue;
}


def WriteHeaderToReport(File file,String Licensee, String Report1, String Report2){
	file.append ("<div class='TableBorderStyleHeader'><span style='color:red;'>"+Licensee+"</span> - Compare Data bettwen <span style='color:red;'>"+Report1+"</span> & <span style='color:red;'>"+Report2+"</span></div>");
	file.append ("<div class='TableBorderStyleDataProperty'>&nbsp;</div>");
	file.append ("<div class='TableBorderStyleHeaderValue'>"+Report1+"</div>");
	file.append ("<div class='TableBorderStyleHeaderValue'>"+Report2+"</div>");
	file.append ("<div class='TableBorderStyleHeaderStatus'>Status</div>");
}
def WriteResultToReport(File file,String DataProperty, String value1, String value2, String Result){
	file.append ("<div class='TableBorderStyleDataProperty'>"+DataProperty+"</div>");
	file.append ("<div class='TableBorderStyleValue'>"+value1+"</div>");
	file.append ("<div class='TableBorderStyleValue'>"+value2+"</div>");
	file.append ("<div class='TableBorderStyleStatus'>"+Result+"</div>");
}
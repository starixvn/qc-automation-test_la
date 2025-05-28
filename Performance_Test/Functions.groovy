def TryCatchErrorCode(File file, String responseCode, String strMessage){
	if(responseCode!="200"){
		file.append ("<div class='TableBorderTryCatchErrorCode'><span style='color:red;'>"+strMessage+":"+responseCode+"</span></div>");
	}
}


String getLAReportNameFromProductNameToCompareWithCreateInvoice(String str){
	switch (str) {
		case "Sportsbook":
	       return "Licensee Performance in Details";
	       break;
		case "Number Game":
	       return "Vendor Payment Details";
	       break;
		case "BA":
	       return "Settlement Report";
	       break;
		case "Virtual Sports":
	       return "Settlement Report";
	       break;
		case "Saba Casino":
	       return "Settlement Report";
	       break;
	    case "RNG Keno":
	       return "Vendor Payment Details";
	       break;
	    case "AG Casino":
	       return "Vendor Payment Details";
	       break;
		case "Allbet":
	       return "Settlement Report";
	       break;
		case "Macau Games":
	       return "Vendor Payment Details";
	       break;
		case "Lottery":
	       return "Vendor Payment Details";
	       break;
		case "Exchange":
	       return "Vendor Payment Details";
	       break;
		case "Arcadia Gaming":
	       return "Vendor Payment Details";
	       break;
		case "Virtual Games":
	       return "Settlement Report";
	       break;
		case "SA Gaming":
	       return "Settlement Report";
	       break;
		case "Table Game":
	       return "Vendor Payment Details";
	       break;
		case "AE Sexy":
	       return "Vendor Payment Details";
	       break;
		case "GPI":
	       return "Settlement Report";
	       break;   
		case "Pragmatic":
	       return "Settlement Report";
	       break;
		case "SG":
	       return "Settlement Report";
	       break;		
		case "Togel 4D":
	       return "Vendor Payment Details";
	       break;		   
		case "WM":
	       return "Vendor Payment Details";
	       break;
		case "PG Soft":
	       return "Vendor Payment Details";
	       break;
		case "Joker":
	       return "Vendor Payment Details";
	       break;
		case "BG":
	       return "Vendor Payment Details";
	       break;
		case "MaxGame":
	       return "Vendor Payment Details";
	       break;	
		case "Habanero":
	       return "Vendor Payment Details";
	       break;
		case "CG":
	       return "Vendor Payment Details";
	       break;		
		case "Vgaming":
	       return "Settlement Report";
	       break;
		case "AdvantPlay":
	       return "Vendor Payment Details";
	       break;
		case "AdvantPlay Mini":
	       return "Vendor Payment Details";
	       break;
		case "FGG":
	       return "Vendor Payment Details";
	       break;
		case "SEAL Entertainment":
	       return "Settlement Report";
	       break;
		case "MG-RNG":
	       return "Settlement Report";
	       break;
		case "Jili":
	       return "Settlement Report";
	       break;
		case "YeeBet":
	       return "Settlement Report";
	       break;
		case "Live22":
	       return "Settlement Report";
	       break;
		case "WE Live Casino":
	       return "Settlement Report";
	       break;
		case "Nextspin":
	       return "Settlement Report";
	       break;
		case "FastSpin":
	       return "Settlement Report";
	       break;
		case "FA CHAI":
	       return "Settlement Report";
	       break;
		case "GPI Live Casino":
	       return "Settlement Report";
	       break;
		case "PLAYSTAR":
	       return "Settlement Report";
	       break;
		case "HOTDOG":
	       return "Settlement Report";
	       break;
		case "ON Casino":
	       return "Settlement Report";
	       break;
		case "Playtech":
	       return "Vendor Payment Details";
	       break;
		case "Playtech Live":
	       return "Vendor Payment Details";
	       break;
		case "ASKMESLOT":
	       return "Settlement Report";
	       break;
		case "Funky Games":
	       return "Vendor Payment Details";
	       break;
		case "Microgaming Live":
	       return "Settlement Report";
	       break;
		case "RichGaming":
	       return "Settlement Report";
	       break;
	}
}

String getLAReportNameFromProductNameToCompareWithLicenseePerformanceInDetails(String str){
	switch (str) {
		case "Sportsbook":
	       return "Settlement Report";
	       break;
		case "Number Game":
	       return "Vendor Payment Details";
	       break;
		case "BA":
	       return "Settlement Report";
	       break;
		case "Virtual Sports":
	       return "Settlement Report";
	       break;
		case "Saba Casino":
	       return "Settlement Report";
	       break;
	    case "RNG Keno":
	       return "Vendor Payment Details";
	       break;
	    case "AG Casino":
	       return "Vendor Payment Details";
	       break;
		case "Allbet":
	       return "Settlement Report";
	       break;
		case "Macau Games":
	       return "Vendor Payment Details";
	       break;
		case "Lottery":
	       return "Vendor Payment Details";
	       break;
		case "Exchange":
	       return "Vendor Payment Details";
	       break;
		case "Pragmatic":
	       return "Settlement Report";
	       break;
		case "Arcadia Gaming":
	       return "Vendor Payment Details";
	       break;   
		case "SG":
	       return "Settlement Report";
	       break;
		case "Virtual Games":
	       return "Settlement Report";
	       break;
		case "SA Gaming":
	       return "Settlement Report";
	       break;
		case "Table Game":
	       return "Vendor Payment Details";
	       break;		   
		case "AE Sexy":
	       return "Vendor Payment Details";
	       break;
		case "GPI":
	       return "Settlement Report";
	       break;
		case "Togel 4D":
	       return "Vendor Payment Details";
	       break;		   
		case "WM":
	       return "Vendor Payment Details";
	       break;
		case "PG Soft":
	       return "Vendor Payment Details";
	       break;
		case "Joker":
	       return "Vendor Payment Details";
	       break;
		case "BG":
	       return "Vendor Payment Details";
	       break;
		case "MaxGame":
	       return "Vendor Payment Details";
	       break;
		case "Habanero":
	       return "Vendor Payment Details";
	       break;
		case "CG":
	       return "Vendor Payment Details";
	       break;
		case "Vgaming":
	       return "Settlement Report";
	       break;
		case "AdvantPlay":
	       return "Vendor Payment Details";
	       break;
		case "AdvantPlay Mini":
	       return "Vendor Payment Details";
	       break;
		case "FGG":
	       return "Vendor Payment Details";
	       break;
		case "SEAL Entertainment":
	       return "Settlement Report";
	       break;
		case "MG-RNG":
	       return "Settlement Report";
	       break;
		case "Jili":
	       return "Settlement Report";
	       break;
		case "YeeBet":
	       return "Settlement Report";
	       break;
		case "Live22":
	       return "Settlement Report";
	       break;
		case "WE Live Casino":
	       return "Settlement Report";
	       break;
		case "Nextspin":
	       return "Settlement Report";
	       break;
		case "FastSpin":
	       return "Settlement Report";
	       break;
		case "FA CHAI":
	       return "Settlement Report";
	       break;
		case "GPI Live Casino":
	       return "Settlement Report";
	       break;
		case "PLAYSTAR":
	       return "Settlement Report";
	       break;
		case "HOTDOG":
	       return "Settlement Report";
	       break;
		case "ON Casino":
	       return "Settlement Report";
	       break;
		case "Playtech":
	       return "Vendor Payment Details";
	       break;
		case "Playtech Live":
	       return "Vendor Payment Details";
	       break;
		case "ASKMESLOT":
	       return "Settlement Report";
	       break;
		case "Funky Games":
	       return "Vendor Payment Details";
	       break;
		case "Microgaming Live":
	       return "Settlement Report";
	       break;
		case "RichGaming":
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
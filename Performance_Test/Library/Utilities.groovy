import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.services.sheets.v4.SheetsScopes;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.sheets.v4.Sheets;
import com.google.api.services.sheets.v4.SheetsRequestInitializer;
import com.google.api.services.sheets.v4.model.*;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import javax.xml.xpath.*
import javax.xml.parsers.DocumentBuilderFactory
import org.w3c.dom.Document;
import org.w3c.tidy.Tidy;
import java.io.*
import java.nio.charset.StandardCharsets


def convertColumnName(columnIndex) {
	def temp1,temp2, colName=''
	if( columnIndex >= 676)
		return null
	else if ( columnIndex < 676 && columnIndex >=26) {
		temp1= (columnIndex + 1) / 26
		temp2= (columnIndex + 1) % 26
		colName = (temp2 == 0 ? String.valueOf((char)(temp1 - 1 + 64)) : String.valueOf((char)(temp1 + 64))) + (temp2 == 0 ? 'Z' : String.valueOf((char)(temp2 + 64)))
	}
	else if (columnIndex >=0 && columnIndex <26) {
		colName = String.valueOf((char)(columnIndex + 1 + 64))
	}
	return colName
}

def getColumnName(value ,list) {
	for( int i = 0; i< list.size();i++) {
		if(list.get(i) == value)
			return convertColumnName(i)
	}
	return null
}
def getColumnIndex(value, list) {
	for( int i = 0; i< list.size();i++) {
		if(list.get(i) == value)
			return i
	}
	return null
}

def removeSyntax(str) {
	def list = ["\\{","\\}","\\\$"]
	for (def i=0;i<list.size();i++) {
		str=str.replaceAll(list.get(i),"")
	}
	return str
}

def setValueToSheet(nameOfSheet, nameOfColumn, columnList,rowIndex,value) {
	try {
		def columnName= getColumnName(nameOfColumn,columnList)
		return Arrays.asList(new ValueRange().setRange(nameOfSheet+"!"+columnName + (rowIndex+2)+ ":"+columnName + (rowIndex+2)).setValues(Arrays.asList(Arrays.asList(value.toString()))))
	} catch (Exception e) {
		return e.getMessage()
	}	 
}

def setValue(sheet, nameOfSheet, nameOfColumn, rowIndex,value) {
	try {
		def ColumnName = []
		for(def i=0; i<sheet.get(0).size(); i++){
			ColumnName.add(sheet.get(0).get(i))
		}
		def columnName = getColumnName(nameOfColumn,ColumnName)
		return Arrays.asList(new ValueRange().setRange(nameOfSheet+"!"+columnName + (rowIndex+2)+ ":"+columnName + (rowIndex+2)).setValues(Arrays.asList(Arrays.asList(value.toString()))))
	} catch (Exception e) {
		return e.getMessage()
	}
}

def getValueToList(sheet, nameColumn) {
	def columnIndex = -1
	def list = []
	try {
		for(def i = 0; i<sheet.get(0).size(); i++) {
			if(sheet.get(0).get(i)==nameColumn){
				columnIndex = i
				break;
			}
		}
		if(columnIndex==-1) throw new Exception("Name Column is invalid")
		else {
			for(def i =1; i<sheet.size();i++) {
				if(sheet.get(i).size() >= (columnIndex+1) && sheet.get(i).get(columnIndex)!="") { list.add(sheet.get(i).get(columnIndex).toString()) } else { list.add('') } 
			}
		}
		return list
	} catch (Exception e) {
		return e.getMessage()
	}
}

def getValue(sheet, rowIndex, nameColumn) {
	def columnIndex = -1
	def list = []
	try {
		for(def i = 0;i < sheet.get(0).size(); i++) {
			if(sheet.get(0).get(i)==nameColumn){
				columnIndex = i
				break;
			}
		}
		if(columnIndex==-1) throw new Exception("Name Column is invalid")
		if(!(rowIndex instanceof Integer)) {
			if (Integer.parseInt(rowIndex) >= sheet.size()) throw new Exception("Row number is invalid")
			else {
				return sheet.get(Integer.parseInt(rowIndex)).get(columnIndex).toString()
			}
		} else {
			if (rowIndex >= sheet.size()) throw new Exception("Row number is invalid")
			else {
				return sheet.get(rowIndex).get(columnIndex).toString()
			}		
		}
	} catch (Exception e) {
		return e.getMessage()
	}
}

def getValueToIntList(sheet, nameColumn) {
	try {
		def columnIndex = -1
		def list = []
		for(def i = 0; i<sheet.get(0).size(); i++) {
			if(sheet.get(0).get(i)==nameColumn){
				columnIndex = i
				break;
			}
		}
		if(columnIndex==-1) throw new Exception("Name Column is invalid")
		else {
			for(def i =1; i<sheet.size();i++) {
				if(sheet.get(i).size() >= (columnIndex+1) && sheet.get(i).get(columnIndex)!="") { list.add(Integer.parseInt(sheet.get(i).get(columnIndex).toString())) } else { list.add((int)0) } 
			}
		}
		return list
	} catch (Exception e) {
		return e.getMessage()
	}
}

def updateSheet(list,spreadsheets,url) {
	spreadsheets.values().batchUpdate(url,
					 new BatchUpdateValuesRequest().setData(list).setValueInputOption("RAW"))
					 .execute();   
}


def processXml( String xml, String xpathQuery) {
	try {
		def xpath = XPathFactory.newInstance().newXPath()
		Tidy tidy = new Tidy();
		tidy.setXHTML(true);
		tidy.setQuiet(true);
		tidy.setShowWarnings(false);
		tidy.setOutputEncoding("UTF-8");
		tidy.setInputEncoding("UTF-8");
		tidy.setForceOutput(true)
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream()
		Document TidyDOM = tidy.parseDOM(new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)), outputStream)
		xpath.evaluate( xpathQuery, TidyDOM)
	} catch (Exception e) {
		return e.getMessage()
	}

}

def WriteFile( String path,String content) {
	try {
		Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path), "UTF-8"));
		out.write(content)
		out.close();
		return "OK"
	} catch (Exception e) {
		return e.getMessage()
	}
}
def changeParam(String Str) {
	try {
		if( Str == "" ) return Str
		while(Str.contains('$'))
		{
			def regex= "\\\$\\{(.+?)\\}"
			def temp = Str =~ regex
			if(temp.find()) {
				Str = Str.replaceFirst(regex,vars.get(temp.group(1).toString()))
			} else throw new Exception("Script is invalid")
		}
		return Str
	} catch (Exception e) {
		log.info e.getMessage()
	}
}
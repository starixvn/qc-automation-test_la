import * as XLSX from 'xlsx';
import * as path from 'path';
import * as fs from 'fs';

export class ExcelComparison {
    /**
     * Compare web data with downloaded Excel data
     * @param webData - The data from the web page
     * @param excelFilePath - Path to the downloaded Excel file
     * @param sheetName - Name of the sheet to read (default: 'Sheet1')
     * @param cellReference - Excel cell reference to compare (e.g., 'B7')
     * @returns Promise<boolean> - true if data matches, false otherwise
     */
    static async compareWithExcel(
        webData: string,
        excelFilePath: string,
        sheetName: string = 'Sheet1',
        cellReference: string
    ): Promise<boolean> {
        try {
            // Check if file exists
            if (!fs.existsSync(excelFilePath)) {
                throw new Error(`Excel file not found at path: ${excelFilePath}`);
            }

            // Read the Excel file
            const workbook = XLSX.readFile(excelFilePath);
            const worksheet = workbook.Sheets[sheetName];

            if (!worksheet) {
                throw new Error(`Sheet '${sheetName}' not found in Excel file`);
            }

            // Get the cell value
            const excelValue = worksheet[cellReference]?.v;

            if (excelValue === undefined) {
                throw new Error(`Cell ${cellReference} not found in Excel file`);
            }

            // Convert both values to strings and trim whitespace
            const webDataStr = webData.toString().trim();
            const excelDataStr = excelValue.toString().trim();

            console.log('Comparing values:');
            console.log('Web data:', webDataStr);
            console.log('Excel data:', excelDataStr);

            // Compare the values
            return webDataStr === excelDataStr;
        } catch (error) {
            console.error('Error comparing with Excel:', error);
            throw error;
        }
    }

    /**
     * Get the latest downloaded Excel file from a directory
     * @param downloadDir - Directory where Excel files are downloaded
     * @returns string - Path to the latest Excel file
     */
    static getLatestExcelFile(downloadDir: string): string {
        const files = fs.readdirSync(downloadDir)
            .filter(file => file.endsWith('.xlsx') || file.endsWith('.xls'))
            .map(file => ({
                name: file,
                time: fs.statSync(path.join(downloadDir, file)).mtime.getTime()
            }))
            .sort((a, b) => b.time - a.time);

        if (files.length === 0) {
            throw new Error('No Excel files found in download directory');
        }

        return path.join(downloadDir, files[0].name);
    }

    /**
     * Clear all Excel files from the specified directory
     * @param directory - Directory to clear of Excel files
     * @returns boolean - true if successful, false if there was an error
     */
    static clearOldExcelFiles(directory: string): boolean {
        try {
            if (!fs.existsSync(directory)) {
                console.log(`Directory ${directory} does not exist, creating it`);
                fs.mkdirSync(directory, { recursive: true });
                return true;
            }

            console.log(`Clearing old Excel files from ${directory}`);
            const files = fs.readdirSync(directory);

            for (const file of files) {
                const filePath = path.join(directory, file);
                // Check if it's an Excel file
                if (file.endsWith('.xlsx') || file.endsWith('.xls')) {
                    console.log(`Removing old Excel file: ${filePath}`);
                    fs.unlinkSync(filePath);
                }
            }

            console.log('Cleared all old Excel files successfully');
            return true;
        } catch (error) {
            console.error('Error clearing old Excel files:', error);
            return false;
        }
    }
}
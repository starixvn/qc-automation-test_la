import { google } from 'googleapis';
import { JWT } from 'google-auth-library';
import { sheets_v4 } from 'googleapis';
import { GOOGLE_SHEETS_CONFIG } from '../dataset/googleapis';
import { ggsheetfile } from '../dataset/ggsheetfile';

export class GoogleSheetsAuth {
    private static instance: GoogleSheetsAuth;
    private authClient: JWT | null = null;
    private sheetsClient: sheets_v4.Sheets | null = null;

    private constructor() {}

    public static getInstance(): GoogleSheetsAuth {
        if (!GoogleSheetsAuth.instance) {
            GoogleSheetsAuth.instance = new GoogleSheetsAuth();
        }
        return GoogleSheetsAuth.instance;
    }

    /**
     * Authenticate with Google Sheets API
     * @returns Promise<void>
     * @throws Error if authentication fails
     */
    async authenticate(): Promise<void> {
        try {
            const auth = new google.auth.GoogleAuth({
                credentials: GOOGLE_SHEETS_CONFIG,
                scopes: ['https://www.googleapis.com/auth/spreadsheets.readonly']
            });

            const client = await auth.getClient();
            if (!(client instanceof JWT)) {
                throw new Error('Authentication failed: Not a JWT client');
            }

            this.authClient = client;
            this.sheetsClient = google.sheets({ version: 'v4', auth: this.authClient });
            console.log('Successfully authenticated with Google Sheets API');
        } catch (error) {
            console.error('Authentication failed:', error);
            throw error;
        }
    }

    /**
     * Get the authenticated sheets client
     * @returns sheets_v4.Sheets
     * @throws Error if not authenticated
     */
    getSheetsClient(): sheets_v4.Sheets {
        if (!this.sheetsClient) {
            throw new Error('Not authenticated. Call authenticate() first');
        }
        return this.sheetsClient;
    }

    /**
     * Get data from a specific range in a spreadsheet
     * @param range The A1 notation of the range to retrieve
     * @returns Promise<any[][]>
     * @throws Error if not authenticated or if fetch fails
     */
    async getSheetData(range: string, spreadsheetId: string): Promise<any[][]> {
        if (!this.sheetsClient) {
            throw new Error('Not authenticated. Call authenticate() first');
        }

        try {
            const response = await this.sheetsClient.spreadsheets.values.get({
                spreadsheetId: spreadsheetId,
                range: range
            });

            return response.data.values || [];
        } catch (error) {
            console.error('Failed to fetch sheet data:', error);
            throw error;
        }
    }
}